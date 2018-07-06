module app;

import d2d;
import graphics;
import logic;

void main() {
    TileDisplay.loadSkylines();
    TileDisplay.loadFlags();
    Display display = new Display(1100, 600, SDL_WINDOW_SHOWN, 0, "World at War");
    display.activity = new MenuActivity(display);
    display.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
    display.run();
}