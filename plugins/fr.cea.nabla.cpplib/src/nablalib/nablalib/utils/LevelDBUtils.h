/*******************************************************************************
 * Copyright (c) 2021 CEA
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * http://www.eclipse.org/legal/epl-2.0.
 *
 * SPDX-License-Identifier: EPL-2.0
 * Contributors: see AUTHORS file
 *******************************************************************************/
#ifndef NABLALIB_UTILS_LEVELDBUTILS_H_
#define NABLALIB_UTILS_LEVELDBUTILS_H_

#include <leveldb/db.h>
#include <leveldb/write_batch.h>

namespace nablalib::utils
{
	struct KeyData {
		char dataName[64];
		int dataTypeBytes;
	};

	template <typename T>
	void putDB(leveldb::WriteBatch* batch, const char* dataName, int dataTypeBytes, T& dataValue)
	{
		KeyData key;
		memset(&key, 0, sizeof(KeyData));
		strncpy(key.dataName, dataName, 63);
		key.dataTypeBytes = dataTypeBytes;

		batch->Put(leveldb::Slice((const char*)&key, sizeof(KeyData)), leveldb::Slice((const char*)&dataValue, sizeof(dataValue)));
	}

	bool compareDB(const std::string& current, const std::string& ref)
	{
		// Final result
		bool result = true;

		// Loading ref DB
		leveldb::DB* db_ref;
		leveldb::Options db_options_ref;
		db_options_ref.create_if_missing = false;
		leveldb::Status status = leveldb::DB::Open(db_options_ref, ref, &db_ref);
		if (!status.ok())
		{
			std::cerr << "No ref database to compare with ! Looking for " << ref << std::endl;
			return false;
		}
		leveldb::Iterator* it_ref = db_ref->NewIterator(leveldb::ReadOptions());

		// Loading current DB
		leveldb::DB* db;
		leveldb::Options db_options;
		db_options.create_if_missing = false;
		status = leveldb::DB::Open(db_options, current, &db);
		assert(status.ok());

		leveldb::Iterator* it = db->NewIterator(leveldb::ReadOptions());

		// Results comparison
		std::cerr << "# Comparing results ..." << std::endl;
		for (it_ref->SeekToFirst(); it_ref->Valid(); it_ref->Next()) {
			KeyData* keyData = (KeyData*)(it_ref->key().data());
			std::string stringValue;
			auto status = db->Get(leveldb::ReadOptions(), it_ref->key(), &stringValue);
			if (status.IsNotFound()) {
				std::cerr << "ERROR - Key : " << keyData->dataName << " not found." << std::endl;
				result = false;
			}
			else {
				leveldb::Slice value = leveldb::Slice(stringValue);
				int mismatchIndex = value.compare(it_ref->value());
				if (mismatchIndex == 0)
					std::cerr << keyData->dataName << ": " << "OK" << std::endl;
				else if (mismatchIndex > 0){
					std::cerr << keyData->dataName << ": " << "ERROR" << std::endl;
					int bufSize = value.size();
					int bytes = keyData->dataTypeBytes;
					if (bufSize == bytes)
					{
						if (bytes == sizeof(int))
							std::cerr << "	" << *(int*)stringValue.data() << " (value) != " << *(int*)it_ref->value().data() << " (ref)" << std::endl;
						else if (bytes == sizeof(double))
							std::cerr << "	" << *(double*)stringValue.data() << " (value) != " << *(double*)it_ref->value().data() << " (ref)" << std::endl;
					}
					else if (bufSize % bytes == 0)
					{
						std::string stringRefValue(it_ref->value().ToString());
						if (bytes == sizeof(int))
							std::cerr << "	" << *(int*)stringValue.substr((mismatchIndex -1) * bytes, mismatchIndex * bytes - 1).data() << " (value[" << mismatchIndex -1 << "]) != " << *(int*)stringRefValue.substr((mismatchIndex -1) * bytes, mismatchIndex * bytes - 1).data() << " (ref[" << mismatchIndex -1 << "])" << std::endl;
						else if (bytes == sizeof(double))
							std::cerr << "	" << *(double*)stringValue.substr((mismatchIndex - 1)* bytes, mismatchIndex * bytes - 1).data() << " (value[" << mismatchIndex -1 << "]) != " << *(double*)stringRefValue.substr((mismatchIndex - 1)* bytes, mismatchIndex * bytes - 1).data()<< " (ref[" << mismatchIndex -1 << "])" << std::endl;
					}
					else
						std::cerr << "Unable to determine the type of data.";

					result = false;
				}
			}
		}

		// looking for key in the db that are not in the ref (new variables)
		for (it->SeekToFirst(); it->Valid(); it->Next()) {
			KeyData* keyData = (KeyData*)(it->key().data());
			std::string value;
			if (db_ref->Get(leveldb::ReadOptions(), it->key(), &value).IsNotFound()) {
				std::cerr << "ERROR - Key : " << keyData->dataName << " can not be compared (not present in the ref)." << std::endl;
				result = false;
			}
		}

		// Freeing memory
		delete db;
		delete db_ref;

		return result;
	}
}
#endif /* NABLALIB_UTILS_LEVELDBUTILS_H_ */
