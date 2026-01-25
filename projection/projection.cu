#include<projection.h>

#include<cuda_runtime.h>

void cpu_project_points(const SystemConfig &systemConfig, const float3 *points_world, int num_points, ProjectedPoint *out)
{
    int camera_idx = 0;
    const CameraConfig& cam = systemConfig.cameras[camera_idx];
    const float* R = cam.rotation;

    for (int i = 0; i < num_points; ++i)
    {
        float3 p = points_world[i];

        // Monde -> caméra : P_cam = R * (P_world - C)
        float px = p.x - cam.position.x;
        float py = p.y - cam.position.y;
        float pz = p.z - cam.position.z;

        float X_cam = R[0]*px + R[1]*py + R[2]*pz;
        float Y_cam = R[3]*px + R[4]*py + R[5]*pz;
        float Z_cam = R[6]*px + R[7]*py + R[8]*pz;

    }
}
// Étapes pour réussir la fonction cpu_project_points
// 1. Récupérer les paramètres de la caméra depuis SystemConfig
    // Extraire la matrice de rotation R (ou les angles d'Euler)
    // Extraire le vecteur de translation T
    // Extraire les paramètres intrinsèques : fx, fy, cx, cy
// 2. Parcourir tous les points (boucle de 0 à num_points)
// 3. Pour chaque point : Transformer du repère monde vers le repère caméra
    // Multiplier le point par la matrice de rotation R
    // Ajouter le vecteur de translation T
    // Obtenir les coordonnées X_cam, Y_cam, Z_cam
// 4. Vérifier la validité du point
    // Tester si Z_cam > 0 (point devant la caméra)
    // Si Z_cam ≤ 0 : marquer le point comme invalide ou passer au suivant
// 5. Appliquer la projection perspective
    // Calculer x_écran = (fx × X_cam / Z_cam) + cx
    // Calculer y_écran = (fy × Y_cam / Z_cam) + cy
// 6. Stocker le résultat dans out[i]
    // Assigner x_écran à out[i].x
    // Assigner y_écran à out[i].y
    // Optionnel : stocker la profondeur Z_cam si nécessaire
// 7. Passer au point suivant (retour à l'étape 3)
    // Points d'attention
    // Ne jamais diviser par Z_cam si Z_cam ≤ 0
    // Vérifier l'ordre des opérations : rotation AVANT translation
    // S'assurer que les unités sont cohérentes (mètres, pixels, etc.)
    // Gérer les points hors champ de vision si demandé


//     Translation (position)
// 👉 “Où est la caméra ?” (tx, ty, tz)

// Rotation (orientation)
// 👉 “Dans quelle direction elle regarde ?” et “où sont ses axes X/Y/Z ?”