#version 400 core

layout (location = 0) in vec3 va_Vertex;
layout (location = 1) in vec3 va_Normal;
layout (location = 2) in vec2 va_Texcoord;

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

uniform vec2 textureScale;

out vec3 normal;
out vec2 texCoord;

void main()
{
    gl_Position = projectionMatrix * modelViewMatrix * vec4(va_Vertex, 1.0);
    normal = (normalMatrix * vec4(va_Normal, 0.0)).xyz;
    texCoord = va_Texcoord * textureScale;
}
