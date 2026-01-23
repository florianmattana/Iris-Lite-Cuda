#pragma once
#include<cuda_runtime.h>

struct alignas(16) ProjectedPoint {
  float2 uv;
  float depth;
  int valid;
};

static_assert(sizeof(ProjectedPoint) == 16);
static_assert(alignof(ProjectedPoint) == 16);

void cpu_project_points(
    const SystemConfig& cfg,
    const float3* points_world,
    int num_points,
    ProjectedPoint* out
);