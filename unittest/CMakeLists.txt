cmake_minimum_required(VERSION 3.16)

add_executable(test_basic test_basic.cpp)
target_link_libraries(test_basic PRIVATE ${PROJECT_NAME}_core)

add_test(NAME test_basic COMMAND test_basic)
