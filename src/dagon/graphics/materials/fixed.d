module dagon.graphics.materials.fixed;

import dlib.core.memory;
import dlib.math.vector;
import dlib.image.color;
import derelict.opengl.gl;
import derelict.opengl.glext;
import dagon.core.ownership;
import dagon.graphics.material;
import dagon.graphics.materials.generic;
import dagon.graphics.rc;

class FixedPipelineBackend: Owner, GenericMaterialBackend
{
    MaterialInput* idiffuse;
    MaterialInput* ispecular;
    MaterialInput* ishadeless;
    MaterialInput* iemit;
    MaterialInput* ialpha;
    MaterialInput* ibrightness;
    MaterialInput* iroughness;
    MaterialInput* ifogEnabled;

    this(Owner o)
    {
        super(o);
    }

    void bind(GenericMaterial mat, RenderingContext* rc)
    {
        idiffuse = "diffuse" in mat.inputs;
        ispecular = "specular" in mat.inputs;
        ishadeless = "shadeless" in mat.inputs;
        iemit = "emit" in mat.inputs;
        ialpha = "alpha" in mat.inputs;
        ibrightness = "brightness" in mat.inputs;
        iroughness = "roughness" in mat.inputs;
        ifogEnabled = "fogEnabled" in mat.inputs;
        
        Color4f one = Color4f(1, 1, 1, 1);
        glLightModelfv(GL_LIGHT_MODEL_AMBIENT, one.arrayof.ptr);

        glPushAttrib(GL_ENABLE_BIT);

        glEnable(GL_BLEND);
        glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

        float a = 1.0f;
        if (ialpha.type == MaterialInputType.Float)
            a = ialpha.asFloat;

        glEnable(GL_LIGHTING);
        if (ishadeless.type == MaterialInputType.Bool ||
            ishadeless.type == MaterialInputType.Integer)
        {
            if (ishadeless.asBool)
                glDisable(GL_LIGHTING);
        }

        if (idiffuse.texture)
        {
            glActiveTextureARB(GL_TEXTURE0_ARB);
            idiffuse.texture.bind();

            //Vector4f ambientColor = rc.environment.ambientConstant;
            //Vector4f diffuseColor = Vector4f(1.0f, 1.0f, 1.0f, a);
            //glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, ambientColor.arrayof.ptr);
            //glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseColor.arrayof.ptr);
            
            Vector4f diffuseColor = Vector4f(1.0f, 1.0f, 1.0f, a);
            glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseColor.arrayof.ptr);
        }
        else if (idiffuse.type == MaterialInputType.Vec4)
        {
            Vector4f ambientColor;
            if (rc.environment)
                ambientColor = idiffuse.asVector4f * rc.environment.ambientConstant;
            else
                ambientColor = Vector4f(0.0f, 0.0f, 0.0f, 1.0f);
            Vector4f diffuseColor = idiffuse.asVector4f;
            diffuseColor.a *= a;
            glMaterialfv(GL_FRONT_AND_BACK, GL_AMBIENT, ambientColor.arrayof.ptr);
            glMaterialfv(GL_FRONT_AND_BACK, GL_DIFFUSE, diffuseColor.arrayof.ptr);
            glColor4fv(diffuseColor.arrayof.ptr);
        }

        float gloss = 0.0f;
        if (iroughness.type == MaterialInputType.Float)
        {
            gloss = 1.0f - iroughness.asFloat;
            float shininess = gloss * 128.0f;
            glMaterialfv(GL_FRONT_AND_BACK, GL_SHININESS, &shininess);
        }

        if (ispecular.type == MaterialInputType.Vec4)
        {
            Vector4f specularColor = ispecular.asVector4f * gloss;
            glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, specularColor.arrayof.ptr);
        }

        if (iemit.type == MaterialInputType.Vec4)
        {
            float b = 0.0f;
            if (ibrightness.type == MaterialInputType.Float)
                b = ibrightness.asFloat;

            Vector4f emissionColor = iemit.asVector4f * b;
            glMaterialfv(GL_FRONT_AND_BACK, GL_EMISSION, emissionColor.arrayof.ptr);
        }

        glDisable(GL_FOG);
        if (ifogEnabled.type == MaterialInputType.Bool ||
            ifogEnabled.type == MaterialInputType.Integer)
        {
            if (ifogEnabled.asBool && rc.environment)
            {
                glEnable(GL_FOG);
                glFogfv(GL_FOG_COLOR, rc.environment.fogColor.arrayof.ptr);
                glFogi(GL_FOG_MODE, GL_LINEAR);
                glHint(GL_FOG_HINT, GL_DONT_CARE);
                glFogf(GL_FOG_START, rc.environment.fogStart);
                glFogf(GL_FOG_END, rc.environment.fogEnd);
            }
        }
    }

    void unbind(GenericMaterial mat)
    {
        idiffuse = "diffuse" in mat.inputs;
        ispecular = "specular" in mat.inputs;
        ishadeless = "shadeless" in mat.inputs;
        iemit = "emit" in mat.inputs;
        ialpha = "alpha" in mat.inputs;
        ibrightness = "brightness" in mat.inputs;
        iroughness = "roughness" in mat.inputs;
        ifogEnabled = "fogEnabled" in mat.inputs;

        if (idiffuse.texture)
        {
            glActiveTextureARB(GL_TEXTURE0_ARB);
            idiffuse.texture.unbind();
        }

        glPopAttrib();
    }
}
