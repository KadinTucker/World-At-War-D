import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import std.stdio;
/*
int[2] windowSize = [1000, 800];

enum GuiSlotCoordinates {

    UPLEFT = [windowSize[0] / 27, windowSize[1] - windowSize[1] / 5],
    UPMID = [7 * windowSize[0] / 27, windowSize[1] - windowSize[1] / 5],
    UPRIGHT = [13 * windowSize[0] / 27, windowSize[1] - windowSize[1] / 5],
    DOWNLEFT = [windowSize[0] / 27, windowSize[1] - 3 * windowSize[1] / 5],
    DOWNMID = [7 * windowSize[0] / 27, windowSize[1] - 3 * windowSize[1] / 5],
    DOWNRIGHT = [13 * windowSize[0] / 27, windowSize[1] - 3 * windowSize[1] / 5],

}
*/

struct RGBColor {
    int r;
    int g;
    int b;
}

class SDLResource {

    static SDL2 sdl;
    static SDLTTF sdlttf;
    static SDLImage sdlimage;

    static void initialize(){
        sdl = new SDL2(null);
        sdlttf = new SDLTTF(sdl);
        sdlimage = new SDLImage(sdl);
    }

    static void destroyAllResources(){
        sdl.destroy();
        sdlttf.destroy();
        sdlimage.destroy();
    }

}

class Display {

    SDL2Window window;
    SDL2Renderer renderer;
    bool quit;
    GUI activeGui;

    this(int width, int height){
        this.window = new SDL2Window(SDLResource.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN |  SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window);
        this.window.setTitle("World at War");
    }

    ~this(){
        this.window.destroy();
        this.renderer.destroy();
        this.activeGui.destroy();
    }

    void clearDisplay(RGBColor bgColor){
        this.renderer.setViewportFull();
        this.renderer.setColor(bgColor.r, bgColor.b, bgColor.g, 255);
        this.renderer.clear();
    }

    void handleEvents(){
        SDL_Event event;
        while(SDLResource.sdl.pollEvent(&event)){
            if(event.type == SDL_QUIT){
                this.quit = true;
            }else if(event.type == SDL_MOUSEBUTTONDOWN){
                if(event.button.button == SDL_BUTTON_LEFT){
                    this.checkForAllButtons(event.button.x, event.button.y);
                }
            }
        }
    }

    void checkForAllButtons(int x, int y){
        handleAllButtons(this.activeGui.getPressedButtons(x, y), this);
    }

    void displayAll(){
        this.clearDisplay(RGBColor(100, 100, 100));
        foreach(panel; this.activeGui.panels){
            panel.render(this.renderer);
        }
        foreach(button; this.activeGui.buttons){
            button.render(this.renderer);
        }
        this.renderer.present();
    }

}

void handleAllButtons(string[] buttons, Display display){
    foreach(button; buttons){
        if(button == "Quit"){
            display.quit = true;
        }
    }
}

class GUI {

    Panel[] panels;
    Panel[] buttons;

    ~this(){
        foreach(panel; this.panels){
            panel.destroy();
        }
        foreach(button; this.buttons){
            button.destroy();
        }
    }

    string[] getPressedButtons(int x, int y){
        import std.stdio;
        string[] buttonsPressed;
        foreach(button; this.buttons){
            if(button.isPointIn(x, y)){
                buttonsPressed ~= button.name;
            }
        }
        return buttonsPressed;
    }

    void addPanel(Panel toAdd){
        this.panels ~= toAdd;
    }

    void addButton(Panel toAdd){
        this.buttons ~= toAdd;
    }

}

GUI getMainMenuGui(Display display){
    GUI gui = new GUI();
    gui.addPanel(new TextPanel(RGBColor(55, 60, 25), 350, 67, "WORLD AT WAR ", 50, display, "Title"));
    gui.addButton(new TextPanel(RGBColor(110, 125, 50), 450, 200, "New Game ", 37, display, "NewGame"));
    gui.addButton(new TextPanel(RGBColor(110, 125, 50), 450, 300, "Load Game", 37, display, "LoadGame"));
    gui.addButton(new TextPanel(RGBColor(110, 125, 50), 450, 400, "Quit     ", 37, display, "Quit"));
    return gui;
}

class Panel {

    RGBColor color;
    int x;
    int y;
    int width;
    int height;
    string name;

    this(RGBColor color, int x, int y, int width, int height, string name){
        this.color = color;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.name = name;
    }

    void render(SDL2Renderer renderer){
        renderer.setColor(this.color.r, this.color.g, this.color.b);
        renderer.fillRect(this.x, this.y, this.width, this.height);
        renderer.setColor(0, 0, 0);
        renderer.drawRect(this.x, this.y, this.width, this.height);
    }

    bool isPointIn(int x, int y){
        import std.stdio;
        return x - this.x >= 0 && x - this.x <= this.x + this.width && y - this.y >= 0 && y - this.y <= this.y + this.height;
    }

}

class TextPanel : Panel {

    string text;
    SDL2Texture textTexture;

    this(RGBColor color, int x, int y, string text, int fontsize, Display display, string name){
        SDLFont font = new SDLFont(SDLResource.sdlttf, "Cantarell-Regular.ttf", fontsize);
        SDL2Surface renderedText = font.renderTextBlended(text, SDL_Color(0, 0, 0, 255));
        this.textTexture = new SDL2Texture(display.renderer, renderedText);
        super(color, x, y, cast(int)(fontsize * 0.67 * text.length), fontsize + 10, name);
        font.destroy();
        renderedText.destroy();
    }

    ~this(){
        this.textTexture.destroy();
    }

    override void render(SDL2Renderer renderer){
        super.render(renderer);
        renderer.copy(textTexture, x + 5, y);
    }

}
