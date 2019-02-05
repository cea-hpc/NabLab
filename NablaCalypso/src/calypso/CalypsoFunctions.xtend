package calypso

class CalypsoFunctions 
{
	static val double DEG2RAD = Math::acos(-1.0)/180.0;
	static val double RME = 6367449.0;			// Earth's average meridional radius
	static val double DEG2M = RME * DEG2RAD;	// Coefficient to convert degrees to meters

	def double deg_to_rad(double deg) { deg * DEG2RAD }
	def double lat_to_m(double dy_lat) { dy_lat * DEG2M }
	def double lon_to_m(double dx_lon, double y_lat) 
	{ dx_lon * DEG2M * Math::cos(y_lat*DEG2RAD) }
}