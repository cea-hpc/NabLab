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
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "utils/kokkos/Parallel.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

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
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		size_t X_EDGE_ELEMS;
		size_t Y_EDGE_ELEMS;
		double option_stoptime;
		size_t option_max_iterations;
		double PI;
		double alpha;

		Options(const std::string& fileName)
		{
			ifstream ifs(fileName);
			rapidjson::IStreamWrapper isw(ifs);
			rapidjson::Document d;
			d.ParseStream(isw);
			assert(d.IsObject());
			// X_EDGE_LENGTH
			assert(d.HasMember("X_EDGE_LENGTH"));
			const rapidjson::Value& valueof_X_EDGE_LENGTH = d["X_EDGE_LENGTH"];
			assert(valueof_X_EDGE_LENGTH.IsDouble());
			X_EDGE_LENGTH = valueof_X_EDGE_LENGTH.GetDouble();
			// Y_EDGE_LENGTH
			assert(d.HasMember("Y_EDGE_LENGTH"));
			const rapidjson::Value& valueof_Y_EDGE_LENGTH = d["Y_EDGE_LENGTH"];
			assert(valueof_Y_EDGE_LENGTH.IsDouble());
			Y_EDGE_LENGTH = valueof_Y_EDGE_LENGTH.GetDouble();
			// X_EDGE_ELEMS
			assert(d.HasMember("X_EDGE_ELEMS"));
			const rapidjson::Value& valueof_X_EDGE_ELEMS = d["X_EDGE_ELEMS"];
			assert(valueof_X_EDGE_ELEMS.IsInt());
			X_EDGE_ELEMS = valueof_X_EDGE_ELEMS.GetInt();
			// Y_EDGE_ELEMS
			assert(d.HasMember("Y_EDGE_ELEMS"));
			const rapidjson::Value& valueof_Y_EDGE_ELEMS = d["Y_EDGE_ELEMS"];
			assert(valueof_Y_EDGE_ELEMS.IsInt());
			Y_EDGE_ELEMS = valueof_Y_EDGE_ELEMS.GetInt();
			// option_stoptime
			assert(d.HasMember("option_stoptime"));
			const rapidjson::Value& valueof_option_stoptime = d["option_stoptime"];
			assert(valueof_option_stoptime.IsDouble());
			option_stoptime = valueof_option_stoptime.GetDouble();
			// option_max_iterations
			assert(d.HasMember("option_max_iterations"));
			const rapidjson::Value& valueof_option_max_iterations = d["option_max_iterations"];
			assert(valueof_option_max_iterations.IsInt());
			option_max_iterations = valueof_option_max_iterations.GetInt();
			// PI
			assert(d.HasMember("PI"));
			const rapidjson::Value& valueof_PI = d["PI"];
			assert(valueof_PI.IsDouble());
			PI = valueof_PI.GetDouble();
			// alpha
			assert(d.HasMember("alpha"));
			const rapidjson::Value& valueof_alpha = d["alpha"];
			assert(valueof_alpha.IsDouble());
			alpha = valueof_alpha.GetDouble();
		}
	};

	Options* options;

	HeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbNeighbourCells;
	int n;
	double t_n;
	double t_nplus1;
	const double deltat;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> center;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> f;
	Kokkos::View<double*> outgoingFlux;
	Kokkos::View<double*> surface;
	int lastDump;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

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

	void dumpVariables(int iteration);

public:
	void simulate();
};
