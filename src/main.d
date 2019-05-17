module main;

import std.stdio;

import dagon;

class SceneApplication: Application
{
    Scene scene;
    Cadencer cadencer;
    RenderPipeline pipeline;
    RenderStage stage3d;
    RenderStage stage2d;
    
    RenderView view3d;
    RenderView view2d;
    
    Camera camera;
    FreeviewComponent freeview;
    
    Entity box;   
    float angle = 0.0f;
    
    FreeTypeFont font;
    Entity text;
    TextLine infoText;
	
	NuklearGUI gui;

    this(string[] args)
    {
        super(1280, 720, false, "Dagon NG", args);
        
        scene = New!Scene(this);
        cadencer = New!Cadencer(&fixedUpdate, 60, this);
        pipeline = New!RenderPipeline(eventManager, this);
        stage3d = New!RenderStage(pipeline, scene.spatial);
        stage2d = New!RenderStage(pipeline, scene.hud);
        stage2d.clear = false;
        
        view3d = New!RenderView(300, 0, eventManager.windowWidth - 300, eventManager.windowHeight, this);
        stage3d.view = view3d;
        camera = New!Camera(scene.entityManager);
        freeview = New!FreeviewComponent(eventManager, camera);
        view3d.camera = camera;
        
        view2d = New!RenderView(0, 0, eventManager.windowWidth, eventManager.windowHeight, this);
        view2d.ortho = true;
        stage2d.view = view2d;
        
        box = New!Entity(scene.entityManager);
        box.position = Vector3f(0, 0, 0);
        box.drawable = New!ShapeBox(Vector3f(1, 1, 1), this);
		
		gui = New!NuklearGUI(eventManager, this);
        gui.addFont("data/font/DroidSans.ttf", 18, gui.localeGlyphRanges);
        auto eNuklear = New!Entity(scene.entityManager, -1);
		eNuklear.drawable = gui;
        
        font = New!FreeTypeFont(14, this);
        font.createFromFile("data/font/DroidSans.ttf");
        font.prepareVAO();
        text = New!Entity(scene.entityManager, -1);
        infoText = New!TextLine(font, "Hello, World!", this);
        text.drawable = infoText;
        text.position.x = 10;
        text.position.y = eventManager.windowHeight - 10;
        
        maximizeWindow();
    }
    
    char[100] textBuffer;
    
    void fixedUpdate(Time t)
    {
        //box.rotation = rotationQuaternion!float(Axis.y, degtorad(angle));
        //angle += 20.0f * t.delta;
        
        text.position.y = eventManager.windowHeight - 10;
        
        uint n = sprintf(textBuffer.ptr, "FPS: %u", eventManager.fps);
        string s = cast(string)textBuffer[0..n];
        infoText.setText(s);
		
		updateUserInterface(t);
    
        foreach(e; scene.entityManager.entities)
        {
            e.update(t);
        }
        
        pipeline.update(t);
    }
    
    override void onUpdate(Time t)
    {
        cadencer.update(t);
    }
    
    override void onRender()
    {
        pipeline.render();
    }
    
    override void onResize(int width, int height)
    {
        view3d.resize(width - 300, height);
        view2d.resize(width, height);
    }
    
    override void onKeyDown(int key)
    {
        if (key == KEY_ESCAPE)
            exit();
		else if (key == KEY_BACKSPACE)
			gui.inputKeyDown(NK_KEY_BACKSPACE);
        else if (key == KEY_C && eventManager.keyPressed[KEY_LCTRL])
            gui.inputKeyDown(NK_KEY_COPY);
        else if (key == KEY_V && eventManager.keyPressed[KEY_LCTRL])
            gui.inputKeyDown(NK_KEY_PASTE);
        else if (key == KEY_A && eventManager.keyPressed[KEY_LCTRL])
            gui.inputKeyDown(NK_KEY_TEXT_SELECT_ALL);
    }
	
	override void onKeyUp(int key)
    {
        if (key == KEY_BACKSPACE)
            gui.inputKeyUp(NK_KEY_BACKSPACE);
	}
	
	override void onMouseButtonDown(int button)
    {
        gui.inputButtonDown(button);
        freeview.active = !gui.itemIsAnyActive();
	}
	
	override void onMouseButtonUp(int button)
    {
        gui.inputButtonUp(button);
    }

    override void onTextInput(dchar unicode)
    {
        gui.inputUnicode(unicode);
    }

    override void onMouseWheel(int x, int y)
    {
        freeview.active = !gui.itemIsAnyActive();
        if (!freeview.active)
            gui.inputScroll(x, y);
	}
	
	Color4f lightColor = Color4f(1.0f, 1.0f, 1.0f, 1.0f);
	float sunPitch = 0.0f;
	float sunTurn = 0.0f;
    bool option;
    float value = 0.5f;
	
