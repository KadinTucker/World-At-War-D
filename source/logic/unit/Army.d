module logic.unit.Army;

import logic.player.Player;
import logic.unit.Unit;
import logic.world.Tile;
import logic.world.World;

class Army : Unit {

    this(Player owner, Coordinate location, World world) {
        super(owner, location, world);
        this.troops = [0, 0, 0];
    }

}