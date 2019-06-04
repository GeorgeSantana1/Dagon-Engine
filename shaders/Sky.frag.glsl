#version 400 core

#define PI 3.14159265359
const float PI2 = PI * 2.0;

uniform mat4 invViewMatrix;

in vec3 eyePosition;
in vec3 worldNormal;

vec2 envMapEquirect(in vec3 dir)
{
    float phi = acos(dir.y);
    float theta = atan(dir.x, dir.z) + PI;
    return vec2(theta / PI2, phi / PI);
}

/*
 * Diffuse color
 */
subroutine vec3 srtEnv(in vec3 dir);

uniform vec4 envColor;
subroutine(srtEnv) vec3 environmentColor(in vec3 dir)
{
    return envColor.rgb;
}

uniform sampler2D envTexture;
subroutine(srtEnv) vec3 environmentTexture(in vec3 dir)
{
    return texture(envTexture, envMapEquirect(dir)).rgb;
}

uniform samplerCube envTextureCube;
subroutine(srtEnv) vec3 environmentCubemap(in vec3 dir)
{
    return texture(envTextureCube, dir).rgb;
}

subroutine uniform srtEnv environment;


layout(location = 0) out vec4 fragColor;

void main()
{
    vec3 fragDiffuse = environment(normalize(worldNormal));    
    fragColor = vec4(fragDiffuse, 0.0);
}
