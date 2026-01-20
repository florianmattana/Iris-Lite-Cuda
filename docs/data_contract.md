Version: 0.1
Status: Draft (baseline contract)
Scope: Defines the data exchanged between CPU orchestration code and CUDA kernels for the Iris Lite prototype (multi-camera + 3D geometry processing).

======================================================================================================================================================

1) Goals
Functional goal
- Given a static rig configuration and per-frame inputs, the GPU produces per-frame outputs (e.g., updated vertices / reconstructed geometry).

Non-functional goals
- Avoid per-frame allocations (reuse buffers when possible).
- Make units, coordinate frames, and memory layout explicit.
- Fail fast on invalid inputs (CPU validation).

======================================================================================================================================================

2) Entities

2.1 Static data (loaded once, reused across frames)
    SystemConfig :
        - Number of cameras in the rig
        - Array of camera parameters

    MeshTopology
        -Triangle index buffer (read-only)

2.2 Per-frame data (changes every frame)

    FrameOutputs
        - vertices_out (and optional debug buffers)

======================================================================================================================================================

3) Data Structures (v0)

Notes:

- float2/float3/float4, int3 refer to CUDA built-in vector types.
- Arrays use SoA-style (separate arrays) for bandwidth/coalescing.

3.1 CameraConfig

Intrinsics : 

    zoom = (fx, fy) in pixels
    center = (cx, cy) in pixels
    Distortion
    distortion = (k1, k2) radial distortion coefficients (dimensionless)

Extrinsics :

    R[9] rotation matrix
    position translation vector
    Contract fields (example layout):
    float4 position (xyz used, w unused or padding)
    float2 zoom
    float2 center
    float2 distortion
    float R[9]
    int width, height

3.2 SystemConfig

int num_cameras
CameraConfig cameras[MAX_CAMERAS]

Constraints

    0 < num_cameras <= MAX_CAMERAS
    MAX_CAMERAS is a compile-time constant (v0 default: 8)

3.3 HandMesh (Geometry buffers)

    Topology (static)

        int3* triangles (size = numTriangles)
        Geometry (per-frame)
        float3* vertices_in (optional depending on kernel)
        float3* vertices_out (required if kernel updates geometry)
        Optional: float3* normals, float2* uvs

    Metadata

        int numVertices
        int numTriangles

    Constraints

        numVertices > 0
        numTriangles > 0
        Triangle indices must be in [0, numVertices-1]

======================================================================================================================================================

4) Semantics: units & coordinate frames

4.1 Units

    Positions (position, mesh vertices, translations): meters
    Intrinsics (fx, fy, cx, cy): pixels
    Distortion coefficients (k1, k2): dimensionless

4.2 Coordinate frames (v0 convention)

    World frame: project global reference frame
    Camera frame: camera local coordinates

Rotation R convention (v0)

    - R is row-major
    - R maps world → camera (world-to-camera)
      i.e. p_cam = R * p_world + t

Translation position convention (v0)

    - position represents t in the above equation (in meters)
    - If later you adopt camera-to-world, you MUST bump contract version and update validation/tests.

4.3 Image coordinate convention

    - Pixel origin: top-left
    - x increases to the right, y increases downward

======================================================================================================================================================

5) Memory placement (v0)

5.1 Constant memory candidates

    SystemConfig / CameraConfig[] may be placed in constant memory if it fits.
    Otherwise store in global memory and treat as read-only.

6.2 Global memory

    Large arrays: vertices_*, triangles, optional images, debug buffers.

6.3 Alignment / padding

    CUDA vector types may introduce padding (e.g., float3 alignment).
    Contract assumes compilation with consistent CUDA types on host/device.
    Do not rely on implicit packing; if binary serialization is used later, contract must specify exact byte layout.