#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <rapidjson/document.h>
#include <rapidjson/istreamwrapper.h>
#include "mesh/CartesianMesh2DGenerator.h"
#include "mesh/CartesianMesh2D.h"
#include "mesh/PvdFileWriter2D.h"
#include "utils/Utils.h"
#include "utils/Timer.h"
#include "types/Types.h"
#include "types/MathFunctions.h"
#include "utils/stl/Parallel.h"
#include "linearalgebra/stl/LinearAlgebraFunctions.h"

using namespace nablalib;

/******************** Free functions declarations ********************/

template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
double minR0(double a, double b);
double sumR0(double a, double b);
double prodR0(double a, double b);


/******************** Module declaration ********************/

class ImplicitHeatEquation
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
		}
	};

	Options* options;

	ImplicitHeatEquation(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbFaces, nbNodesOfCell, nbNodesOfFace, nbCellsOfFace, nbNeighbourCells;
	int n;
	double t_n;
	double t_nplus1;
	double deltat;
	std::vector<RealArray1D<2>> X;
	std::vector<RealArray1D<2>> Xc;
	std::vector<double> xc;
	std::vector<double> yc;
	VectorType u_n;
	VectorType u_nplus1;
	std::vector<double> V;
	std::vector<double> D;
	std::vector<double> faceLength;
	std::vector<double> faceConductivity;
	NablaSparseMatrix alpha;
	int lastDump;
	LinearAlgebraFunctions::CGInfo cg_info; // CG details
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void computeFaceLength() noexcept;
	
	void computeTn() noexcept;
	
	void computeV() noexcept;
	
	void initD() noexcept;
	
	void initXc() noexcept;
	
	void updateU() noexcept;
	
	void computeFaceConductivity() noexcept;
	
	void initU() noexcept;
	
	void initXcAndYc() noexcept;
	
	void computeDeltaTn() noexcept;
	
	void computeAlphaCoeff() noexcept;
	
	void executeTimeLoopN() noexcept;

	void dumpVariables(int iteration);

public:
	void simulate();
};
