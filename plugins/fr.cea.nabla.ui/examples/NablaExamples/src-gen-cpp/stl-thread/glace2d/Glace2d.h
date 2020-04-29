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

using namespace nablalib;

/******************** Free functions declarations ********************/

RealArray1D<2> perp(RealArray1D<2> a);
template<size_t l>
RealArray2D<l,l> tensProduct(RealArray1D<l> a, RealArray1D<l> b);
template<size_t l>
double trace(RealArray2D<l,l> a);
RealArray2D<2,2> inverse(RealArray2D<2,2> a);
template<size_t x>
RealArray1D<x> sumR1(RealArray1D<x> a, RealArray1D<x> b);
double sumR0(double a, double b);
template<size_t x>
RealArray2D<x,x> sumR2(RealArray2D<x,x> a, RealArray2D<x,x> b);
double minR0(double a, double b);


/******************** Module declaration ********************/

class Glace2d
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
		double gamma;
		double option_x_interface;
		double option_deltat_ini;
		double option_deltat_cfl;
		double option_rho_ini_zg;
		double option_rho_ini_zd;
		double option_p_ini_zg;
		double option_p_ini_zd;

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
			// gamma
			assert(d.HasMember("gamma"));
			const rapidjson::Value& valueof_gamma = d["gamma"];
			assert(valueof_gamma.IsDouble());
			gamma = valueof_gamma.GetDouble();
			// option_x_interface
			assert(d.HasMember("option_x_interface"));
			const rapidjson::Value& valueof_option_x_interface = d["option_x_interface"];
			assert(valueof_option_x_interface.IsDouble());
			option_x_interface = valueof_option_x_interface.GetDouble();
			// option_deltat_ini
			assert(d.HasMember("option_deltat_ini"));
			const rapidjson::Value& valueof_option_deltat_ini = d["option_deltat_ini"];
			assert(valueof_option_deltat_ini.IsDouble());
			option_deltat_ini = valueof_option_deltat_ini.GetDouble();
			// option_deltat_cfl
			assert(d.HasMember("option_deltat_cfl"));
			const rapidjson::Value& valueof_option_deltat_cfl = d["option_deltat_cfl"];
			assert(valueof_option_deltat_cfl.IsDouble());
			option_deltat_cfl = valueof_option_deltat_cfl.GetDouble();
			// option_rho_ini_zg
			assert(d.HasMember("option_rho_ini_zg"));
			const rapidjson::Value& valueof_option_rho_ini_zg = d["option_rho_ini_zg"];
			assert(valueof_option_rho_ini_zg.IsDouble());
			option_rho_ini_zg = valueof_option_rho_ini_zg.GetDouble();
			// option_rho_ini_zd
			assert(d.HasMember("option_rho_ini_zd"));
			const rapidjson::Value& valueof_option_rho_ini_zd = d["option_rho_ini_zd"];
			assert(valueof_option_rho_ini_zd.IsDouble());
			option_rho_ini_zd = valueof_option_rho_ini_zd.GetDouble();
			// option_p_ini_zg
			assert(d.HasMember("option_p_ini_zg"));
			const rapidjson::Value& valueof_option_p_ini_zg = d["option_p_ini_zg"];
			assert(valueof_option_p_ini_zg.IsDouble());
			option_p_ini_zg = valueof_option_p_ini_zg.GetDouble();
			// option_p_ini_zd
			assert(d.HasMember("option_p_ini_zd"));
			const rapidjson::Value& valueof_option_p_ini_zd = d["option_p_ini_zd"];
			assert(valueof_option_p_ini_zd.IsDouble());
			option_p_ini_zd = valueof_option_p_ini_zd.GetDouble();
		}
	};

	Options* options;

	Glace2d(Options* aOptions, CartesianMesh2D* aCartesianMesh2D, string output);

private:
	CartesianMesh2D* mesh;
	PvdFileWriter2D writer;
	size_t nbNodes, nbCells, nbNodesOfCell, nbCellsOfNode, nbInnerNodes, nbOuterFaces, nbNodesOfFace;
	int n;
	double t_n;
	double t_nplus1;
	double deltat_n;
	double deltat_nplus1;
	std::vector<RealArray1D<2>> X_n;
	std::vector<RealArray1D<2>> X_nplus1;
	std::vector<RealArray1D<2>> X_n0;
	std::vector<RealArray1D<2>> b;
	std::vector<RealArray1D<2>> bt;
	std::vector<RealArray2D<2,2>> Ar;
	std::vector<RealArray2D<2,2>> Mt;
	std::vector<RealArray1D<2>> ur;
	std::vector<double> c;
	std::vector<double> m;
	std::vector<double> p;
	std::vector<double> rho;
	std::vector<double> e;
	std::vector<double> E_n;
	std::vector<double> E_nplus1;
	std::vector<double> V;
	std::vector<double> deltatj;
	std::vector<RealArray1D<2>> uj_n;
	std::vector<RealArray1D<2>> uj_nplus1;
	std::vector<std::vector<double>> l;
	std::vector<std::vector<RealArray1D<2>>> Cjr_ic;
	std::vector<std::vector<RealArray1D<2>>> C;
	std::vector<std::vector<RealArray1D<2>>> F;
	std::vector<std::vector<RealArray2D<2,2>>> Ajr;
	int lastDump;
	utils::Timer globalTimer;
	utils::Timer cpuTimer;
	utils::Timer ioTimer;

	void computeCjr() noexcept;
	
	void computeInternalEnergy() noexcept;
	
	void iniCjrIc() noexcept;
	
	void setUpTimeLoopN() noexcept;
	
	void computeLjr() noexcept;
	
	void computeV() noexcept;
	
	void initialize() noexcept;
	
	void computeDensity() noexcept;
	
	void executeTimeLoopN() noexcept;
	
	void computeEOSp() noexcept;
	
	void computeEOSc() noexcept;
	
	void computeAjr() noexcept;
	
	void computedeltatj() noexcept;
	
	void computeAr() noexcept;
	
	void computeBr() noexcept;
	
	void computeDt() noexcept;
	
	void computeBoundaryConditions() noexcept;
	
	void computeBt() noexcept;
	
	void computeMt() noexcept;
	
	void computeTn() noexcept;
	
	void computeU() noexcept;
	
	void computeFjr() noexcept;
	
	void computeXn() noexcept;
	
	void computeEn() noexcept;
	
	void computeUn() noexcept;

	void dumpVariables(int iteration);

public:
	void simulate();
};
