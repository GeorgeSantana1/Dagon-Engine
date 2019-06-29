#version 400 core

uniform bool enabled;

uniform sampler2D colorBuffer;
uniform sampler2D velocityBuffer;

uniform vec2 viewSize;

in vec2 texCoord;
out vec4 fragColor;

const float timeStep = 1.0 / 60.0;
const float shutterFps = 30;
const int motionBlurSamples = 10;

void main()
{
    vec3 res = texture(colorBuffer, texCoord).rgb;
    vec3 velocity = texture(velocityBuffer, texCoord).rgb;
    
    if (enabled)
    {
        vec2 blurVec = velocity.xy;
        //float depthRef = texture(fbPosition, texCoord).z;
        blurVec = blurVec / (timeStep * shutterFps);

        float speed = length(blurVec * viewSize);
        speed = (speed < 20.0)? 1.0 : speed;
        int nSamples = clamp(int(speed), 1, motionBlurSamples);

        float invSamplesMinusOne = 1.0 / float(nSamples - 1);
        float usedSamples = 1.0;
        const float depthThreshold = 1.0;

        for (int i = 1; i < nSamples; i++)
        {
            vec2 offset = blurVec * (float(i) * invSamplesMinusOne - 0.5);
            float mask = texture(velocityBuffer, texCoord + offset).z;
            //float depth = texture(fbPosition, texCoord + offset).z;
            //float depthWeight = 1.0 - clamp(abs(depth - depthRef), 0.0, depthThreshold) / depthThreshold;
            float depthWeight = 1.0; 
            res += texture(colorBuffer, texCoord + offset).rgb * mask * depthWeight;
            usedSamples += mask * depthWeight;
        }

        res = max(res, vec3(0.0));
        res = res / usedSamples;
    }

    fragColor = vec4(res, 1.0);
}
