KOKKOS_HOME = /home/lelandaisb/gmds_kokkos/kokkos-2.5.00-install
NABLALIB_HOME = ../../../fr.cea.nabla.cpplib
INCS = -I. -I$(NABLALIB_HOME)/src
NABLALIB = -L$(NABLALIB_HOME)/src -lnabla
TARGET = GlaceKokkos.exe
#CXXFLAGS += --std=c++11

all: $(TARGET)

include $(KOKKOS_HOME)/Makefile.kokkos

%.exe: %.cpp $(KOKKOS_LINK_DEPENDS) $(KOKKOS_CPP_DEPENDS)
	$(CXX) $(INCS) $(KOKKOS_CPPFLAGS) $(KOKKOS_CXXFLAGS) $< $(NABLALIB) $(KOKKOS_LDFLAGS) $(KOKKOS_LIBS) -o $@ 

clean:
	rm -f $(TARGET)
