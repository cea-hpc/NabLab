# Installation of LevelDB for NabLab

## LevelDB installation

LevelDB is a fast key-value storage library written at Google that provides an ordered mapping from string keys to string values.

To install 1.22 levelDB version from GitHub repository

```bash	
sudo install cmake

wget https://github.com/google/leveldb/archive/1.22.tar.gz leveldb.tar.gz
tar -zxvf leveldb.tar.gz
cd leveldb
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build .
```

## NabLab examples compilation

To generate code with levelDB support, add this block in nablagen (after VtkOutput block)
```
LevelDB
{
	levelDBPath = "$ENV{HOME}/leveldb/leveldb-install";
}
 ```
Then the json datafile wait for nonRegression field that could be CreateReference or CompareToReference.
 
