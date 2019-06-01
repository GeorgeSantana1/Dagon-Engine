#version 400 core

uniform sampler2D colorBuffer;
uniform vec2 viewSize;

uniform float factor;

const int radius = 2;
const float exponent = 5.0f;

in vec2 texCoord;

out vec4 fragColor;

void main()
{
    float center = texture(colorBuffer, texCoord).r;
	float res = 0.0;
	float total = 0.0;
	for (int x = -radius; x <= radius; x += 1)
    {
		for (int y = -radius; y <= radius; y += 1)
        {
			float s = texture(colorBuffer, texCoord + vec2(float(x), float(y)) / viewSize).r;
			float weight = 1.0 - abs((s - center) * 0.25);
			weight = pow(weight, exponent);
			res += s * weight;
			total += weight;
		}
	}

    fragColor = vec4(vec3(mix(center, res / total, factor)), 1.0); 
}
