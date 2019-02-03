PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

Kokkos_HOME = /home/lelandaisb/kokkos/

OBJS = Real2.o Real3.o Real2x2.o Real3x3.o MathFunctions.o NumericMesh2D.o CartesianMesh2DGenerator.o VtkFileWriter2D.o
INCS = -I. -I${Kokkos_HOME}/kokkos/core/src -I${Kokkos_HOME}/kokkos-build
CXXFLAGS = --std=c++17
TARGET = libnabla.a

all: $(TARGET)

$(TARGET):	$(OBJS)
	ar -rv $@ $^

%.o:	types/%.cpp 
	$(CXX) $(INCS) -c $(CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.o:	mesh/%.cpp
	$(CXX) $(INCS) -c $(CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

clean:
	echo $(PROJECT_ROOT)
	rm -fr $(TARGET) $(OBJS)
