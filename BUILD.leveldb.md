# Installation of LevelDB for NabLab

## LevelDB installation

LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.

To install levelDB 1.23 version from GitHub repository

``` bash
	cd
	git clone https://github.com/google/leveldb.git -b 1.23 leveldb
	cd leveldb
	git submodule update --init
	mkdir build; cd build
	cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=~/leveldb/install
	make; make install
	cd ..; rm -rf build
```

## NabLab examples compilation

To generate code with levelDB support, add this block in nablagen (after VtkOutput block)

```
LevelDB
{
	leveldb_ROOT = "$ENV{HOME}/leveldb/install";
}
```

Then the json datafile waits for nonRegression field that could be CreateReference or CompareToReference.
 
## NabLabExamplesTest

To run NabLabExamplesTest, you have to set LEVELDB_HOME

```bash
export LEVELDB_HOME=$HOME/leveldb/install
```