#include "camera_config.h"
#include "camera_invariants.h"

#include<iostream>
#include <string>
#include <cstdlib>

int main ()
{
    SystemConfig h_config;

    init_camera(h_config);

    std::string err;

    if (!validate_system_config(h_config, err)) {
        std::cerr << err << "\n";
        return EXIT_FAILURE;
    }

    std::cout << "Config OK\n";

    return 0;
}