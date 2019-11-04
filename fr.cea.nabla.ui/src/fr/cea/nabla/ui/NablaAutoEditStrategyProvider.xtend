package fr.cea.nabla.ui

import org.eclipse.xtext.ui.editor.autoedit.DefaultAutoEditStrategyProvider

/**
 * Just to stop the bracket completion in case of a loop with a range like [n;m[
 */
class NablaAutoEditStrategyProvider extends DefaultAutoEditStrategyProvider
{
	protected override configure(IEditStrategyAcceptor acceptor)
	{
		configureIndentationEditStrategy(acceptor)
		configureStringLiteral(acceptor)
		configureParenthesis(acceptor)
		configureSquareBrackets(acceptor)
		configureCurlyBracesBlock(acceptor)
		configureMultilineComments(acceptor)
//		configureCompoundBracesBlocks(acceptor)
	}
}