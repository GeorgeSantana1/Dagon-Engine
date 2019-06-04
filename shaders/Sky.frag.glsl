#version 400 core

in vec3 eyeNormal;
in vec3 eyePosition;

vec2 envMapEquirect(in vec3 dir)
{
    float phi = acos(dir.y);
    float theta = atan(dir.x, dir.z) + PI;
    return vec2(theta / PI2, phi / PI);
}

/*
 * Diffuse color
 */
subroutine vec4 srtColor(in vec3 dir);

uniform vec4 diffuseVector;
subroutine(srtColor) vec4 diffuseColor(in vec3 dir)
{
    return diffuseVector;
}

uniform samplerCube diffuseTextureCube;
subroutine(srtColor) vec4 diffuseTextureCubemap(in vec3 dir)
{
    // TODO: toLinear?
    return texture(diffuseTextureCube, dir).rgb;
}

uniform sampler2D diffuseTexture;
subroutine(srtColor) vec4 diffuseTextureEquirectangularMap(in vec3 dir)
{
    // TODO: toLinear?
    return texture(diffuseTexture, envMapEquirect(dir)).rgb;
}

subroutine uniform srtColor diffuse;

layout(location = 0) out vec4 fragColor;

void main()
{
    vec3 N = normalize(eyeNormal);
    
    vec4 fragDiffuse = diffuse(N);
    if (fragDiffuse.a < 1.0)
        discard;
    
    fragColor = vec4(fragDiffuse.rgb, 0.0);
}
