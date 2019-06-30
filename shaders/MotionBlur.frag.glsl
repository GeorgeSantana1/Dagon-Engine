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

const float currentFps = 60.0;
const float shutterFps = 24.0;
const int motionBlurSamples = 16;

float linearizeDepth(float d)
{
    float z_n = 2.0 * d - 1.0;
    return 2.0 * zNear * zFar / (zFar + zNear - z_n * (zFar - zNear));
}

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    vec3 velocity = texture(velocityBuffer, texCoord).rgb;
    
    if (enabled)
    {
        vec2 blurVec = velocity.xy;
        blurVec = blurVec * (currentFps / shutterFps);

        float speed = length(blurVec * viewSize);
        int nSamples = clamp(int(speed), 1, motionBlurSamples);

        float invSamplesMinusOne = 1.0 / float(nSamples - 1);
        float usedSamples = 1.0;

        for (int i = 1; i < nSamples; i++)
        {
            vec2 offset = blurVec * (float(i) * invSamplesMinusOne - 0.5);
            float mask = texture(velocityBuffer, texCoord + offset).z;
            res += texture(colorBuffer, texCoord + offset).rgb * mask;
            usedSamples += mask;
        }

        res = max(res, vec3(0.0));
        res = res / usedSamples;
    }

    fragColor = vec4(res, 1.0);
}
