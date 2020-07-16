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

	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initDij() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initFxy() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initRij() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initU() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initV() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXc() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateHouter() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateRij() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateUinner() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateUouter() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateVinner() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateVouter() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXcAndYc() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateHinner() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initH1() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopN() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration, bool useTimer=true);

public:
	void simulate();
};
