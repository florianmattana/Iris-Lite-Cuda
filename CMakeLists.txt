cmake_minimum_required(VERSION 3.22)

project(MyCudaProject LANGUAGES CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_STANDARD 17)

add_executable(my_app
    main.cu
    cuda_helpers.cu
    config/camera_config.cu
)

target_include_directories(my_app PRIVATE include config)

set_target_properties(my_app PROPERTIES
    CUDA_SEPARABLE_COMPILATION ON
)
