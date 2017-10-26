import gfm.logger;
import gfm.sdl2;
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

class Window{

    SDL2 sdl;
    SDL2Window window;
    SDL2Renderer renderer;
    bool continueRunning;

    this(int width, int height){
        this.sdl = new SDL2(null);
        this.window = new SDL2Window(this.sdl, SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN | SDL_WINDOW_INPUT_FOCUS | SDL_WINDOW_MOUSE_FOCUS);
        this.renderer = new SDL2Renderer(this.window, SDL_RENDERER_SOFTWARE);
        this.window.setTitle("World at War");
    }

    ~this(){
        this.sdl.destroy();
        this.window.destroy();
        this.renderer.destroy();
    }

}
