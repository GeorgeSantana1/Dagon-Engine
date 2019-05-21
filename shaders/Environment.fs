#version 400 core

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D normalBuffer;

uniform vec2 resolution;
uniform mat4 viewMatrix;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

uniform vec4 ambientColor;
uniform vec4 fogColor;
uniform float fogStart;
uniform float fogEnd;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

// Converts normalized device coordinates to eye space position
vec3 unproject(vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjectionMatrix * clipPos;
    return res.xyz / res.w;
}

vec3 toLinear(vec3 v)
{
    return pow(v, vec3(2.2));
}

vec3 toGamma(vec3 v)
{
    return pow(v, vec3(1.0 / 2.2));
}

vec3 fresnelRoughness(float cosTheta, vec3 f0, float roughness)
{
    return f0 + (max(vec3(1.0 - roughness), f0) - f0) * pow(1.0 - cosTheta, 5.0);
}

void main()
{
    vec2 invResolution = 1.0 / resolution;

    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;

    vec3 albedo = toLinear(col.rgb);
    
    float depth = texture(depthBuffer, texCoord).x;
    vec3 eyePos = unproject(vec3(texCoord, depth));
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 E = normalize(-eyePos);
    vec3 R = reflect(E, N);
    
    // TODO: read from buffer
    float roughness = 0.5;
    float metallic = 0.0;
    float occlusion = 1.0;
    vec3 f0 = mix(vec3(0.04), albedo, metallic);

    vec3 radiance = vec3(0.0, 0.0, 0.0);

    // Ambient light
    {
        vec3 ambientDiffuse = toLinear(ambientColor.rgb);
        vec3 ambientSpecular = toLinear(ambientColor.rgb);
        vec3 F = fresnelRoughness(max(dot(N, E), 0.0), f0, roughness);
        vec3 kS = F;
        vec3 kD = 1.0 - kS;
        kD *= 1.0 - metallic;
        radiance += (kD * ambientDiffuse * albedo * occlusion + F * ambientSpecular);
    }
    
    // Fog
    float linearDepth = abs(eyePos.z);
    float fogFactor = clamp((fogEnd - linearDepth) / (fogEnd - fogStart), 0.0, 1.0);
    radiance = mix(toLinear(fogColor.rgb), radiance, fogFactor);
    
    fragColor = vec4(toGamma(radiance), 1.0);
}
