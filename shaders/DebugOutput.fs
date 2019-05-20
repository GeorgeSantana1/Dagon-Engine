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

const vec3 sunDirection = normalize(vec3(1.0, 1.0, 1.0));

// 0 - color
// 1 - normal
// 2 - position
// 3 - composite
uniform int outputMode;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

vec3 reconstructPosition(float depth)
{
    float x = texCoord.x * 2.0 - 1.0; 
    float y = texCoord.y * 2.0 - 1.0; 
    vec4 temp = invProjectionMatrix * vec4(x, y, depth, 1.0);
    return temp.xyz / temp.w;
}

void main()
{
    vec2 invResolution = 1.0 / resolution;

    vec4 col = texture(colorBuffer, texCoord);
    
    if (col.a < 1.0)
        discard;

    vec3 albedo = col.rgb;
    
    float depth = 2.0 * texture(depthBuffer, texCoord).x - 1.0;
    vec3 eyePos = reconstructPosition(depth);
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;
    
    vec3 N = normalize(texture(normalBuffer, texCoord).rgb);
    vec3 L = normalize((viewMatrix * vec4(sunDirection, 0.0)).xyz);
    
    float diffuse = max(0.0, dot(N, L));
    vec3 composite = albedo * diffuse;
    
    float colorWeight = float(outputMode == 0);
    float normalWeight = float(outputMode == 1);
    float posWeight = float(outputMode == 2);
    float compositeWeight = float(outputMode == 3);

    vec3 output = albedo * colorWeight + N * normalWeight + eyePos * posWeight + composite * compositeWeight;
    
    fragColor = vec4(output, 1.0);
}
