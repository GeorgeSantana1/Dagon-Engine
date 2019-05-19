#version 400 core

uniform mat4 projectionMatrix;
uniform vec2 resolution;

layout (location = 0) in vec2 va_Vertex;
layout (location = 1) in vec2 va_Texcoord;

out vec2 texCoord;

void main()
{
    texCoord = va_Texcoord;
    gl_Position = projectionMatrix * vec4(va_Vertex * resolution, 0.0, 1.0);
}
