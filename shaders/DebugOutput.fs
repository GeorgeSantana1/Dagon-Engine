#version 400 core

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform vec2 resolution;
uniform mat4 invViewMatrix;
uniform mat4 invProjectionMatrix;
uniform float zNear;
uniform float zFar;

in vec2 texCoord;

layout(location = 0) out vec4 fragColor;

float linearizeDepth(float z)
{
    float z_n = 2.0 * z - 1.0;
    return 2.0 * zNear * zFar / (zFar + zNear - z_n * (zFar - zNear));
}

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
    float depth = 2.0 * texture(depthBuffer, texCoord).x - 1.0;
    vec3 eyePos = reconstructPosition(depth);
    vec3 worldPos = (invViewMatrix * vec4(eyePos, 1.0)).xyz;

    //vec3 albedo = toLinear(col.rgb);
    
    float colorWeight = float(texCoord.x < 0.5);
    float posWeight = float(texCoord.x >= 0.5);
    
    float total = floor(worldPos.x) + floor(worldPos.z);
    float isOdd = float(mod(total, 2.0) > 0.0);
    vec3 checker = vec3(1.0) * isOdd;

    vec3 frag = checker * colorWeight + worldPos * posWeight;
    
    fragColor = vec4(frag, 1.0);
}
