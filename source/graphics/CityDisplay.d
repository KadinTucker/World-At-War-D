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
}

Texture generateCityTexture(City city, Renderer renderer) {
    Surface cityTexture = new Surface(50, 50, SDL_PIXELFORMAT_RGBA32);
    foreach(i; 0..city.level) {
        if(i % 3 == 0) {
            cityTexture.blit(skylines[(i * 17 + 29 * city.location.x + 31 * city.location.y) % skylines.length],
                    null, (i * 47 + city.location.x * 41 + city.location.y * 37) % 60 - 30, 0);
        }
        cityTexture.blit(skylines[(i * 7 + 11 * city.location.x + city.location.y * 23) % skylines.length],
                null, new iRectangle((i * 5 + city.location.x * 3 + city.location.y * 17) % 80 - 40, 30, 20, 20));
    }
    return new Texture(cityTexture, renderer);
}