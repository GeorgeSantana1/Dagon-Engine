#version 400 core

in vec3 normal;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragPBR;
layout(location = 2) out vec4 fragNormal;
layout(location = 3) out vec4 fragVelocity;
layout(location = 4) out vec4 fragEmission;

void main()
{
    vec3 N = normalize(normal);
    vec3 color = vec3(1.0);
    fragColor = vec4(color, 1.0);
    fragPBR = vec4(0.0, 0.0, 0.0, 0.0);
    fragNormal = vec4(N, 0.0);
    fragVelocity = vec4(0.0, 0.0, 0.0, 0.0);
    fragEmission = vec4(0.0, 0.0, 0.0, 0.0);
}
