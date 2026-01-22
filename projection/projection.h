#pragma once
#include<cuda_runtime.h>

struct ProjectedPoint {
  float2 uv;
  float depth;
  int valid;
};

void cpu_project_points(
    const SystemConfig& cfg,
    const float3* points_world,
    int num_points,
    ProjectedPoint* out
);