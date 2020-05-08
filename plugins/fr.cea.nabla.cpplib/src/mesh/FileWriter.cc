/*******************************************************************************
 * Copyright (c) 2020 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#include "FileWriter.h"
#include <experimental/filesystem>
#include <fstream>

using namespace std;

namespace nablalib
{
FileWriter::FileWriter(const string& moduleName, const string& outputDirName)
: m_module_name(moduleName)
{
	m_directory_name = outputDirName;
	if (!isDisabled() && !experimental::filesystem::exists(m_directory_name))
		throw std::invalid_argument("Output directory does not exist: " + m_directory_name);
}

FileWriter::~FileWriter() {}
}
