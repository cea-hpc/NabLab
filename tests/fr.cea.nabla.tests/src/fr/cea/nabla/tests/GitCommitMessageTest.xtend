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

import org.junit.Test
import java.util.ArrayList
import java.util.List
import java.io.BufferedReader
import java.io.InputStreamReader
import java.util.stream.Collectors
import java.io.IOException
import org.assertj.core.api.Assertions
import org.junit.Assert
import org.junit.Assume

class GitCommitMessageTest
{
	static val START = "[" //$NON-NLS-1$

	static val END = "]" //$NON-NLS-1$

	static val GIT_COMMAND = #[ "git", "log", "-1" ] //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$

	static val KEYWORDS = List.of("cleanup", "doc", "fix", "releng", "test", "perf", "dev") //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$ //$NON-NLS-6$

	static val SIGNED_OFF_BY_PREFIX = "Signed-off-by:" //$NON-NLS-1$

	static val INVALID_GIT_MESSAGE_TITLE = "Invalid Git message title, it should either contain an issue number or one of our regular keywords (cleanup, doc, fix, releng, test, perf, dev)" //$NON-NLS-1$

	def runCommand()
	{
		var List<String> lines = new ArrayList<String>()
		try
		{
			val process = Runtime.getRuntime().exec(GIT_COMMAND)

			// @formatter:off
			try (
				val lineReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
				val errorReader = new BufferedReader(new InputStreamReader(process.getErrorStream()))
			)
			{
				lines = lineReader.lines().collect(Collectors.toList())
				Assertions.assertThat(errorReader.lines()).isEmpty()
			}
			// @formatter:on
		}
		catch (IOException e)
		{
			Assert.fail(e.getMessage())
		}
		return lines
	}

	def runningOnCI()
	{
		val event = System.getenv("GITHUB_EVENT_NAME") //$NON-NLS-1$
		//System.out.println(event)

		return System.getenv("CI") !== null && event.equals("push") //$NON-NLS-1$ //$NON-NLS-2$
	}

	/**
	 * Test the title of the commit message.
	 *
	 * <p>
	 * The title of the message can contain one of our standard keywords such as cleanup, doc, fix, releng, test, perf or dev in
	 * the following fashion:
	 * </p>
	 * <code>
	 * <pre>
	 * [doc] Title
	 * </pre>
	 * </code>
	 * <p>
	 * or even
	 * </p>
	 * <code>
	 * <pre>
	 * [cleanup] title
	 * </pre>
	 * </code>
	 * <p>
	 * Those keywords should only be used in very specific situations, most of the time the title of a commit message
	 * should have a reference to a bug. On top of that the full bug URL should be available later in the commit
	 * message.
	 * </p>
	 * <code>
	 * <pre>
	 * [XXX] Title
	 * </pre>
	 * </code>
	 */
	@Test
	def void testTitle()
	{
		Assume.assumeTrue(this.runningOnCI())
		val lines = this.runCommand()
		Assertions.assertThat(lines.size()).isGreaterThan(5)

		val title = lines.get(4).trim()
		Assertions.assertThat(title).startsWith(START).contains(END)

		val beginIndex = title.indexOf(START)
		val endIndex = title.indexOf(END)
		Assertions.assertThat(beginIndex).isLessThan(endIndex)

		Assertions.assertThat(lines.get(5)).isBlank()

		val tag = title.substring(beginIndex + 1, endIndex)
		if (!KEYWORDS.contains(tag))
		{
			try
			{
				Integer.valueOf(tag)
			}
			catch (NumberFormatException exception)
			{
				Assert.fail(INVALID_GIT_MESSAGE_TITLE)
			}
		}
	}

	@Test
	def void testSignedOffBy()
	{
		Assume.assumeTrue(this.runningOnCI())
		val lines = this.runCommand()
		Assertions.assertThat(lines).filteredOn(line | line.trim().startsWith(SIGNED_OFF_BY_PREFIX)).isNotEmpty()
	}
}