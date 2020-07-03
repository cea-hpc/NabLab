#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include <Kokkos_Core.hpp>
#include <Kokkos_hwloc.hpp>
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "mesh/kokkos/PvdFileWriter2D.h"
#include "utils/kokkos/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

KOKKOS_INLINE_FUNCTION
double det(RealArray1D<2> a, RealArray1D<2> b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double norm(RealArray1D<x> a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
double dot(RealArray1D<x> a, RealArray1D<x> b);
template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b);


/******************** Module declaration ********************/

class HeatEquation
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double stopTime;
		int maxIterations;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double PI;
		double alpha;

		Options(const std::string& fileName);
	};

	const Options& options;

	HeatEquation(const Options& aOptions);
	~HeatEquation();

private:
	// Global definitions
	double t_n;
	double t_nplus1;
	static constexpr double deltat = 0.001;
	int lastDump;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNeighbourCells, nbNodesOfFace, nbNodesOfCell;
	
	// Global declarations
	int n;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> center;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> outgoingFlux;
	Kokkos::View<double*> surface;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

	/**
	 * Utility function to get work load for each team of threads
	 * In  : thread and number of element to use for computation
	 * Out : pair of indexes, 1st one for start of chunk, 2nd one for size of chunk
	 */
	const std::pair<size_t, size_t> computeTeamWorkRange(const member_type& thread, const size_t& nb_elmt) noexcept;
	KOKKOS_INLINE_FUNCTION
	void computeOutgoingFlux(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeSurface(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeV(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void iniCenter(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void iniF(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeUn(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void iniUn(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	void simulate();
};
