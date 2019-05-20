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

//layout(location = 1) out vec4 fragPBR;
//layout(location = 3) out vec4 fragVelocity;
//layout(location = 4) out vec4 fragEmission;

void main()
{
    vec3 N = normalize(normal);
    vec4 diff = diffuse(texCoord);
    
    // This is written to frag_color.w and frag_position.w
    // and determines that the fragment belongs to foreground object.
    // TODO: cutout alpha
    const float geometryMask = 1.0;
    
    fragColor = vec4(diff.rgb, geometryMask);
    fragNormal = vec4(N, 0.0);
}
