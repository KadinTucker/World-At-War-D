import derelict.sdl2.sdl;

class Display {

	SDL_Window* window;
	SDL_Surface* screenSurface;

	this(int width, int height){
		DerelictSDL2.load(SharedLibVersion(2, 0, 5));
		window = SDL_CreateWindow("World at War", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN);
		screenSurface = SDL_GetWindowSurface(window);
	}

	void displayAll(){
		SDL_FillRect(screenSurface, null, SDL_MapRGB(screenSurface.format, 100, 100, 100));
		SDL_UpdateWindowSurface(window);
	}

	SDL_Event[] getEvents(){
		SDL_Event event;
		SDL_Event[] events;
		while (SDL_PollEvent(&event) != 0){
			events ~= event;
		}
		return events;
	}

}

class Button {

	SDL_Surface* image;
	int x;
	int y;
	int width;
	int height;

	this(SDL_Surface image, int x, int y, int width, int height){
		this.image = image;
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	bool isPressed(int mousex, int mousey){
		return mousex > this.x && this.x - mousex < this.width && mousey > this.y && this.y - mousey < this.height;
	}

}
