module app;

import d2d;
import graphics.activity.GameActivity;
import graphics.CityDisplay;

void main() {
    loadSkylines();
    Display display = new Display(1100, 600, SDL_WINDOW_SHOWN, 0, "World at War");
    display.activity = new GameActivity(display);
    display.renderer.drawBlendMode = SDL_BLENDMODE_BLEND;
    display.run();
}