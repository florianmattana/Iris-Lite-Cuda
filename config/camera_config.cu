#include<cuda_runtime.h>
#include<camera_config.h>

void init_camera (SystemConfig &systemConfig)
{
    systemConfig.num_cameras = MAX_CAMERA;

    for(int i = 0 ; i < systemConfig.num_cameras ; i++)
    {
        CameraConfig &cam = systemConfig.cameras[i];

        cam.position = make_float4(0.f, 0.f, 0.f, 0.f);

        cam.zoom = make_float2(800.0f, 600.0f);
        cam.center = make_float2(2.1f, 5.0f);
        cam.distorsion = make_float2(120.0f, 123.0f);

        cam.rotation[0] = 1.0; 
        cam.rotation[1] = 0.0; 
        cam.rotation[2] = 1.0; 
        cam.rotation[3] = 0.5; 
        cam.rotation[4] = 0.0; 
        cam.rotation[5] = 1.0; 
        cam.rotation[6] = 0.0; 
        cam.rotation[7] = 1.0; 
        cam.rotation[8] = 1.0; 
        cam.rotation[9] = 0.0; 

        cam.width = 1024;
        cam.height = 1024;
    }
} 