module graphics.TileDisplay;

import d2d;
import logic;
import graphics;

import std.random;

/**
 * A class full of static methods for displaying tile elements
 */
class TileDisplay {

    static Surface[] skylines; ///Every skyline building for city display
    static Surface[] flags; ///Every flag for unit displays

    /**
     * Places all skylines in the list of skylines for city display
     * TODO: make json based
     */
    static void loadSkylines() {
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
    static void loadFlags() {
        flags ~= loadImage("res/Flag/Historical/unitedstates.png");
        flags ~= loadImage("res/Flag/Historical/japan.png");
        flags ~= loadImage("res/Flag/Historical/unitedkingdom.png");
        flags ~= loadImage("res/Flag/Historical/nazi.png");
        flags ~= loadImage("res/Flag/Historical/soviet.png");
        flags ~= loadImage("res/Flag/Historical/italy.png");
        flags ~= loadImage("res/Flag/Historical/kuomintang.png");
        flags ~= loadImage("res/Flag/Historical/secondreich.png");
        flags ~= loadImage("res/Flag/Historical/china.png");
        flags ~= loadImage("res/Flag/Historical/ottoman.png");
        flags ~= loadImage("res/Flag/Historical/russia.png");
        flags ~= loadImage("res/Flag/Historical/france.png");
        flags.randomShuffle();
    }

    /**
     * Generates a semi-random image for a city
     * Creates mostly unique textures
     */
    static Surface generateCityTexture(City city) {
        Surface cityTexture = new Surface(50, 50, SDL_PIXELFORMAT_RGBA32);
        foreach(i; 0..city.level + 3) {
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
    static Surface generateArmyTexture(Army army) {
        Surface armyTexture;
        int armyValue = army.troops[0] + 20 * army.troops[1] + 20 * army.troops[2];
        if(armyValue < 40) {
            armyTexture = loadImage("res/Unit/smallarmy.png");
        } else if(armyValue < 80) {
            armyTexture = loadImage("res/Unit/medarmy.png");
        } else {
            armyTexture = loadImage("res/Unit/largearmy.png");
        }
        armyTexture.blit(flags[army.owner.number], null, 0, 0);
        return armyTexture;
    }

}