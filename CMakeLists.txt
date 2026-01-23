cmake_minimum_required(VERSION 3.22)

project(iris-lite LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)

add_executable(iris-lite
    main.cu
    cuda_helpers.cu
    config/camera_config.cu
)

target_include_directories(iris-lite PRIVATE include config)

set_target_properties(iris-lite PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
