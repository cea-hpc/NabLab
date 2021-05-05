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

import java.io.File
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.diff.DiffEntry.ChangeType
import org.eclipse.jgit.treewalk.filter.PathFilter

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

	private def getModifiedFiles(String path)
	{
		val diffCommand = git.diff
		if (!path.nullOrEmpty)
			diffCommand.pathFilter = PathFilter.create(path)
		return diffCommand.call.filter[d | d.changeType == ChangeType::MODIFY]
	}

	def Boolean noGitDiff(String subPath, String moduleName)
	{
		var diffs = getModifiedFiles(subPath)
		diffs =	diffs.filter[d | d.newPath.contains(moduleName)]
		for (diff : diffs)
		{
			println(diff.changeType + " " + diff.newPath)
		}
		return (diffs.empty)
	}
}