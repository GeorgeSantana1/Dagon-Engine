/*
Copyright (c) 2019 Timur Gafarov

Boost Software License - Version 1.0 - August 17th, 2003
Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
*/

module dagon.render.view;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.utils;
import dlib.image.color;

import dagon.core.bindings;
import dagon.graphics.camera;

import dagon.render.pipeline;

class RenderView: Owner
{    
    Camera camera;
    uint x;
    uint y;
    uint width;
    uint height;
    float aspectRatio;
    bool ortho = false;
    Color4f backgroundColor;
    RenderPipeline pipeline;
    
    this(uint x, uint y, uint width, uint height, Owner owner)
    {
        super(owner);
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        aspectRatio = cast(float)width / cast(float)height;
        backgroundColor = Color4f(0.5f, 0.5f, 0.5f, 1.0f);
    }
    
    ~this()
    {
    }
    
    Matrix4x4f viewMatrix()
    {
        if (camera)
            return camera.viewMatrix();
        else
            return Matrix4x4f.identity;
    }
    
    Matrix4x4f invViewMatrix()
    {
        if (camera)
            return camera.invViewMatrix();
        else
            return Matrix4x4f.identity;
    }
    
    Matrix4x4f projectionMatrix()
    {
        float fov = 60.0f;
        float zNear = 0.01f;
        float zFar = 1000.0f;
        if (camera)
        {
            fov = camera.fov;
            zNear = camera.zNear;
            zFar = camera.zFar;
        }
        if (ortho)
            return orthoMatrix(0.0f, width, height, 0.0f, 0.0f, zFar);
        else
            return perspectiveMatrix(fov, aspectRatio, zNear, zFar);
    }
    
    float zNear()
    {
        if (camera)
            return camera.zNear;
        else
            return 0.01f;
    }
    
    float zFar()
    {
        if (camera)
            return camera.zFar;
        else
            return 1000.0f;
    }
    
    Vector3f cameraPosition()
    {
        if (camera)
            return camera.positionAbsolute;
        else
            return Vector3f(0.0f, 0.0f, 0.0f);
    }
    
    void resize(uint width, uint height)
    {
        this.width = width;
        this.height = height;
        aspectRatio = cast(float)width / cast(float)height;
    }

    // TODO: pixel to ray
    // TODO: point to pixel
    // TODO: pixel visible
    // TODO: extract frustum
}
