/*******************************************************************************
 * Copyright (c) 2022 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
package fr.cea.nabla.tests

import java.io.File
import java.io.IOException
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.ArrayList
import java.util.List
import java.util.regex.Pattern
import java.util.stream.Collectors
import org.hamcrest.MatcherAssert
import org.hamcrest.text.MatchesPattern
import org.junit.Assert
import org.junit.Test

class GeneralPurposeTest
{
	static val UNIX_PATH_SEPARATOR = "/" //$NON-NLS-1$

	static val WINDOWS_PATH_SEPARATOR = "\\" //$NON-NLS-1$

	static val GIT_FOLDER_NAME = ".git" //$NON-NLS-1$

	static val XTEND_FILE_EXTENSION = "xtend" //$NON-NLS-1$

	static val XML_FILE_EXTENSION = "xml" //$NON-NLS-1$

	static val XTEND_COPYRIGHT_HEADER = List.of(
			Pattern.compile(Pattern.quote("/*******************************************************************************")), //$NON-NLS-1$
			Pattern.compile(" \\* Copyright \\(c\\) [0-9]{4}(, [0-9]{4})* (.*)$"), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" * This program and the accompanying materials are made available under the")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" * terms of the Eclipse Public License 2.0 which is available at")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" * http://www.eclipse.org/legal/epl-2.0.")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" *")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" * SPDX-License-Identifier: EPL-2.0")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" * Contributors: see AUTHORS file")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" *******************************************************************************/"))) //$NON-NLS-1$

	static val XML_COPYRIGHT_HEADER = List.of(
			Pattern.compile(Pattern.quote("<!--")), //$NON-NLS-1$
			Pattern.compile("    Copyright \\(c\\) [0-9]{4}(, [0-9]{4})* (.*)$"), //$NON-NLS-1$
			Pattern.compile(Pattern.quote("    This program and the accompanying materials are made available under the")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote("    terms of the Eclipse Public License 2.0 which is available at")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote("    http://www.eclipse.org/legal/epl-2.0.")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote("")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote("    SPDX-License-Identifier: EPL-2.0")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote("    Contributors: see AUTHORS file")), //$NON-NLS-1$
			Pattern.compile(Pattern.quote(" -->"))) //$NON-NLS-1$

	def getRootFolder()
	{
		val path = System.getProperty("user.dir") //$NON-NLS-1$
		val classpathRoot = new File(path)

		var repositoryRootFolder = classpathRoot
		while (!new File(repositoryRootFolder, GIT_FOLDER_NAME).exists())
		{
			repositoryRootFolder = repositoryRootFolder.getParentFile()
		}

		return repositoryRootFolder
	}

	def findFilePaths(Path sourceFolderPath, String ext)
	{
		val filesPaths = new ArrayList<Path>()

		try (val paths = Files.walk(sourceFolderPath))
		{
			val filePaths = paths
				.filter(filePath | Files.isRegularFile(filePath))
				.filter(filePath | filePath.toFile().getName().endsWith(ext))
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/bin/")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/target/")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/.settings/")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/.metadata/")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/src-gen/")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/jgrapht-core")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/jlatexmath")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/leveldb")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains("/commons-math3")) //$NON-NLS-1$
				.filter(filePath | !filePath.toString().replace(WINDOWS_PATH_SEPARATOR, UNIX_PATH_SEPARATOR).contains(".polyglot")) //$NON-NLS-1$
				.collect(Collectors.toList());

			filesPaths.addAll(filePaths)
		}
		catch (IOException e)
		{
			Assert.fail(e.getMessage())
		}

		return filesPaths;
	}

	def void testXtendCopyrightHeader(Path filePath, List<String> lines)
	{
		Assert.assertTrue(lines.size() >= GeneralPurposeTest.XTEND_COPYRIGHT_HEADER.size())
		for (var i = 0; i < GeneralPurposeTest.XTEND_COPYRIGHT_HEADER.size(); i++)
		{
			MatcherAssert.assertThat("Invalid copyright header in " + filePath, lines.get(i), MatchesPattern.matchesPattern(GeneralPurposeTest.XTEND_COPYRIGHT_HEADER.get(i))) //$NON-NLS-1$
		}
	}

	def void testXmlCopyrightHeader(Path filePath, List<String> lines)
	{
		var xmlHeaderIncrement = 0
		while (lines.get(xmlHeaderIncrement).startsWith("<?"))
		{
			xmlHeaderIncrement++
		}
		Assert.assertTrue("Copyright missing in XML file " + filePath, lines.size() >= GeneralPurposeTest.XML_COPYRIGHT_HEADER.size() + xmlHeaderIncrement)

		for (var i = 0; i < GeneralPurposeTest.XML_COPYRIGHT_HEADER.size(); i++)
		{
			MatcherAssert.assertThat("Invalid copyright header in " + filePath, lines.get(i + xmlHeaderIncrement), MatchesPattern.matchesPattern(GeneralPurposeTest.XML_COPYRIGHT_HEADER.get(i))) //$NON-NLS-1$
		}
	}

	@Test
	def void checkXtendCode()
	{
		val rootFolderPath = Paths.get(this.getRootFolder().getAbsolutePath())
		val xtendFilePaths = this.findFilePaths(rootFolderPath, XTEND_FILE_EXTENSION)
		for (Path xtendFilePath : xtendFilePaths)
		{
			try
			{
				val lines = Files.readAllLines(xtendFilePath)
				this.testXtendCopyrightHeader(xtendFilePath, lines)
			}
			catch (IOException exception)
			{
				Assert.fail(exception.getMessage())
			}
		}
	}

	@Test
	def void checkXmlFiles()
	{
		val pluginsFolderPath = Paths.get(this.getRootFolder().getAbsolutePath())
		val xmlFilePaths = this.findFilePaths(pluginsFolderPath, XML_FILE_EXTENSION)
		for (Path xmlFilePath : xmlFilePaths.filter[x | x.toString.indexOf(".venv") == -1 && x.toString.indexOf(".metadata") == -1])
		{
			try
			{
				val lines = Files.readAllLines(xmlFilePath)
				this.testXmlCopyrightHeader(xmlFilePath, lines)
			}
			catch (IOException exception)
			{
				Assert.fail(exception.getMessage())
			}
		}
	}
}