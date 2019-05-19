#version 400 core

in vec3 normal;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec3 N = normalize(normal);
    vec3 color = vec3(1.0);
    fragColor = vec4(color, 1.0);
}
