/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ir.generator.cpp

import fr.cea.nabla.ir.generator.JniNameMangler
import fr.cea.nabla.ir.ir.Arg
import fr.cea.nabla.ir.ir.BaseType
import fr.cea.nabla.ir.ir.Expression
import fr.cea.nabla.ir.ir.ExtensionProvider
import fr.cea.nabla.ir.ir.ExternFunction
import fr.cea.nabla.ir.ir.Function
import fr.cea.nabla.ir.ir.InternFunction
import fr.cea.nabla.ir.ir.IrType
import fr.cea.nabla.ir.ir.LinearAlgebraType
import fr.cea.nabla.ir.ir.PrimitiveType
import org.eclipse.xtend.lib.annotations.Data

@Data
class FunctionContentProvider
{
	protected val extension TypeContentProvider
	protected val extension ExpressionContentProvider
	protected val extension InstructionContentProvider

	protected def String getMacro() { null }

	def getDeclarationContent(Function it)
	'''
	«FOR v : variables BEFORE "template<" SEPARATOR ", " AFTER ">"»size_t «v.name»«ENDFOR»
	«IF macro !== null»«macro»«ENDIF»
	«returnType.cppType» «name»(«FOR a : inArgs SEPARATOR ', '»«a.type.cppType» «a.name»«ENDFOR»)'''

	def getDefinitionContent(InternFunction it)
	'''
		«getDeclarationContent»
		{
			«body.innerContent»
		}
	'''

	def getJniDefinitionContent(ExternFunction it, ExtensionProvider provider, String cppFullClassName)
	'''
		JNIEXPORT «returnType.jniType» JNICALL «JniNameMangler.getJniFunctionName(provider, it)»
		(JNIEnv *env, jobject self«FOR a : inArgs», «a.type.jniType» «a.name»«ENDFOR»)
		{
			«cppFullClassName»* _self = getObject(env, self);
			«FOR a : inArgs»
				// «a.name» to c_«a.name»
				«getJniInArgContent(a)»
			«ENDFOR»
			// native method call
			auto c_ret = _self->«name»(«FOR a : inArgs SEPARATOR ', '»c_«a.name»«ENDFOR»);
			// c_ret to ret
			«getJniReturnContent(returnType)»
			return ret;
		}
	'''

	private def getJniInArgContent(Arg it)
	{
		val t = type
		val nativeVarName = 'c_' + name
		switch t
		{
			BaseType:
			{
				val dim = t.sizes.size
				if (dim == 0)
					'''
						«t.primitive.cppType» «nativeVarName» = «name»;
					'''
				else
					'''
						«t.primitive.getName()»Array«t.sizes.size»D<«t.sizes.map[0].join(',')»> «nativeVarName»;
						«getJniInArrayContent(name, nativeVarName, t.primitive, t.sizes)»
					'''
			}
			LinearAlgebraType:
			'''
				auto& «nativeVarName» = *get«t.vectorOrMatrix»(env, self);
			'''
			default: throw new RuntimeException("Ooops. Can not be there, normally...")
		}
	}

	private def CharSequence getJniInArrayContent(String jniName, String nativeName, PrimitiveType t, Iterable<Expression> sizes)
	{
		val dim = sizes.size
		if (dim == 1)
		'''
				jsize «jniName»_size = env->GetArrayLength(«jniName»);
				«nativeName».resize(«jniName»_size);
				«t.jniType»* «jniName»_body = env->Get«t.cppType.toFirstUpper»ArrayElements(«jniName», JNI_FALSE);
				for (jsize i0=0; i0<«jniName»_size; i0++)
					«nativeName»[i0] = «jniName»_body[i0];
				env->Release«t.cppType.toFirstUpper»ArrayElements(«jniName», «jniName»_body, JNI_FALSE);
			'''
		else
		'''
				jsize «jniName»_size = env->GetArrayLength(«jniName»);
				«nativeName».resize(«jniName»_size);
				«val indexName = 'i' + (dim-1).toString»
				for (jsize «indexName»=0; «indexName»<«jniName»_size; «indexName»++)
				{
					«val innerJniName = jniName + '_i' + (dim-2).toString»
					«val innerJniType = (dim-1 == 1 ? t.jniType : 'jobject')»
					auto «innerJniName» = reinterpret_cast<«innerJniType»Array>(env->GetObjectArrayElement(«jniName», «indexName»));
					«getJniInArrayContent(innerJniName, nativeName + "[" + indexName + "]", t, sizes.tail)»
					env->DeleteLocalRef(«innerJniName»);
				}
			'''
	}

	private def getJniReturnContent(IrType t)
	{
		switch t
		{
			BaseType: getJniReturnContent("ret", "c_ret", t.primitive, t.sizes)
			LinearAlgebraType: 
			'''
				auto ret = newJava«t.vectorOrMatrix»(env, self, &c_ret);
			'''
			default: throw new RuntimeException("Ooops. Can not be there, normally...")
		}
	}

	private def CharSequence getJniReturnContent(String jniName, String nativeName, PrimitiveType t, Iterable<Expression> sizes)
	{
		val dim = sizes.size
		switch dim
		{
			case 0:
			'''
				«t.jniType» «jniName» = «nativeName»;
			'''
			case 1:
			'''
				size_t s = «nativeName».size();
				«t.jniType»Array «jniName» = env->New«t.cppType.toFirstUpper»Array(s);
				if («jniName» == NULL) return NULL;
				env->Set«t.cppType.toFirstUpper»ArrayRegion(«jniName», 0, s, «nativeName».data());
			'''
			default:
			'''
				jclass «jniName»_inner_class = env->FindClass("[Ljava/lang/«getJniArrayClass(t, dim-1)»");
				if («jniName»_inner_class == NULL) return NULL;
				jobjectArray «jniName» = env->NewObjectArray(«nativeName».size(), «jniName»_inner_class, NULL);
				if («jniName» == NULL) return NULL;
				«val indexName = 'i' + (dim-1).toString»
				for (size_t «indexName»=0; «indexName»<«nativeName».size(); «indexName»++)
				{
					«val innerJniName = jniName + '_i' + (dim-2).toString»
					«getJniReturnContent(innerJniName, nativeName + "[" + indexName + "]", t, sizes.tail)»
					env->SetObjectArrayElement(«jniName», «indexName», «innerJniName»);
					env->DeleteLocalRef(«innerJniName»);
				}
			'''
		}
	}

	private def getJniArrayClass(PrimitiveType t, int dim)
	{
		if (dim == 1) 
			switch t
			{
				case BOOL: 'Boolean'
				case INT: 'Integer'
				case REAL: 'Double'
			}
		else
			'Object'
	}

	private def getVectorOrMatrix(LinearAlgebraType it)
	{
		if (sizes.size == 1) "Vector"
		else "Matrix"
	}
}

@Data
class KokkosFunctionContentProvider extends FunctionContentProvider
{
	override getMacro()
	{
		"KOKKOS_INLINE_FUNCTION"
	}
}
