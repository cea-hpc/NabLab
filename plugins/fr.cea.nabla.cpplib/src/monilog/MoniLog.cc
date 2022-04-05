#include "MoniLog.h"

namespace py = pybind11;

MoniLog::MoniLog() {}

MoniLog::MoniLog(std::map<std::string,
	std::vector<size_t>> execution_events,
	std::vector<std::string> python_path,
	std::vector<std::string> python_scripts,
	std::string interface_module,
	std::function<void (py::module_)> interface_module_initializer)
: execution_events(execution_events)
{
    // Initializing the path of the Python interpreter.
    py::object append_to_path = py::module_::import("sys").attr("path").attr("append");
    for (size_t i = 0; i < python_path.size(); i++)
    {
        append_to_path(python_path[i]);
    }

    // Initializing the user-provided interface module exposing C++ variables to Python scripts.
	py::module_ interface_py_module = py::module_::import(interface_module.c_str());
	py::class_<MoniLogExecutionContext>(interface_py_module, "MoniLogExecutionContext");
	interface_module_initializer(interface_py_module);

    // Initializing the MoniLog Python module.
    py::module_ monilogModule = py::module_::import("monilog");
	monilogModule.def("_register", [&](py::str event, py::function monilogger)
	{
		try
		{
			std::vector<size_t> indexes = execution_events.at(event);
			for (auto idx : indexes)
			{
				std::list<py::function> moniloggers = registered_moniloggers[idx];
				std::list<py::function>::iterator it = std::find(moniloggers.begin(), moniloggers.end(), monilogger);
				// Can only register a monilogger once.
				if (it == moniloggers.end())
				{
					registered_moniloggers[idx].push_back(monilogger);
				}
			}
		}
		catch (const std::out_of_range& e)
		{
			std::cout << "No event named " << event << " was found." << std::endl;
		}
	});
	monilogModule.def("_stop", [&](py::str event, py::function monilogger)
	{
		try
		{
			std::vector<size_t> indexes = execution_events.at(event);
			for (auto idx : indexes)
			{
				{
					std::list<py::function> moniloggers = registered_moniloggers[idx];
					std::list<py::function>::iterator it = std::find(moniloggers.begin(), moniloggers.end(), monilogger);
					if (it != moniloggers.end())
					{
						moniloggers.erase(it);
						if (moniloggers.empty())
						{
							// No empty lists stored in map.
							registered_moniloggers.erase(idx);
						} else {
							registered_moniloggers[idx] = moniloggers;
						}
					}
				}
			}
		}
		catch (const std::out_of_range& e)
		{
			std::cout << "No event named " << event << " was found." << std::endl;
		}
	});

    // Loading the user-provided Python scripts containing monilogger definitions.
    for (size_t i = 0; i < python_scripts.size(); i++)
    {
        py::module_::import(python_scripts[i].c_str());
    }
}

MoniLog::~MoniLog() {}


bool MoniLog::has_registered_moniloggers(size_t event)
{
	return registered_moniloggers.count(event) > 0;
}

std::map<size_t, std::list<py::function>>::iterator MoniLog::get_registered_moniloggers(size_t event)
{
	// TODO: make it const.
	return registered_moniloggers.find(event);
}