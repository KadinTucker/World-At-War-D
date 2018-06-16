module graphics.CityDisplay;

import d2d;
import logic.player.City;

Surface[] skylines; //Every skyline building

/**
 * Places all skylines in the list
 * TODO: make json based
 */
void loadSkylines() {
    skylines ~= loadImage("res/City/joburg.png");
    skylines ~= loadImage("res/City/moscow.png");
    skylines ~= loadImage("res/City/nairobi.png");
    skylines ~= loadImage("res/City/shenyang.png");
    skylines ~= loadImage("res/City/ny.png");
}

/**
 * Generates a semi-random texture for a city
 * Creates mostly unique textures
 */
Texture generateCityTexture(City city, Renderer renderer) {
    Surface cityTexture = new Surface(50, 50, SDL_PIXELFORMAT_RGBA32);
    foreach(i; 0..city.level) {
        if((i + 1) % 3 == 0) {
            cityTexture.blit(skylines[(i * 171 + 329 * city.location.x + 329 * city.location.y) % skylines.length],
                    null, (i * 247 + city.location.x * 483 + city.location.y * 137) % 50 - 25, 0);
        }
        cityTexture.blit(skylines[(i * 737 + 329 * city.location.x + city.location.y * 239) % skylines.length],
                null, new iRectangle((i * 157 + city.location.x * 243 + city.location.y * 131) % 50 - 25, 30, 20, 20));
    }
    return new Texture(cityTexture, renderer);
}