"""Python bindings for the myproject C++ library."""

from . import myproject_cpp as _cpp

__all__ = ["add_one", "__version__"]

__version__ = "0.0.1"

add_one = _cpp.add_one
