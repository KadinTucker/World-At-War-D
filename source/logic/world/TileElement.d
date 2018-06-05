module logic.world.TileElement;

import logic;

/**
 * A 'game piece', an object to found on the world map
 */
class TileElement {

    Player owner; ///The player owning this element
    Coordinate location; ///The location of the element
    World world; ///The world of which the element is a part

    /**
     * Constructs a new tile element, owned by the given player,
     * at the given location in the given world
     */
    this(Player owner, Coordinate location, World world) {
        this.owner = owner;
        this.location = location;
        this.world = world;
    }

}