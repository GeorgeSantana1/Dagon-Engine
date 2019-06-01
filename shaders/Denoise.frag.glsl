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
    vec3 center = texture(colorBuffer, texCoord).rgb;

	vec3 res = vec3(0.0);
	float total = 0.0;
	for (int x = -radius; x <= radius; x += 1)
    {
		for (int y = -radius; y <= radius; y += 1)
        {
			vec3 s = texture(colorBuffer, texCoord + vec2(float(x), float(y)) / viewSize).rgb;
			float weight = 1.0 - abs(dot(s - center, vec3(0.25)));
			weight = pow(weight, exponent);
			res += s * weight;
			total += weight;
		}
	}

    fragColor = vec4(mix(center, res / total, factor), 1.0); 
}
