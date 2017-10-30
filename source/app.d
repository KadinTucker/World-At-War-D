import std.array;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import Display;

void main(){
    Display display = new Display(1200, 600);
    while(!display.quit){
        display.displayAll();
        display.handleEvents();
    }
    import std.stdio;
    writeln("finised loop");
    display.sdl.destroy();
    display.window.destroy();
    display.renderer.destroy();
    display.destroy();
}
