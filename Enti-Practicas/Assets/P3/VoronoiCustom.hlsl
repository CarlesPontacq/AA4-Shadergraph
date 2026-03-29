#ifndef VORONOI_CUSTOM_INCLUDED
#define VORONOI_CUSTOM_INCLUDED

void VoronoiCustom_float(float2 uv, float phase, out float distanceToEdge, out float2 nearestCellVector)
{
    float2 cellBase = floor(uv);
    float2 localUV = frac(uv);

    float2 nearestCellOffset;
    float2 nearestVector;
    float minDistance = 8.0;

    // Find nearest cell
    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            float2 neighborOffset = float2(x, y);

            float2x2 randomMatrix = float2x2(15.27, 47.63, 99.41, 89.98);
            float2 randomValues = frac(sin(mul(neighborOffset + cellBase, randomMatrix)) * 46839.32);

            float2 pointOffset = float2(
                sin(randomValues.y * phase) * 0.5 + 0.5,
                cos(randomValues.x * phase) * 0.5 + 0.5
            );

            float2 vectorToPoint = neighborOffset + pointOffset - localUV;
            float sqrDistance = dot(vectorToPoint, vectorToPoint);

            if (sqrDistance < minDistance)
            {
                minDistance = sqrDistance;
                nearestVector = vectorToPoint;
                nearestCellOffset = neighborOffset;
            }
        }
    }

    // Distance to borders
    minDistance = 8.0;

    for (int y = -2; y <= 2; y++)
    {
        for (int x = -2; x <= 2; x++)
        {
            float2 neighborOffset = nearestCellOffset + float2(x, y);

            float2x2 randomMatrix = float2x2(15.27, 47.63, 99.41, 89.98);
            float2 randomValues = frac(sin(mul(neighborOffset + cellBase, randomMatrix)) * 46839.32);

            float2 pointOffset = float2(
                sin(randomValues.y * phase) * 0.5 + 0.5,
                cos(randomValues.x * phase) * 0.5 + 0.5
            );

            float2 vectorToPoint = neighborOffset + pointOffset - localUV;

            // Avoid same point
            if (dot(nearestVector - vectorToPoint, nearestVector - vectorToPoint) > 0.0001)
            {
                float edgeDistance = dot(
                    0.5 * (nearestVector + vectorToPoint),
                    normalize(vectorToPoint - nearestVector)
                );

                minDistance = min(minDistance, edgeDistance);
            }
        }
    }

    distanceToEdge = minDistance;
    nearestCellVector = nearestVector;
}

#endif