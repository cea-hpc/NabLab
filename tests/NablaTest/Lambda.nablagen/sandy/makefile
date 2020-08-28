TARGET = glcNxtStp3

NABLA = /D/nabla/build/nabla/nablac.exe
CXX = g++

NFLAGS = -DALEPH_INDEX -DNB_PARTICLES=0 
CFLAGS = -std=c++11 -g -O2 -Wall -fno-strict-aliasing -DNO_SSE2 -mno-avx -finline
LIBS = /d/nabla/build/orgopt/libNablaOrgOpt.a

all: glcNxtStp3.cc
	$(CXX) $(CFLAGS) $(NFLAGS) $(TARGET).cc -o $(TARGET) $(LIBS)

%.cc: %.n
	$(NABLA) --lambda $(TARGET) --std --seq -i $(TARGET).n

cln:
	\rm *.h *.cc glcNxtStp3
