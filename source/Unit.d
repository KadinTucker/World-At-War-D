abstract class Unit{

    int hitpoints;
    int damage;
    int range;
    string name;

    this(int hitpoints, int damage, int range, string name){
        this.hitpoints = hitpoints;
        this.damage = damage;
        this.range = range;
        this.name = name;
    }

    void cityAttack();
    void batallionAttack();

}

abstract class Batallion(){

    Coordinate location;
    Player owner;
    int moves;
    int[Unit] units;
    char[] passableTiles;

    this(Coordinate location, Player owner, int moves){
        this.location = location;
        this.owner = owner;
        this.moves = moves;
    }

    void getInfo(this){
        foreach(unit; units.keys){
            writeln("Number of ",unit.name,": ",units[unit]);
        }
    }

    void add(Batallion other){
        if(typeof(this) == typeof(other)){
            foreach(unit; this.units.keys){
                this.units[unit] += other.units[unit];
            }
        }
    }

    bool hasUnits(){
        foreach(unit; this.units.values){
            if(unit > 0){
                return true;
            }
        }
        return false;
    }

//TODO: Add choose cardinal direction function

/*
    def move(this, world, players){
        int numMoves = this.moves;
        while(numMoves > 0){
            writeln("You have ",numMoves," moves remaining.");
            string[] directions = ["n", "s", "e", "w", "stop"]
            if(this.location.x <= 0){
                directions.remove("n");
            }
            else if(this.location.x >= world.tiles.length - 1){
                directions.remove("s");
            }
            if(this.location.x <= 0){
                directions.remove("w");
            }
            else if(this.location.x >= world.tiles.length - 1){
                directions.remove("e");
            }
            if 'n' in directions and world[this.location[0] - 1][this.location[1]] in invalidTiles:
                directions.remove('n')
            if 's' in directions and world[this.location[0] + 1][this.location[1]] in invalidTiles:
                directions.remove('s')
            if 'w' in directions and world[this.location[0]][this.location[1] - 1] in invalidTiles:
                directions.remove('w')
            if 'e' in directions and world[this.location[0]][this.location[1] + 1] in invalidTiles:
                directions.remove('e')
            print('Move to where? ' + str(directions))
            response = 'z'
            while len(response) == 0 or response[0] not in directions:
                response = input()
            if response == 'stop':
                print('Ok then.')
                break
            world[this.location[0]][this.location[1]] = this.owner.icons['territory']
            if response[0] == 'n':
                this.location = (this.location[0] - 1, this.location[1])
            elif response[0] == 's':
                this.location = (this.location[0] + 1, this.location[1])
            elif response[0] == 'w':
                this.location = (this.location[0], this.location[1] - 1)
            elif response[0] == 'e':
                this.location = (this.location[0], this.location[1] + 1)

            if world[this.location[0]][this.location[1]] != this.owner.icons['territory'] and world[this.location[0]][this.location[1]] not in playerCities:
                captureTerritory(world[this.location[0]][this.location[1]])
                world[this.location[0]][this.location[1]] = this.owner.icons['army']
                this.owner.territory += 1
                this.moves = 0
            elif world[this.location[0]][this.location[1]] == this.owner.icons['territory']:
                world[this.location[0]][this.location[1]] = this.owner.icons['army']
                displayWorld(world)
                this.moves -= 1
            else:
                this.owner.armies.remove(this)
                c = findMilitary(this.location, players)
                c.army.add(this)
                print('Garrisoned in city at ' + str(this.location))
                if this.supplies > 0:
                    c.addSupplies(this)
                c.army.infantryDamage = 0
                c.army.tankDamage = 0
                c.army.artilleryDamage = 0
                return False

        displayWorld(world)

        return True*/

    void captureCity(City enemy, World world){
        if(enemy.defense <= 0){
            writeln("City captured!!")
            enemy.production /= 2;
            enemy.defense /= 2;
            enemy.owner.cities.remove(enemy)
            enemy.owner = this.owner
            this.owner.cities ~= enemy;
            world.tiles[enemy.location[0]][enemy.location[1]] = this.owner.icons["city"];
        }
    }

    void resolveWounds(damage, world);

//TODO: Add get location input method, along with get integer method.

    /*def attack(this, players, world):
        displayWorld(world)
        if len(self.attacks) > 0:
            response = -1
            while response not in self.attacks:
                print('Attack with what? ' + str(self.attacks))
                response = input()
            if response == 'artillery':
                range_ = 3
            else:
                range_ = 1
            army = None
            print('Choose the horizontal position.')
            y = getIntInput(0, len(world[0]) - 1)
            print('Choose the vertical position.')
            x = getIntInput(0, len(world) - 1)
            if abs(x - self.location[0]) + abs(y - self.location[1]) > range_:
                print('Out of range!')
            else:
                army = findMilitary((x, y), players)
            if army == None:
                print('No enemies there.')
            else:
                if army.type == 'city':
                    if response == 'artillery':
                        self.attacks.remove('artillery')
                        self.artillerySiege(army, world)
                    elif response == 'front':
                        self.attacks.remove('front')
                        self.frontSiege(army, world)
                elif response == 'artillery':
                    self.attacks.remove('artillery')
                    self.artilleryShot(army, world)
                elif response == 'front':
                    self.attacks.remove('front')
                    self.frontShot(army, world)
        else:
            print('No attacks remaining.')*/


}
