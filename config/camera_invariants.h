#pragma once
#include <cmath>
#include <string>
#include <sstream>
#include "config/camera_config.h" 

inline bool is_finite(float x) { return std::isfinite(x); }

inline bool validate_camera_config(const CameraConfig& cam, std::string& err)
{
    auto fail = [&](const char* msg){
        err = msg;
        return false;
    };

    // Hard invariants
    if (cam.width <= 0 || cam.height <= 0) return fail("Camera: width/height must be > 0");
    if (!is_finite(cam.zoom.x) || !is_finite(cam.zoom.y) || cam.zoom.x <= 0.f || cam.zoom.y <= 0.f)
        return fail("Camera: zoom (fx,fy) must be finite and > 0");

    if (!is_finite(cam.center.x) || !is_finite(cam.center.y))
        return fail("Camera: center (cx,cy) must be finite");

    if (!is_finite(cam.distorsion.x) || !is_finite(cam.distorsion.y))
        return fail("Camera: distortion (k1,k2) must be finite");

    if (!is_finite(cam.position.x) || !is_finite(cam.position.y) || !is_finite(cam.position.z))
        return fail("Camera: position must be finite");

    for (int i = 0; i < 9; ++i) {
        if (!is_finite(cam.rotation[i]))
            return fail("Camera: rotation matrix contains NaN/Inf");
    }
    return true;
}

inline bool validate_system_config(const SystemConfig& cfg, std::string& err)
{
    auto fail = [&](const char* msg){
        err = msg;
        return false;
    };

    if (cfg.num_cameras <= 0 || cfg.num_cameras > MAX_CAMERA)
        return fail("SystemConfig: num_cameras must be in (0, MAX_CAMERA]");

    for (int i = 0; i < cfg.num_cameras; ++i) {
        std::string camErr;
        if (!validate_camera_config(cfg.cameras[i], camErr)) {
            std::ostringstream oss;
            oss << "SystemConfig: camera[" << i << "] invalid: " << camErr;
            err = oss.str();
            return false;
        }
    }
    return true;
}