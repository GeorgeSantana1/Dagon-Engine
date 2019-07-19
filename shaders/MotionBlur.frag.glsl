#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D depthBuffer;
uniform sampler2D velocityBuffer;

uniform vec2 viewSize;

uniform float zNear;
uniform float zFar;

in vec2 texCoord;
out vec4 fragColor;

uniform float blurScale;
uniform int samples;

uniform mat4 invProjectionMatrix;

// Converts normalized device coordinates to eye space position
vec3 unproject(vec3 ndc)
{
    vec4 clipPos = vec4(ndc * 2.0 - 1.0, 1.0);
    vec4 res = invProjectionMatrix * clipPos;
    return res.xyz / res.w;
}

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    vec3 velocity = texture(velocityBuffer, texCoord).rgb;
    
    if (enabled)
    {
        vec2 blurVec = velocity.xy;
        blurVec = blurVec * blurScale;

        float speed = length(blurVec * viewSize);
        int nSamples = clamp(int(speed), 1, samples);

        float invSamplesMinusOne = 1.0 / float(nSamples - 1);
        float usedSamples = 1.0;
        
        float zCenter = unproject(vec3(texCoord, texture(depthBuffer, texCoord).x)).z;

        for (int i = 1; i < nSamples; i++)
        {
            vec2 offset = blurVec * (float(i) * invSamplesMinusOne - 0.5);
            float mask = texture(velocityBuffer, texCoord + offset).z;
            float z = unproject(vec3(texCoord, texture(depthBuffer, texCoord + offset).x)).z; 
            mask *= 1.0 - clamp(abs(zCenter - z), 0.0, 100.0) / 100.0;
            res += texture(colorBuffer, texCoord + offset).rgb * mask;
            usedSamples += mask;
        }

        res = max(res, vec3(0.0));
        res = res / usedSamples;
    }

    fragColor = vec4(res, 1.0);
}
