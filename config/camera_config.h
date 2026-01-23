#pragma once

#include<cuda_runtime.h>

#define MAX_CAMERA 4
#define NB_CAMERA MAX_CAMERA

struct CameraConfig {

    float4 position;     // → Où elle se trouve dans l'espace 3D
    float2 zoom;         // (fx, fy) => Zoon
    float2 center;     // (cx, cy) => center of the picture
    float2 distorsion;     // (k1, k2) => distorsion
    float rotation[9];   // rotation 3x3
    int width;
    int height;
};

struct SystemConfig
{
    int num_cameras; //enabled
    CameraConfig cameras[MAX_CAMERA]; //max
};

void init_camera(SystemConfig& systemConfig);