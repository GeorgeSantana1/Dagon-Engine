#version 400 core

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D normalBuffer;
uniform sampler2D pbrBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

// 0 - radiance
// 1 - color
// 2 - normal
// 3 - position
// 4 - roughness
// 5 - metallic
uniform int outputMode;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

// Converts normalized device coordinates to eye space position
vec3 unproject(vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjectionMatrix * clipPos;
    return res.xyz / res.w;
}

void main()
{
    vec2 invResolution = 1.0 / resolution;

    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;

    vec3 albedo = col.rgb;
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    
    float roughness = texture(pbrBuffer, texCoord).r;
    float metallic = texture(pbrBuffer, texCoord).g;
    
    float colorWeight = float(outputMode == 1);
    float normalWeight = float(outputMode == 2);
    float posWeight = float(outputMode == 3);
    float roughWeight = float(outputMode == 4);
    float metWeight = float(outputMode == 5);

    vec3 output = 
        albedo * colorWeight + 
        N * normalWeight + 
        eyePos * posWeight +
        vec3(roughness) * roughWeight +
        vec3(metallic) * metWeight;
    
    fragColor = vec4(output, 1.0);
}
