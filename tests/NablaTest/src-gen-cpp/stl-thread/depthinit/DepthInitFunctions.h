#include <string>
#include <rapidjson/document.h>

class DepthInitFunctions
{
public:
	void jsonInit(const rapidjson::Value::ConstObject& d)
	{
		if (d.HasMember("depth"))
		{
			const rapidjson::Value& valueof_depth = d["depth"];
			assert(valueof_depth.IsDouble());
			depth = valueof_depth.GetDouble();
		}

		// if the option is mandatory, the line should be:
		// assert(d.HasMember("fileName"));
		if (d.HasMember("fileName"))
		{
			const rapidjson::Value& valueof_fileName = d["fileName"];
			assert(valueof_fileName.IsString());
			fileName = valueof_fileName.GetString();
		}
	}

	double nextWaveHeight() const
	{
		std::cout << "fileName = " << fileName << ", depth = " << depth << std::endl;
		return depth;
	}

private:
	double depth = 4.3;
	std::string fileName = "";
};
