cmake_minimum_required(VERSION 3.16)

if(NOT BUILD_PYTHON_INTERFACE)
  return()
endif()

find_package(Python COMPONENTS Interpreter Development REQUIRED)

include(FetchContent)
FetchContent_Declare(
  pybind11
  GIT_REPOSITORY https://github.com/pybind/pybind11.git
  GIT_TAG        v2.11.0
)
FetchContent_MakeAvailable(pybind11)

add_library(${PROJECT_NAME}_cpp MODULE module.cpp)
target_link_libraries(${PROJECT_NAME}_cpp PRIVATE ${PROJECT_NAME}_core pybind11::module)
target_include_directories(${PROJECT_NAME}_cpp PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../../include)

set_target_properties(${PROJECT_NAME}_cpp PROPERTIES PREFIX "")

install(TARGETS ${PROJECT_NAME}_cpp
        LIBRARY DESTINATION ${PROJECT_NAME})
