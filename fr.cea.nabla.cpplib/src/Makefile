PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

OBJS = Real2.o Real3.o Real2x2.o Real3x3.o MathFunctions.o NumericMesh2D.o CartesianMesh2DGenerator.o
INCS = -I.
CXXFLAGS += --std=c++11
TARGET = libnabla.a

#ifeq ($(BUILD_MODE),debug)
#	CFLAGS += -g
#else ifeq ($(BUILD_MODE),run)
#	CFLAGS += -O2
#else
#	$(error Build mode $(BUILD_MODE) not supported by this Makefile)
#endif

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
