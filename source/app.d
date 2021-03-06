module app;

import d2d;
import graphics;
import logic;

void main() {
    // World world = new World("sample-scenario.json");
    TileDisplay.loadSkylines();
    TileDisplay.loadFlags();
    Display display = new Display(1100, 690, SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE, 0, "World at War");
    display.activity = new MenuActivity(display);
    display.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
    display.run();
}