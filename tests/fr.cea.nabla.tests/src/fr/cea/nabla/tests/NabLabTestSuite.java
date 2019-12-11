package fr.cea.nabla.tests;

import org.junit.runner.RunWith;
import org.junit.runners.Suite;

@RunWith(Suite.class)

@Suite.SuiteClasses({
   BasicValidatorTest.class,
   TypeValidatorTest.class,
   DeclarationProviderTest.class,
   ExpressionTypeProviderTest.class,
   IteratorExtensionsTest.class,
   NablaScopeProviderTest.class,
   NablaParsingTest.class,
   NablagenParsingTest.class,
   ExpressionInterpreterTest.class,
   BinaryOperationsInterpreterTest.class,
   InstructionInterpreterTest.class,
   JobInterpreterTest.class,
   ModuleInterpreterTest.class
})

public class NabLabTestSuite {   
}  	