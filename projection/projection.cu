#include<projection.h>

#include<cuda_runtime.h>

void cpu_project_points(const SystemConfig &systemConfig, const float3 *points_world, int num_points, ProjectedPoint *out)
{
//objectif = transformer les points worlds en point camera  avec P_cam = R × P_world + T
//
};

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