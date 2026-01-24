# Iris Lite

Iris Lite is a small, production-minded CUDA prototype inspired by Skintelligent context: a multi-camera rig and a 3D digital twin pipeline.

The goal is not to ship the full reconstruction algorithm, but to demonstrate how to **engineer the GPU data layer properly**: clear data contracts, validation, memory lifetime, and a clean CPU↔GPU interface.

---

## What this repo demonstrates

- **Multi-camera data model** (intrinsics, extrinsics, distortion)
- **Explicit data contract**: what is static vs per-frame, who owns what, and how data is validated
- **GPU memory management**: allocations, copies, constant/global memory choices, buffer reuse
- **CUDA kernel orchestration**: launch configuration, error handling, basic profiling
- **Deterministic outputs** with CPU-side sanity checks to avoid “silent wrong results”

---

## Minimal pipeline (concept)

1. **Define & validate** camera rig parameters and geometry metadata on CPU
2. **Upload static data** once (camera params, mesh topology)
3. **Allocate reusable GPU buffers** (no per-frame cudaMalloc)
4. **Run per-frame kernels** to produce geometry outputs
5. **Read back** results for checks / debugging

---

## Repository structure (example)

- `src/`
  - `main.cu` — entry point and orchestration
  - `cuda_helpers.cu` / `kernels.h` — CUDA helpers
- `config/`
  - `camera_config.h` — camera params structures
  - `camera_config.cu` — camera params orchestration
  - `camera_invariant.h` — mesh / system structures
- `projection/`
  - `projection.h`
- `docs/`
  - `data_contract.md` — CPU↔GPU data contract (units, frames, invariants, versioning)

---

## Why "Iris Lite"?

"Iris" refers to the camera/vision layer: calibrated multi-view data feeding a 3D pipeline.
"Lite" reflects the scope: a focused prototype that proves engineering fundamentals.

---

## Status

This is an evolving prototype. The early milestones focus on correctness and clarity first,
then performance and scalability (4 → 8 cameras, larger meshes, buffer packing).

---

## How to build (Windows / CUDA)

> Update paths/toolkit versions based on your setup.

```bash
mkdir build
cd build
cmake ..
cmake --build . --config Release
