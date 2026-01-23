#include<cuda_runtime.h>
#include<camera_config.h>
#include<camera_invariants.h>

static inline void set_identity(float R[9]) 
{
    std::memset(R, 0, 9 * sizeof(float));
    R[0] = 1.f; R[4] = 1.f; R[8] = 1.f;
}

void init_camera(SystemConfig& systemConfig)
{
    systemConfig.num_cameras = std::min(NB_CAMERA, MAX_CAMERA);

    for (int i = 0; i < systemConfig.num_cameras; ++i)
    {
        auto& cam = systemConfig.cameras[i];

        cam.width  = 1024;
        cam.height = 1024;

        cam.position  = make_float4(0.f, 0.f, 0.f, 1.f);
        cam.zoom      = make_float2(800.f, 800.f);
        cam.center    = make_float2(cam.width * 0.5f, cam.height * 0.5f);
        cam.distorsion= make_float2(0.f, 0.f);

        set_identity(cam.rotation);
    }
}