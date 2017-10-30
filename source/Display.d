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

    SDLTTF sdlttf;
    SDLFont font;
    SDL2Surface renderedText;
    SDL2Texture textTexture;

    this(int width, int height){
        this.logger = new ConsoleLogger();
        this.sdl = new SDL2(logger);
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN |  SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window);
        this.window.setTitle("World at War");
        this.sdlttf = new SDLTTF(this.sdl);
        this.font = new SDLFont(sdlttf, "Cantarell-Regular.ttf", 15);
        this.renderedText = this.font.renderTextBlended("Hello World", SDL_Color(0, 0, 0, 255));
        this.textTexture = new SDL2Texture(this.renderer, this.renderedText);
    }

    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
        this.font.destroy();
        this.sdlttf.destroy();
        this.renderedText.destroy();
        this.textTexture.destroy();
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
        this.renderer.setColor(50, 50, 50, 255);
        this.renderer.drawRect(295, 295, 165, 25);
        this.renderer.copy(textTexture, 300, 300);
        this.renderer.present();
    }

}

class GUI {



}

class Panel {

}

class Button : Panel {


}
