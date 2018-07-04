module graphics.TileDisplay;

import d2d;
import logic;
import graphics;

Surface[] skylines; //Every skyline building for city display
Surface[] flags; //Every flag for unit displays

/**
 * Places all skylines in the list of skylines for city display
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
 * Puts all flag images in the list of flags for indicating player
 * TODO: make json based; make flag colors based on player color
 */
void loadFlags() {
    flags ~= loadImage("res/Flag/blue.png");
    flags ~= loadImage("res/Flag/red.png");
    flags ~= loadImage("res/Flag/green.png");
}

/**
 * Generates a semi-random image for a city
 * Creates mostly unique textures
 */
Surface generateCityTexture(City city) {
    Surface cityTexture = new Surface(50, 50, SDL_PIXELFORMAT_RGBA32);
    foreach(i; 0..city.level) {
        if((i + 1) % 3 == 0) {
            cityTexture.blit(skylines[(i * 171 + 329 * city.location.x + 329 * city.location.y) % skylines.length],
                    null, (i * 247 + city.location.x * 483 + city.location.y * 137) % 50 - 25, 0);
        }
        cityTexture.blit(skylines[(i * 737 + 329 * city.location.x + city.location.y * 239) % skylines.length],
                null, new iRectangle((i * 157 + city.location.x * 243 + city.location.y * 131) % 50 - 25, 30, 20, 20));
    }
    cityTexture.blit(flags[city.owner.number], null, 0, 0);
    return cityTexture;
}

/**
 * Generates the surface for an army based on its owner
 * and number of units
 */
Surface generateArmyTexture(Army army) {
    Surface armyTexture;
    int armyValue = army.troops[0] + 20 * army.troops[1] + 20 * army.troops[2];
    if(armyValue < 50) {
        armyTexture = loadImage("res/Unit/smallarmy.png");
    } else if(armyValue < 100) {
        armyTexture = loadImage("res/Unit/medarmy.png");
    } else {
        armyTexture = loadImage("res/Unit/largearmy.png");
    }
    armyTexture.blit(flags[army.owner.number], null, 0, 0);
    return armyTexture;
}