#version 400 core

in vec3 normal;
in vec2 texCoord;

/*
 * Diffuse color subroutines.
 * Used to switch color/texture.
 */
subroutine vec4 srtColor(in vec2 uv);

uniform vec4 diffuseVector;
subroutine(srtColor) vec4 diffuseColorValue(in vec2 uv)
{
    return diffuseVector;
}

uniform sampler2D diffuseTexture;
subroutine(srtColor) vec4 diffuseColorTexture(in vec2 uv)
{
    return texture(diffuseTexture, uv);
}

subroutine uniform srtColor diffuse;

layout(location = 0) out vec4 fragColor;
layout(location = 1) out vec4 fragNormal;

void main()
{
    vec3 N = normalize(normal);
    vec4 diff = diffuse(texCoord);
    
    if (diff.a < 1.0)
        discard;
    
    fragColor = vec4(diff.rgb, 1.0);
    fragNormal = vec4(N, 0.0);
}
