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

class Display {

    Logger logger;
    SDL2 sdl;
    SDL2Window window;
    SDL2Renderer renderer;
    bool quit;
    GUI activeGui;

    this(int width, int height){
        this.logger = new ConsoleLogger();
        this.sdl = new SDL2(logger);
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN |  SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window);
        this.window.setTitle("World at War");
    }

    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

    void clearDisplay(RGBColor bgColor){
        this.renderer.setViewportFull();
        this.renderer.setColor(bgColor.r, bgColor.b, bgColor.g, 255);
        this.renderer.clear();
    }

    void handleEvents(){
        SDL_Event event;
        while(this.sdl.pollEvent(&event)){
            if(event.type == SDL_QUIT){
                this.quit = true;
            }
        }
    }

    void displayAll(){
        this.clearDisplay(RGBColor(100, 100, 100));
        foreach(panel; this.activeGui.panels){
            panel.render(this.renderer);
        }
        this.renderer.present();
    }

}

class GUI {

    Panel[] panels;
    Panel[] buttons;

    void addPanel(Panel toAdd){
        this.panels ~= toAdd;
    }

    void addButton(Panel toAdd){
        this.buttons ~= toAdd;
    }

}

GUI getMainMenuGui(Display display){
    GUI gui = new GUI();
    gui.addPanel(new TextPanel(RGBColor(55, 60, 25), 350, 67, "WORLD AT WAR ", 50, display));
    gui.addPanel(new TextPanel(RGBColor(110, 125, 50), 450, 200, "New Game ", 37, display));
    gui.addPanel(new TextPanel(RGBColor(110, 125, 50), 450, 300, "Load Game", 37, display));
    gui.addPanel(new TextPanel(RGBColor(110, 125, 50), 450, 400, "Quit     ", 37, display));
    return gui;
}

class Panel {

    RGBColor color;
    int x;
    int y;
    int width;
    int height;

    this(RGBColor color, int x, int y, int width, int height){
        this.color = color;
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }

    void render(SDL2Renderer renderer){
        renderer.setColor(this.color.r, this.color.g, this.color.b);
        renderer.fillRect(this.x, this.y, this.width, this.height);
        renderer.setColor(0, 0, 0);
        renderer.drawRect(this.x, this.y, this.width, this.height);
    }

}

class TextPanel : Panel {

    string text;
    SDL2Texture textTexture;

    this(RGBColor color, int x, int y, string text, int fontsize, Display display){
        SDLTTF sdlttf = new SDLTTF(display.sdl);
        SDLFont font = new SDLFont(sdlttf, "Cantarell-Regular.ttf", fontsize);
        SDL2Surface renderedText = font.renderTextBlended(text, SDL_Color(0, 0, 0, 255));
        this.textTexture = new SDL2Texture(display.renderer, renderedText);
        super(color, x, y, cast(int)(fontsize * 0.67 * text.length), fontsize + 10);
        //sdlttf.destroy();
        font.destroy();
        renderedText.destroy();
    }

    override void render(SDL2Renderer renderer){
        super.render(renderer);
        renderer.copy(textTexture, x + 5, y);
    }

}
