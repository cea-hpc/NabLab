/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.ide.crossref

import com.google.common.base.Predicate
import com.google.inject.Inject
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.apache.log4j.Logger
import org.eclipse.xtext.CrossReference
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistEntry
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalPriorities
import org.eclipse.xtext.ide.editor.contentassist.IdeCrossrefProposalProvider
import org.eclipse.xtext.naming.QualifiedName
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
/**
 * Dedicated IdeCrossrefProposalProvider proposal used to workaround a problem of duplicated entry in the proposals see #distinctByQualifiedName
 */
class NablaIdeCrossrefProposalProvider extends IdeCrossrefProposalProvider
{
	val static Logger LOG = Logger.getLogger(NablaIdeCrossrefProposalProvider)

	@Inject protected IdeContentProposalPriorities proposalPriorities

	override void lookupCrossReference(IScope scope, CrossReference crossReference, ContentAssistContext context,
		IIdeContentProposalAcceptor acceptor, Predicate<IEObjectDescription> filter)
	{
		try
		{
			val queryResults = queryScope(scope, crossReference, context)

			// Remove duplicated qualified name proposals
			val filteredResult = distinctByQualifiedName(queryResults)

			for (IEObjectDescription candidate : filteredResult)
			{
				if (!acceptor.canAcceptMoreProposals())
				{
					return;
				}
				if (filter.apply(candidate))
				{
					val ContentAssistEntry entry = createProposal(candidate, crossReference, context)
					acceptor.accept(entry, proposalPriorities.getCrossRefPriority(candidate, entry))
				}
			}
		}
		catch (UnsupportedOperationException uoe)
		{
			LOG.error("Failed to create content assist proposals for cross-reference.", uoe)
		}
	}

	/**
	 * Removes all IEObjectDescription with a duplicated qualified name. This will prevent having both the <i>aliased</i> and the qualified name version which
	 *  is the observed behavior in the RCP integration. However the reason why we need to do this in the LSP version is still obscure because the code would suggest
	 * that this is already implemented by org.eclipse.xtext.scoping.impl.ImportScope.getAllElements().
	 * 
	 * <pre>{@code
	 * for (IEObjectDescription from : aliased) {
	 * 		QualifiedName qn = getIgnoreCaseAwareQualifiedName(from);
	 * 		elements.add(qn);
	 * 	}
	 * 	return concat(aliased, filter(globalElements, new Predicate<IEObjectDescription>() {
	 * 		@Override
	 * 		public boolean apply(IEObjectDescription input) {
	 * 			return !elements.contains(getIgnoreCaseAwareQualifiedName(input)); <1>
	 * 		}
	 * 	}));
	 * }</pre>
	 * 
	 * This code would work if the implementation of <i>org.eclipse.xtext.scoping.impl.ImportScope.getIgnoreCaseAwareQualifiedName(IEObjectDescription)</i> would be:
	 * 
	 * <pre>{@code
	 *    protected QualifiedName getIgnoreCaseAwareQualifiedName(IEObjectDescription from) {
	 *         return isIgnoreCase() ? from.getQualifiedName().toLowerCase() : from.getQualifiedName();
	 *     }
	 * }</pre>
	 * 
	 * Instead of the actual version:
	 * <pre>{@code
	 *  protected QualifiedName getIgnoreCaseAwareQualifiedName(IEObjectDescription from) {
	 *         return isIgnoreCase() ? from.getName().toLowerCase() : from.getName();
	 *     }
	 * }</pre>
	 * 
	 * My guess is that either, the nesting of ImportScope is different in the LSP integration than the RCP, causing this code to work only on RCP
	 * <b>or</b> the RCP integration has the same kind of post filter implemented in the editor.
	 */
	protected def List<IEObjectDescription> distinctByQualifiedName(Iterable<IEObjectDescription> queryResults)
	{
		val List<IEObjectDescription> filteredResult = new ArrayList()
		val Set<QualifiedName> qualifiedNames = new HashSet()

		for (IEObjectDescription e : queryResults)
		{
			val qn = e.qualifiedName
			if (!qualifiedNames.contains(qn))
			{
				qualifiedNames.add(qn)
				filteredResult.add(e)
			}
		}
		return filteredResult
	}

}
