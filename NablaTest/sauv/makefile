TARGET = Glace2d

NABLA = ~/nabla/build/ncc/ncc
CXX = g++

NFLAGS = -DALEPH_INDEX -DNB_PARTICLES=0 
CFLAGS = -std=c++11 -g -O2 -Wall -fno-strict-aliasing -DNO_SSE2 -mno-avx -finline
LIBS = ~/nabla/build/orgopt/libNablaOrgOpt.a

all: Glace2d.cc
	$(CXX) $(CFLAGS) $(NFLAGS) $(TARGET).cc -o $(TARGET) $(LIBS)

%.cc: %.n
	$(NABLA) -t -v log.org --lambda $(TARGET) --std --seq -i $(TARGET).n

clean:
	\rm -f *.h *.cc Glace2d nabla_Glace2d_* Glace2d.time.dot log.org
