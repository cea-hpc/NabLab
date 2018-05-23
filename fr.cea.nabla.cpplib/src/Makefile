PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

OBJS = Real2.o Real3.o Real2x2.o Real3x3.o MathFunctions.o
INCS = .

#ifeq ($(BUILD_MODE),debug)
#	CFLAGS += -g
#else ifeq ($(BUILD_MODE),run)
#	CFLAGS += -O2
#else
#	$(error Build mode $(BUILD_MODE) not supported by this Makefile)
#endif

all: nablalib.a

nablalib.a:	$(OBJS)
	ar -rv $@ $^

%.o:	types/%.cpp 
	$(CXX) -I$(INCS) -c $(CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<

%.o:	mesh/%.cpp
	$(CXX) -I$(INCS) -c $(CFLAGS) $(CXXFLAGS) $(CPPFLAGS) -o $@ $<
clean:
	echo $(PROJECT_ROOT)
	rm -fr nablalib.a $(OBJS)
