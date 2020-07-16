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

template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);


/******************** Module declaration ********************/

class Schema_chap2
{
public:
	struct Options
	{
		std::string outputPath;
		int outputPeriod;
		double X_LENGTH;
		double Y_LENGTH;
		int X_EDGE_ELEMS;
		int Y_EDGE_ELEMS;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		int maxIter;
		double stopTime;

		void jsonInit(const rapidjson::Value::ConstObject& d);
	};

	const Options& options;

	Schema_chap2(const Options& aOptions);
	~Schema_chap2();

private:
	// Global definitions
	double t_n;
	double t_nplus1;
	static constexpr double deltat = 0.05;
	const double deltax;
	const double deltay;
	static constexpr double g = -9.8;
	static constexpr double C = 40.0;
	static constexpr double F = 1.0E-5;
	int lastDump;
	
	// Mesh (can depend on previous definitions)
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbFaces, nbInnerFaces, nbOuterFaces, nbInnerVerticalFaces, nbInnerHorizontalFaces, nbCompletelyInnerFaces, nbCompletelyInnerVerticalFaces, nbCompletelyInnerHorizontalFaces, nbCells, nbInnerCells, nbOuterCells, nbTopCells, nbBottomCells, nbLeftCells, nbRightCells, nbNeighbourCells, nbNodesOfCell, nbFacesOfCell, nbNodesOfFace, nbCellsOfFace;
	
	// Global declarations
	int n;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> Xc;
	Kokkos::View<double*> xc;
	Kokkos::View<double*> yc;
	Kokkos::View<double*> U_n;
	Kokkos::View<double*> U_nplus1;
	Kokkos::View<double*> U_n0;
	Kokkos::View<double*> V_n;
	Kokkos::View<double*> V_nplus1;
	Kokkos::View<double*> V_n0;
	Kokkos::View<double*> H_n;
	Kokkos::View<double*> H_nplus1;
	Kokkos::View<double*> H_n0;
	Kokkos::View<double*> Rij_n;
	Kokkos::View<double*> Rij_nplus1;
	Kokkos::View<double*> Rij_n0;
	Kokkos::View<double*> Fx;
	Kokkos::View<double*> Fy;
	Kokkos::View<double*> Dij;
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
	void computeTn() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initDij(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initFxy(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initRij(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initU(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initV(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXc(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateHouter(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateRij(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateUinner(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateUouter(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateVinner(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateVouter(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXcAndYc(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateHinner(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initH1(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	void simulate();
};
