#version 400 core

uniform float opacity;

out vec4 fragColor;

void main()
{
    const float bayer[16] = float[16](
        1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0,
        13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0,
        4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0,
        16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0
    );
    
    //float alpha = fragDiffuse.a * opacity;
    float alpha = opacity;
    if (alpha < bayer[int(mod(gl_FragCoord.y, 4.0)) * 4 + int(mod(gl_FragCoord.x, 4.0))])
        discard;
    
    fragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
