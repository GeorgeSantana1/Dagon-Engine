#version 400 core

layout (location = 0) in vec3 va_Vertex;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

void main()
{
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
}
