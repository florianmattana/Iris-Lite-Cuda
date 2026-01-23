#pragma once
#include <cmath>
#include <string>
#include <sstream>
#include "camera_config.h" 

inline bool is_finite(float x){return std::isfinite(x);};
inline bool is_finite2(float x, float y){return is_finite(x) && is_finite(y);};
inline bool is_finite3(float x, float y, float z){return is_finite(x) && is_finite(y) && is_finite(z);};

inline bool validate_camera_config(const CameraConfig& cam, std::string& err)
{
    auto fail = [&](const std::string& msg)
    {
        err = msg;
        return false;
    };

    if (cam.width <= 0 || cam.height <= 0)
        return fail("Camera: width/height must be > 0");

    // Intrinsics sanity
    if (!is_finite2(cam.zoom.x, cam.zoom.y) || cam.zoom.x <= 0.f || cam.zoom.y <= 0.f)
        return fail("Camera: zoom (fx, fy) must be finite and > 0");

    if (!is_finite2(cam.center.x, cam.center.y))
        return fail("Camera: center (cx, cy) must be finite");

    // Useful extra invariant: principal point typically within image (you can loosen this)
    if (cam.center.x < 0.f || cam.center.x > float(cam.width) ||
        cam.center.y < 0.f || cam.center.y > float(cam.height))
        return fail("Camera: center (cx, cy) is outside image bounds");

    // Distortion
    if (!is_finite2(cam.distorsion.x, cam.distorsion.y))
        return fail("Camera: distortion (k1, k2) must be finite");

    if (!is_finite3(cam.position.x, cam.position.y, cam.position.z))
        return fail("Camera: position must be finite");

    for (int i = 0; i < 9; ++i) 
    {
        if (!is_finite(cam.rotation[i])) 
        {
            std::ostringstream oss;
            oss << "Camera: rotation contains NaN/Inf at index " << i;
            return fail(oss.str());
        }
    }
    return true;
}


inline bool validate_system_config(const SystemConfig& cfg, std::string& err)
{
    auto fail = [&](const std::string& msg)
    {
        err = msg;
        return false;
    };

    if (cfg.num_cameras <= 0 || cfg.num_cameras > MAX_CAMERA)
    {
        std::ostringstream oss;
        oss << "SystemConfig: num_cameras must be in (0, MAX_CAMERA] but got " << cfg.num_cameras;
        return fail(oss.str());
    }

    for (int i = 0; i < cfg.num_cameras; ++i)
    {
        std::string camErr;
        if (!validate_camera_config(cfg.cameras[i], camErr)) {
            std::ostringstream oss;
            oss << "SystemConfig: camera[" << i << "] invalid: " << camErr;
            return fail(oss.str());
        }
    }
    return true;
}