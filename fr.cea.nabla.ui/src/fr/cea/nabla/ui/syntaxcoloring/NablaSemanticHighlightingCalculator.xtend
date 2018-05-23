package fr.cea.nabla.ui.syntaxcoloring

import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Action
import org.eclipse.xtext.CrossReference
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.ParserRule
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.TerminalRule
import org.eclipse.xtext.ide.editor.syntaxcoloring.IHighlightedPositionAcceptor
import org.eclipse.xtext.ide.editor.syntaxcoloring.ISemanticHighlightingCalculator
import org.eclipse.xtext.nodemodel.INode
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.util.CancelIndicator

class NablaSemanticHighlightingCalculator implements ISemanticHighlightingCalculator 
{
	override provideHighlightingFor(XtextResource resource, IHighlightedPositionAcceptor acceptor, CancelIndicator arg2) 
	{
		if (resource !== null && resource.parseResult !== null)
		{
			val root = resource.parseResult.rootNode			
			for (node : root.asTreeIterable) 
			{
				val elt = node.grammarElement
				if (elt !== null)
				{
					//println(debug(elt, 0))
					colorize(acceptor, node, elt)
				}
			}
		}
	}
	
//	private def String debug(EObject elt, int depth)
//	{
//		var s = ''
//		for (i : 0..<depth) s += '\t'
//		s += '*** ' + elt.class.name + ' : '
//		switch elt
//		{
//			TerminalRule : s += 'terminal ' + elt.name + ', ' + elt.type.classifier.name
//			Action: s += 'action ' + elt.feature
//			CrossReference: s += 'cross ref \n' + debug(elt.terminal, depth +1)
//			RuleCall: s += 'rule call \n' + debug(elt. rule, depth +1)
//			ParserRule: s+= 'parser rule ' + elt.name + ',' + elt.parameters
//			Keyword: s += 'keyword ' + elt.value
//			default: s += '?'
//		}
//		return s
//	}
	
	private def void colorize(IHighlightedPositionAcceptor a, INode n, EObject elt)
	{
		switch elt
		{
			TerminalRule : 
			{
				switch elt.name
				{
					case NablaHighlightingConfiguration::REAL_ID: colorizeNode(a, n, NablaHighlightingConfiguration::REAL_ID)
					case NablaHighlightingConfiguration::ID_ID: colorizeNode(a, n, NablaHighlightingConfiguration::ID_ID)
				}	
			}
			Action: {}
			CrossReference: {}
			RuleCall: colorize(a, n, elt.rule)
			ParserRule: 
			{
				switch elt.name
				{
					case 'SpaceIteratorRange' : colorizeIteratorArgs(a, n, NablaHighlightingConfiguration::ITERATOR_ID)
					case 'SpaceIterator',  
					case 'TimeIterator' : colorizeIteratorName(a, n, NablaHighlightingConfiguration::ITERATOR_ID) 
					case 'SpaceIteratorRef', 
					case 'TimeIteratorRef' : colorizeNode(a, n, NablaHighlightingConfiguration::ITERATOR_ID)
				}
			}
			Keyword: {}
			default: {}
		}
	}
	
	private def colorizeNode(IHighlightedPositionAcceptor acceptor, INode node, String colorId)
	{
		acceptor.addPosition(node.offset, node.length, colorId)
	}
	
	private def colorizeIteratorName(IHighlightedPositionAcceptor acceptor, INode node, String colorId)
	{
		val s = node.text.trim
		//println('node info - text:' + s + ', offset:' + node.offset + ', length:' + node.length)
		
		val lastIndex = s.indexOf('\u2208')
		if (lastIndex != -1)
			acceptor.addPosition(node.offset, lastIndex, colorId)
	}

	private def colorizeIteratorArgs(IHighlightedPositionAcceptor acceptor, INode node, String colorId)
	{
		val s = node.text.trim
		//println('node info - text:' + s + ', offset:' + node.offset + ', length:' + node.length)
		
		val offset = s.indexOf('(')
		val lastIndex = s.indexOf(')')
		val length = lastIndex-offset-1
		if (offset != -1 && lastIndex != -1 && length > 0)
			acceptor.addPosition(node.offset+offset+1, length, colorId)
	}
}