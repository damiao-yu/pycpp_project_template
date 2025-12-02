#include <pybind11/pybind11.h>
#include "myproject/myproject.hpp"

namespace py = pybind11;

PYBIND11_MODULE(myproject_cpp, m) {
    m.doc() = "myproject C++ bindings";
    m.def("add_one", &myproject::add_one, "Add one to integer");
}
