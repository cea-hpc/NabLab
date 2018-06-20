package fr.cea.nabla

import fr.cea.nabla.nabla.Affectation
import fr.cea.nabla.nabla.And
import fr.cea.nabla.nabla.BoolConstant
import fr.cea.nabla.nabla.Comparison
import fr.cea.nabla.nabla.Equality
import fr.cea.nabla.nabla.FunctionCall
import fr.cea.nabla.nabla.If
import fr.cea.nabla.nabla.InstructionBlock
import fr.cea.nabla.nabla.InstructionJob
import fr.cea.nabla.nabla.IntConstant
import fr.cea.nabla.nabla.Loop
import fr.cea.nabla.nabla.MaxConstant
import fr.cea.nabla.nabla.MinConstant
import fr.cea.nabla.nabla.Minus
import fr.cea.nabla.nabla.MulOrDiv
import fr.cea.nabla.nabla.Not
import fr.cea.nabla.nabla.Or
import fr.cea.nabla.nabla.Parenthesis
import fr.cea.nabla.nabla.Plus
import fr.cea.nabla.nabla.Real2Constant
import fr.cea.nabla.nabla.Real2x2Constant
import fr.cea.nabla.nabla.Real3Constant
import fr.cea.nabla.nabla.Real3x3Constant
import fr.cea.nabla.nabla.RealConstant
import fr.cea.nabla.nabla.RealXCompactConstant
import fr.cea.nabla.nabla.ReductionCall
import fr.cea.nabla.nabla.ScalarVarDefinition
import fr.cea.nabla.nabla.SpaceIterator
import fr.cea.nabla.nabla.SpaceIteratorRange
import fr.cea.nabla.nabla.SpaceIteratorRef
import fr.cea.nabla.nabla.TimeIterator
import fr.cea.nabla.nabla.TimeIteratorRef
import fr.cea.nabla.nabla.TimeLoopJob
import fr.cea.nabla.nabla.UnaryMinus
import fr.cea.nabla.nabla.VarGroupDeclaration
import fr.cea.nabla.nabla.VarRef

class LatexLabelServices 
{
	// JOBS
	static def dispatch String getLatex(InstructionJob it) { '\\texttt{' + name.pu + '} : '+ instruction.latex }
	static def dispatch String getLatex(TimeLoopJob it) { '\\texttt{' + name.pu + '} : \\forall {' + iterator.latex + '}, \\ '+ body.latex }
	
	// INSTRUCTIONS	
	static def dispatch String getLabel(ScalarVarDefinition it) { type.literal + ' ' + variable.name.pu + '=' + defaultValue.latex }
	static def dispatch String getLabel(VarGroupDeclaration it) { type.literal + ' ' + variables.map[x|x.name.pu].join(', ') }
	static def dispatch String getLatex(InstructionBlock it) { '...' }
	static def dispatch String getLatex(Affectation it) { varRef?.latex + ' ' + op + ' ' + expression?.latex }
	static def dispatch String getLatex(Loop it) { '\\forall {' + iterator.latex + '}, \\ ' + body.latex }
	static def dispatch String getLatex(If it) { 'if (' + condition.latex + ')'}
	
	// ITERATEURS
	static def dispatch String getLatex(TimeIterator it) { name.pu + '\\in \u2115' }
	static def dispatch String getLatex(SpaceIterator it) { name.pu + '\\in ' + range.latex }
	static def dispatch String getLatex(SpaceIteratorRange it) { connectivity.name.pu + '(' + args.map[latex].join(',') + ')' }
	static def dispatch String getLatex(SpaceIteratorRef it) 
	{ 
		if (next) iterator.name.pu + '+1'
		else if (prev) iterator.name.pu + '-1'
		else iterator.name.pu
	}

	// EXPRESSIONS
	static def dispatch String getLatex(Or it) { left.latex + ' or ' + right.latex }
	static def dispatch String getLatex(And it) { left.latex + ' and ' + right.latex }
	static def dispatch String getLatex(Equality it) { left.latex + ' == ' + right.latex }
	static def dispatch String getLatex(Comparison it) { left.latex + ' ' + op + ' ' + right.latex }
	static def dispatch String getLatex(Plus it) { left.latex + ' + ' + right.latex }
	static def dispatch String getLatex(Minus it) { left.latex + ' - ' + right.latex }
	static def dispatch String getLatex(MulOrDiv it) 
	{ 
		if (op == '/')  '\\frac{' + left.latex + '}{' + right.latex + '}'
		else left.latex + ' \\cdot ' + right.latex
	}
	
	static def dispatch String getLatex(Parenthesis it) { '(' + expression.latex + ')' }
	static def dispatch String getLatex(UnaryMinus it) { '-' + expression.latex }
	static def dispatch String getLatex(Not it) { '\\neg {' + expression.latex + '}' }
	static def dispatch String getLatex(IntConstant it) { value.toString }
	static def dispatch String getLatex(RealConstant it) { value.toString }
	static def dispatch String getLatex(Real2Constant it) { '\\{' + x + ',' + y + '\\}' }	
	static def dispatch String getLatex(Real3Constant it) { '\\{' + x + ',' + y + ',' + z + '\\}' }	
	static def dispatch String getLatex(Real2x2Constant it) { '\\{' + x.latex + ',' + y.latex + '\\}' }	
	static def dispatch String getLatex(Real3x3Constant it) { '\\{' + x.latex + ',' + y.latex + ',' + z.latex + '\\}' }	
	static def dispatch String getLatex(BoolConstant it) { value.toString }
	static def dispatch String getLatex(RealXCompactConstant it) { type.literal + '(' + value + ')' }
	static def dispatch String getLatex(MinConstant it) { '-\u221E' }
	static def dispatch String getLatex(MaxConstant it) { '\u221E' }
	static def dispatch String getLatex(FunctionCall it) { function.name.pu + '(' + args.map[latex].join(',') + ')' }	
	static def dispatch String getLatex(ReductionCall it) { reduction.name.pu + '_{' + iterator.latex + '}' + '(' + arg.latex + ')' }
	static def dispatch String getLatex(VarRef it)
	{
		var label = variable.name.pu
		if (!spaceIterators.empty) label += '_{' + spaceIterators.map[x | x.latex].join(',') + '}'
		if (timeIterator !== null) label += ' ^{' + timeIterator.latex + '}'
		for (f : fields) label += '.' + f
		return label
	}
	
	static def dispatch String getLatex(TimeIteratorRef it) 
	{ 
		if (init) iterator.name.pu + "=" + value
		else if (next) iterator.name.pu + "+" + value
		else iterator.name.pu
	}
	
	// PRESERVE UNDERSCORES
	private static def String pu(String it) { if (!nullOrEmpty) replaceAll('_', '\\\\_') else '' }
}