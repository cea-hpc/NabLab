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

KOKKOS_INLINE_FUNCTION
bool check(bool a);
template<size_t x>
KOKKOS_INLINE_FUNCTION
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
KOKKOS_INLINE_FUNCTION
double minR0(double a, double b);
KOKKOS_INLINE_FUNCTION
double sumR0(double a, double b);
KOKKOS_INLINE_FUNCTION
double prodR0(double a, double b);
KOKKOS_INLINE_FUNCTION
double maxR0(double a, double b);


/******************** Module declaration ********************/

class IterativeHeatEquation
{
public:
	struct Options
	{
		double X_LENGTH;
		double Y_LENGTH;
		double u0;
		RealArray1D<2> vectOne;
		size_t X_EDGE_ELEMS;
		size_t Y_EDGE_ELEMS;
		double X_EDGE_LENGTH;
		double Y_EDGE_LENGTH;
		double option_stoptime;
		size_t option_max_iterations;
		size_t option_max_iterations_k;
		double epsilon;

		Options(const std::string& fileName)
		{
			ifstream ifs(fileName);
			rapidjson::IStreamWrapper isw(ifs);
			rapidjson::Document d;
			d.ParseStream(isw);
			assert(d.IsObject());
			// X_LENGTH
			assert(d.HasMember("X_LENGTH"));
			const rapidjson::Value& valueof_X_LENGTH = d["X_LENGTH"];
			assert(valueof_X_LENGTH.IsDouble());
			X_LENGTH = valueof_X_LENGTH.GetDouble();
			// Y_LENGTH
			assert(d.HasMember("Y_LENGTH"));
			const rapidjson::Value& valueof_Y_LENGTH = d["Y_LENGTH"];
			assert(valueof_Y_LENGTH.IsDouble());
			Y_LENGTH = valueof_Y_LENGTH.GetDouble();
			// u0
			assert(d.HasMember("u0"));
			const rapidjson::Value& valueof_u0 = d["u0"];
			assert(valueof_u0.IsDouble());
			u0 = valueof_u0.GetDouble();
			// vectOne
			assert(d.HasMember("vectOne"));
			const rapidjson::Value& valueof_vectOne = d["vectOne"];
			assert(valueof_vectOne.IsArray());
			assert(valueof_vectOne.Size() == 2);
			for (size_t i1=0 ; i1<2 ; i1++)
			{
				assert(valueof_vectOne[i1].IsDouble());
				vectOne[i1] = valueof_vectOne[i1].GetDouble();
			}
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
			// option_max_iterations_k
			assert(d.HasMember("option_max_iterations_k"));
			const rapidjson::Value& valueof_option_max_iterations_k = d["option_max_iterations_k"];
			assert(valueof_option_max_iterations_k.IsInt());
			option_max_iterations_k = valueof_option_max_iterations_k.GetInt();
			// epsilon
			assert(d.HasMember("epsilon"));
			const rapidjson::Value& valueof_epsilon = d["epsilon"];
			assert(valueof_epsilon.IsDouble());
			epsilon = valueof_epsilon.GetDouble();
		}
	};

	Options* options;

	IterativeHeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;
	int n;
	int k;
	double t_n;
	double t_nplus1;
	double deltat;
	Kokkos::View<RealArray1D<2>*> X;
	Kokkos::View<RealArray1D<2>*> Xc;
	Kokkos::View<double*> xc;
	Kokkos::View<double*> yc;
	Kokkos::View<double*> u_n;
	Kokkos::View<double*> u_nplus1;
	Kokkos::View<double*> u_nplus1_k;
	Kokkos::View<double*> u_nplus1_kplus1;
	Kokkos::View<double*> V;
	Kokkos::View<double*> D;
	Kokkos::View<double*> faceLength;
	Kokkos::View<double*> faceConductivity;
	Kokkos::View<double**> alpha;
	double residual;
	int lastDump;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;
	typedef Kokkos::TeamPolicy<Kokkos::DefaultExecutionSpace::scratch_memory_space>::member_type member_type;

	KOKKOS_INLINE_FUNCTION
	void computeFaceLength(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeTn() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeV(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initD(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXc(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void setUpTimeLoopK() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void updateU(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeFaceConductivity(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeResidual(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopK() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initU(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void initXcAndYc(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeDeltaTn(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void tearDownTimeLoopK() noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void computeAlphaCoeff(const member_type& teamMember) noexcept;
	
	KOKKOS_INLINE_FUNCTION
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration);

public:
	void simulate();
};
