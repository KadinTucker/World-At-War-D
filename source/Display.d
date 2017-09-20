import derelict.sdl2.sdl;
import std.stdio;

import World;

class Display {

	SDL_Window* window;
	SDL_Surface* screenSurface;
	GUI gui;

	this(int width, int height){
		DerelictSDL2.load(SharedLibVersion(2, 0, 5));
		window = SDL_CreateWindow("World at War", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, width, height, SDL_WINDOW_SHOWN);
		screenSurface = SDL_GetWindowSurface(window);
		gui = new GUI();
	}

	void displayAll(){
		SDL_FillRect(screenSurface, null, SDL_MapRGB(screenSurface.format, 70, 70, 70));
		foreach(panel; gui.panels){
			writeln("panel display is run");
			panel.displayThis(this);
		}
		foreach(button; gui.buttons){
			if(button.isActive){
				button.displayThis(this);
			}
		}
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

class GUI {

	Button[] buttons;
	Panel[] panels;
	int displayWidth;
	int displayHeight;
	Display display;

	this(){
		initializeButtons();
		initializePanels();
	}

	void initializeButtons(){
		buttons ~= new Button(cast(char*)"settleButton.bmp", 350, displayHeight - 150, 100, 50);
	}

	void initializePanels(){
		panels ~= new Panel(cast(char*)"actionPanel.bmp", 0, displayHeight - 200);
	}

}

class Panel {

	SDL_Surface* image;
	int x;
	int y;

	this(char* image, int x, int y){
		this.image = SDL_LoadBMP(image);
		this.x = x;
		this.y = y;
	}

	void displayThis(Display display){
		SDL_Rect rect;
		rect.x = x;
		rect.y = y;
        SDL_BlitSurface(image, null, display.screenSurface, &rect);
	}

}

class Button {

	SDL_Surface* image;
	int x;
	int y;
	int width;
	int height;
	bool isActive = false;

	this(char* image, int x, int y, int width, int height){
		this.image = SDL_LoadBMP(image);
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	bool isPressed(int mousex, int mousey){
		return mousex > this.x && this.x - mousex < this.width && mousey > this.y && this.y - mousey < this.height;
	}

	void displayThis(Display display){
		SDL_Rect rect;
		rect.x = x;
		rect.y = y;
        SDL_BlitSurface(image, null, display.screenSurface, &rect);
	}

}
