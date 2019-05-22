cmake_minimum_required(VERSION 3.1)
project(Test CXX)
list(APPEND CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS} -O3)
set(CMAKE_CXX_STANDARD 17)

add_subdirectory(src/test)
add_subdirectory(src/whiteheat)
