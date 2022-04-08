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
        std::vector<size_t>> execution_events,
        std::vector<std::string> python_path,
        std::vector<std::string> python_scripts,
        std::string interface_module,
        std::function<void (py::module_)> interface_module_initializer);
    ~MoniLog();

    void trigger(size_t event, std::shared_ptr<MoniLogExecutionContext> context);

    bool has_registered_moniloggers(size_t event);
    std::list<py::function> get_registered_moniloggers(size_t event);

private:
	std::vector<std::list<py::function>> registered_moniloggers;
    std::map<std::string, std::vector<size_t>> execution_events;
    std::shared_ptr<py::scoped_interpreter> guard;
};
#endif