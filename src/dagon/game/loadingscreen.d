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

module dagon.game.loadingscreen;

import dlib.core.memory;
import dlib.core.ownership;
import dlib.math.vector;
import dlib.math.matrix;
import dlib.math.transformation;
import dlib.math.interpolation;
import dlib.image.color;

import dagon.core.bindings;
import dagon.core.event;
import dagon.core.time;
import dagon.graphics.state;
import dagon.graphics.entity;
import dagon.graphics.shapes;
import dagon.graphics.material;
import dagon.render.shaders.hud;
import dagon.game.game;

class LoadingScreen: EventListener
{
    Game game;
    ShapeQuad loadingProgressBar;
    Entity eLoadingProgressBar;
    HUDShader hudShader;
    
    this(Game game, Owner owner)
    {
        super(game.eventManager, owner);
        this.game = game;
        loadingProgressBar = New!ShapeQuad(this);
        eLoadingProgressBar = New!Entity(this);
        eLoadingProgressBar.drawable = loadingProgressBar;
        hudShader = New!HUDShader(this);
        eLoadingProgressBar.material = New!Material(hudShader, this);
        eLoadingProgressBar.material.diffuse = Color4f(1.0f, 1.0f, 1.0f, 1.0f);
        eLoadingProgressBar.material.culling = false;
    }
    
    void update(Time t, float progress)
    {
        float maxWidth = eventManager.windowWidth * 0.33f;
        float x = (eventManager.windowWidth - maxWidth) * 0.5f;
        float y = eventManager.windowHeight * 0.5f - 10;
        float w = progress * maxWidth;
        eLoadingProgressBar.position = Vector3f(x, y, 0);
        eLoadingProgressBar.scaling = Vector3f(w, 10, 1);
        eLoadingProgressBar.update(t);
    }
    
    void render()
    {
        GraphicsState state;
        state.reset();
        state.modelViewMatrix = eLoadingProgressBar.absoluteTransformation;
        state.projectionMatrix = orthoMatrix(0.0f, eventManager.windowWidth, eventManager.windowHeight, 0.0f, 0.0f, 1000.0f);
        state.invProjectionMatrix = state.projectionMatrix.inverse;
        state.resolution = Vector2f(eventManager.windowWidth, eventManager.windowHeight);
        state.zNear = 0.0f;
        state.zFar = 1000.0f;
        game.renderEntity(eLoadingProgressBar, &state);
    }
}