	void updateUserInterface(Time t)
    { 
		gui.update(t);
        
        if (gui.begin("Menu", NKRect(0, 0, eventManager.windowWidth, 40), 0))
        {
            gui.menubarBegin();
            {
                gui.layoutRowStatic(30, 40, 5);

                if (gui.menuBeginLabel("File", NK_TEXT_LEFT, NKVec2(200, 200)))
                {
                    gui.layoutRowDynamic(25, 1);
                    if (gui.menuItemLabel("New", NK_TEXT_LEFT)) { }
                    if (gui.menuItemLabel("Open", NK_TEXT_LEFT)) { }
                    if (gui.menuItemLabel("Save", NK_TEXT_LEFT)) { }
                    if (gui.menuItemLabel("Exit", NK_TEXT_LEFT)) { exit(); }
                    gui.menuEnd();
                }
                    
                if (gui.menuBeginLabel("Edit", NK_TEXT_LEFT, NKVec2(200, 200)))
                {
                    gui.layoutRowDynamic(25, 1);
                    if (gui.menuItemLabel("Copy", NK_TEXT_LEFT)) { }
                    if (gui.menuItemLabel("Paste", NK_TEXT_LEFT)) { }
                    gui.menuEnd();
                }
                
                if (gui.menuBeginLabel("Help", NK_TEXT_LEFT, NKVec2(200, 200)))
                {
                    gui.layoutRowDynamic(25, 1);
                    if (gui.menuItemLabel("About...", NK_TEXT_LEFT)) { }
                    gui.menuEnd();
                }
            }
            gui.menubarEnd();
        }
        gui.end();
		
        if (gui.begin("Properties", NKRect(0, 40, 300, eventManager.windowHeight - 40), NK_WINDOW_TITLE))
        {
            if (gui.treePush(NK_TREE_NODE, "Sun", NK_MINIMIZED))
            {
                gui.layoutRowDynamic(30, 1);    
                sunPitch = gui.property("Pitch:", -180f, sunPitch, 0f, 1f, 0.5f);
                sunTurn = gui.property("Turn:", -180f, sunTurn, 180f, 1f, 0.5f);
                gui.treePop();
            }
                
            if (gui.treePush(NK_TREE_NODE, "Option", NK_MINIMIZED))
            {
                gui.layoutRowDynamic(30, 2);
                if (gui.optionLabel("on", option == true)) option = true;
                if (gui.optionLabel("off", option == false)) option = false;
                gui.slider(0.0f, &value, 1.0f, -0.01f);
                gui.treePop();
            }
                
            if (gui.treePush(NK_TREE_NODE, "Create Light", NK_MINIMIZED))
            {
                gui.layoutRowDynamic(150, 1);
                lightColor = gui.colorPicker(lightColor, NK_RGB);
                gui.layoutRowDynamic(25, 1);
                lightColor.r = gui.property("#R:", 0f, lightColor.r, 1.0f, 0.01f, 0.005f);
                lightColor.g = gui.property("#G:", 0f, lightColor.g, 1.0f, 0.01f, 0.005f);
                lightColor.b = gui.property("#B:", 0f, lightColor.b, 1.0f, 0.01f, 0.005f);
                gui.layoutRowDynamic(25, 1);
                if (gui.buttonLabel("Create"))
                {
                    writeln("clicked");
                }
                gui.treePop();
            }
                
            if (gui.treePush(NK_TREE_NODE, "Input", NK_MINIMIZED))
            {
                static int len = 4;
                static char[256] buffer = "test";
                gui.layoutRowDynamic(35, 1);
                gui.editString(NK_EDIT_FIELD, buffer.ptr, &len, 255, null);
                //gui.layoutRowStatic(150, 150, 1);
                //gui.image(aTexCrateDiffuse.texture.toNKImage);
                //gui.layoutRowDynamic(35, 1);
                gui.treePop();
            }
        }
        gui.end();

        /*
        if (gui.begin("Input and Texture", NKRect(1000, 100, 230, 200), NK_WINDOW_BORDER | NK_WINDOW_MOVABLE | NK_WINDOW_TITLE | NK_WINDOW_SCALABLE))
        {
            static int len = 4;
            static char[256] buffer = "test";
            gui.layoutRowDynamic(35, 1);
            gui.editString(NK_EDIT_SIMPLE, buffer.ptr, &len, 255, null);
            gui.layoutRowStatic(150, 150, 1);
            //gui.image(aTexCrateDiffuse.texture.toNKImage);
            gui.layoutRowDynamic(35, 1);
        }
        gui.end();
        */
	}
}

void main(string[] args)
{
    SceneApplication app = New!SceneApplication(args);
    app.run();
    Delete(app);
    
    writeln(allocatedMemory);
}
