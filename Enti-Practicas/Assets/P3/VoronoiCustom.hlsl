#ifndef VORONOI_CUSTOM_INCLUDED
#define VORONOI_CUSTOM_INCLUDED

void VoronoiCustom_float(float2 UV, float Phase, out float Distance, out float2 CellVector)
{
    float2 n = floor(UV);
    float2 f = frac(UV);

    float2 mg, mr;
    float md = 8.0;

    // -------- PRIMERA PASADA --------
    for (int j = -1; j <= 1; j++)
    {
        for (int i = -1; i <= 1; i++)
        {
            float2 g = float2(i, j);

            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            float2 uvr = frac(sin(mul(g + n, m)) * 46839.32);

            float2 o = float2(
                sin(uvr.y * Phase) * 0.5 + 0.5,
                cos(uvr.x * Phase) * 0.5 + 0.5
            );

            float2 r = g + o - f;
            float d = dot(r, r);

            if (d < md)
            {
                md = d;
                mr = r;
                mg = g;
            }
        }
    }

    // -------- SEGUNDA PASADA --------
    md = 8.0;

    for (int j = -2; j <= 2; j++)
    {
        for (int i = -2; i <= 2; i++)
        {
            float2 g = mg + float2(i, j);

            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            float2 uvr = frac(sin(mul(g + n, m)) * 46839.32);

            float2 o = float2(
                sin(uvr.y * Phase) * 0.5 + 0.5,
                cos(uvr.x * Phase) * 0.5 + 0.5
            );

            float2 r = g + o - f;

            if (dot(mr - r, mr - r) > 0.0001)
            {
                md = min(md, dot(0.5 * (mr + r), normalize(r - mr)));
            }
        }
    }

    Distance = md;
    CellVector = mr;
}

#endif