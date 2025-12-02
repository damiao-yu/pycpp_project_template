cmake_minimum_required(VERSION 3.16)
project(myproject VERSION 0.0.1 LANGUAGES CXX)

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

# Derive common names from project() so renaming the project is easy.
set(PROJECT_EXPORT_NAME        "${PROJECT_NAME}Targets")
set(PROJECT_NAMESPACE          "${PROJECT_NAME}::")
set(PROJECT_CONFIG_INSTALL_DIR "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
set(PROJECT_CONFIG_FILE        "${PROJECT_NAME}Config.cmake")
set(PROJECT_VERSION_FILE       "${PROJECT_NAME}ConfigVersion.cmake")

option(BUILD_PYTHON_INTERFACE "Build Python bindings" ON)
option(BUILD_TESTING "Build tests" ON)

# Ensure C++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# add subprojects
add_subdirectory(src)
add_subdirectory(bindings)

# Optionally add examples if a CMakeLists.txt file is present
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/examples/CMakeLists.txt")
  add_subdirectory(examples)
endif()

# Optionally enable and add tests if requested and CMakeLists.txt is present
if(BUILD_TESTING AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/unittest/CMakeLists.txt")
  enable_testing()
  add_subdirectory(unittest)
endif()

# Export targets for use by find_package()
install(EXPORT ${PROJECT_EXPORT_NAME}
        NAMESPACE ${PROJECT_NAMESPACE}
        DESTINATION ${PROJECT_CONFIG_INSTALL_DIR})

# Configure and install CMake package config files
configure_package_config_file(
    cmake/ProjectConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_CONFIG_FILE}
    INSTALL_DESTINATION ${PROJECT_CONFIG_INSTALL_DIR}
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_VERSION_FILE}
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_CONFIG_FILE}
    ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_VERSION_FILE}
    DESTINATION ${PROJECT_CONFIG_INSTALL_DIR}
)
