/*******************************************************************************
 * Copyright (c) 2020 CEA
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
import org.eclipse.jgit.diff.DiffEntry.ChangeType
import org.eclipse.jgit.diff.DiffFormatter
import org.eclipse.jgit.lib.ObjectId
import org.eclipse.jgit.lib.Repository
import org.eclipse.jgit.revwalk.RevWalk
import org.eclipse.jgit.treewalk.CanonicalTreeParser
import org.eclipse.jgit.treewalk.FileTreeIterator
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

	def getModifiedFiles(String path)
	{
		val diffCommand = git.diff
		if (!path.nullOrEmpty)
			diffCommand.pathFilter = PathFilter.create(path)
		return diffCommand.call.filter[d | d.changeType == ChangeType::MODIFY]
	}

	def printDiffFor(String relativeFilePath)
	{
		val head = git.repository.resolve("HEAD")
		if(head === null) return

		val diffOutputStream = new ByteArrayOutputStream
		val formatter = new DiffFormatter(diffOutputStream)
		formatter.repository = git.repository
		formatter.setPathFilter(PathFilter.create(relativeFilePath.replaceAll("\\\\","/")));

		val commitTreeIterator = prepareTreeParser(git.repository, head.getName())
		val workTreeIterator = new FileTreeIterator(git.repository);

		// Scan gets difference between the two iterators.
		formatter.format(commitTreeIterator, workTreeIterator);

		println(diffOutputStream.toString)
	}

	private def prepareTreeParser(Repository repository, String objectId)
	{
		// from the commit we can build the tree which allows us to construct the TreeParser
		try (val walk = new RevWalk(repository))
		{
			val commit = walk.parseCommit(ObjectId.fromString(objectId))
			val tree = walk.parseTree(commit.tree.id)

			val oldTreeParser = new CanonicalTreeParser
			try (val oldReader = repository.newObjectReader)
			{
				oldTreeParser.reset(oldReader, tree.id)
			}

			walk.dispose
			return oldTreeParser
		}
	}
}