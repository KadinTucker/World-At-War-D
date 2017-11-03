import std.array;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import Display;

void main(){

    SDLResource.initialize();
    Display display = new Display(1200, 600);
    display.activeGui = getMainMenuGui(display);
    while(!display.quit){
        display.displayAll();
        display.handleEvents();
    }
    display.destroy();
    SDLResource.destroyAllResources();
}
