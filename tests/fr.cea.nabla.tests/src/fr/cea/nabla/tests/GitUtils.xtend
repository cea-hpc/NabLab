/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the 
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import java.io.ByteArrayOutputStream
import java.io.File
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.diff.DiffFormatter
import org.eclipse.jgit.treewalk.CanonicalTreeParser
import org.eclipse.jgit.treewalk.FileTreeIterator
import org.eclipse.jgit.treewalk.filter.PathFilter
import org.eclipse.jgit.diff.DiffEntry
import java.util.ArrayList
import java.util.regex.Pattern

class GitUtils
{
	Git git

	new (String repoPath)
	{
		git = Git.open(new File(repoPath))
	}

	def getRepository()
	{
		return git.repository
	}

	def Boolean noGitDiff(String subPath, String moduleName)
	{
		//working tree
		var workingTreeIterator = new FileTreeIterator(git.repository)

		//master tree
		val treeParser = new CanonicalTreeParser();
		val treeId = repository.resolve( "master^{tree}" );
		try( val reader = repository.newObjectReader() ) {
		  treeParser.reset( reader, treeId );
		}

		//formatter
	    val outputStream = new ByteArrayOutputStream
		val formatter = new DiffFormatter(outputStream)
		formatter.setRepository(git.repository)
		formatter.setPathFilter(PathFilter.create(subPath))

		var diffs = formatter.scan(workingTreeIterator, treeParser)
		diffs =	diffs.filter[d | d.newPath.contains(moduleName)].toList
		var filteredDiffs = new ArrayList<DiffEntry>

		for (diff : diffs)
		{
			formatter.format(diff)
			formatter.flush();
			if (isNotKnownDiff(diff.newPath, outputStream.toString))
			{
				println(diff.changeType + " " + diff.newPath)
				filteredDiffs += diff
			}
			outputStream.reset()
		}

		return (filteredDiffs.empty)
	}

	private def isNotKnownDiff(String path, String diff)
	{
		// In CMakeLists.txt, "set(N_WS_PATH $ENV{HOME}/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples)" may be replaced by current workspace path
		if (path.endsWith("CMakeLists.txt") && diff.contains("+set(N_WS_PATH $ENV{HOME}/workspaces/NabLab/plugins/fr.cea.nabla.ui/examples)"))
		{
			var nbDiffs = 0
			val p = Pattern.compile("(@@)(.*?)(@@).*")
			val m = p.matcher(diff)
			while(m.find) nbDiffs ++
			return (nbDiffs > 1)
		}
		return true
	}
}