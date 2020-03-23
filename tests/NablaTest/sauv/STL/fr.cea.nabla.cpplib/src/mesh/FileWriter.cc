/*******************************************************************************
 * Copyright (c) 2018 CEA
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
const string FileWriter::OutputDir = "output";

FileWriter::FileWriter(const string& moduleName, const string& baseDirName)
: m_module_name(moduleName), m_disabled(false)
{
  if (baseDirName.empty())
    m_directory_name = OutputDir;
  else if (baseDirName == "none" || baseDirName == "NONE")
    m_disabled = true;
  else
    m_directory_name = baseDirName + "/" + OutputDir;

  if (!m_disabled) {
    if (experimental::filesystem::exists(m_directory_name))
    	experimental::filesystem::remove_all(m_directory_name);
    experimental::filesystem::create_directory(m_directory_name);
  }
}

FileWriter::~FileWriter() {}
}
