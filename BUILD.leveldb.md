# Installation of LevelDB for NabLab

## LevelDB installation

LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.

To install levelDB from GitHub repository

	git clone --recurse-submodules https://github.com/google/leveldb.git
	cd leveldb
	mkdir -p build && cd build
	cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
	make DESTDIR=$HOME/leveldb/leveldb-install install

The installed version is 1.22

## NabLab examples compilation

To generate code with levelDB support, add this block in nablagen (after VtkOutput block)

	LevelDB
	{
		levelDBPath = "$ENV{HOME}/leveldb/leveldb-install";
	}
 
 Then the json datafile wait for nonRegression field that could be CreateReference or CompareToReference.
 