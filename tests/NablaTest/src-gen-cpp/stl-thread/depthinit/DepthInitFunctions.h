#include <string>
#include <rapidjson/document.h>

class DepthInitFunctions
{
public:
	void jsonInit(const rapidjson::Value& json)
	{
		assert(json.IsObject());
		const rapidjson::Value::ConstObject& o = json.GetObject();

		if (o.HasMember("depth"))
		{
			const rapidjson::Value& valueof_depth = o["depth"];
			assert(valueof_depth.IsDouble());
			depth = valueof_depth.GetDouble();
		}

		// if the option is mandatory, the line should be:
		// assert(o.HasMember("fileName"));
		if (o.HasMember("fileName"))
		{
			const rapidjson::Value& valueof_fileName = o["fileName"];
			assert(valueof_fileName.IsString());
			fileName = valueof_fileName.GetString();
		}
	}

	double nextWaveHeight()
	{
		counter++;
		std::cout << counter << " " << fileName << ". Depth = " << depth << std::endl;
		return depth;
	}

private:
	int counter = 0;
	double depth = 4.3;
	std::string fileName = "";
};
