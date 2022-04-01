#ifndef __MONILOG_H_
#define __MONILOG_H_


#include <fstream>
#include <iomanip>
#include <type_traits>
#include <limits>
#include <utility>
#include <cmath>
#include <Python.h>
#include <pybind11/embed.h>
#include <pybind11/stl.h>

namespace py = pybind11;

struct MoniLogExecutionContext
{
    std::string name = "MoniLogExecutionContext";

    MoniLogExecutionContext() {}
    MoniLogExecutionContext(std::string name) : name(name) {}
    virtual ~MoniLogExecutionContext() = default;
};

class MoniLog
{
public:
    MoniLog();
    MoniLog(std::map<std::string,
        std::vector<int>> execution_events,
        std::vector<std::string> python_path,
        std::vector<std::string> python_scripts,
        std::string interface_module,
        std::function<void (py::module_)> interface_module_initializer);
    ~MoniLog();

    template <typename T>
    void trigger(unsigned int event, T context)
    {
        std::list<py::function> moniloggers = registered_moniloggers[event];
        for (py::function monilogger : moniloggers)
        {
            std::cout << context.name << "\n";
            py::object ctx = py::cast(context);
            std::cout << "2" << "\n";
            monilogger(context);
        }
    }

private:
	std::map<int, std::list<py::function>> registered_moniloggers;
    std::map<std::string, std::vector<int>> execution_events;
};
#endif