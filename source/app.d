import std.array;
import gfm.logger;
import gfm.sdl2;
import std.experimental.logger;
import Display;

//TODO: Add documentation to all files

void main(){
	Display display = new Display(1000, 800);
	while(!display.quit){
		display.handleEvents();
	}
	display.destroy();
}
