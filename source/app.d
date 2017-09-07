import std.array;
import derelict.sdl2.sdl;
import Display;

//TODO: Add documentation to all files

void main(){
	Display display = new Display(700, 500);
	bool quit = false;
	SDL_Event[] events;

	while(!quit){
		display.displayAll();
		events = display.getEvents();
		foreach(event; events){
			if (event.type == SDL_QUIT)
				quit = true;
		}
		events = [];
	}
}
