import std.random;
import std.math;

class Coordinate{

    int x;
    int y;

    this(int x, int y){
        this.x = x;
        this.y = y;
    }

    override string toString(){
        return "(",x,", ",y,")";
    }

}

class World{

    char[][] tiles = [];
    char[] playerTerritory;
    char[] playerMilitary;
    char[] playerCities;
    char water;
    char land;

    this(int ncontinents, int nrows, int ncols, char water, char land){
        this.land = land;
        this.water = water;

        char[] blankArray = [];
        for(int x = 0; x < nrows; x++){
            //writeln("iterate outer x",x);
            tiles ~= blankArray.dup;
            //writeln(tiles);
            for(int y = 0; y < ncols; y++){
                tiles[x] ~= water;
            }
        }
        for(int i = 0; i < ncontinents; i++){
            tiles[uniform(0, nrows - 1)][uniform(0, ncols - 1)] = land;
        }
        int generated = ncontinents;
        double correlation;
        while (generated < (nrows * ncols) / 3){
            for(int x = 0; x < tiles.length; x++){
                for(int y = 0; y < tiles[x].length; y++){
                    if(tiles[x][y] != land){
                        correlation = 0;
                        if(y < tiles[x].length - 1 && tiles[x][y+1] == land){
                            correlation += 0.25;
                        }
                        if(y > 0 && tiles[x][y-1] == land){
                            correlation += 0.25;
                        }
                        if(x < tiles.length - 1 && tiles[x+1][y] == land){
                            correlation += 0.25;
                        }
                        if(x > 0 && tiles[x-1][y] == land){
                            correlation += 0.25;
                        }
                        if(uniform(0.0, 1.0) < correlation){
                            tiles[x][y] = land;
                            generated += 1;
                        }
                    }
                }
            }
        }
    }

    void printWorld(){
        for(int x = 0; x < tiles.length; x++){
            for(int y = 0; y < tiles[x].length; y++){
                write('|');
                write(tiles[x][y]);
            }
            write(" |",x);
            writeln();
        }

        for(int i=0; i < tiles[0].length; i++){
            write("__");
        }
        writeln();

        int maxDigits = countDigits(tiles[0].length);
        int numToWrite;
        int numIterations;
        for(int i = maxDigits; i > 0; i--){
            write(" ");
            for(int j = 0; j < tiles[0].length; j++){
                if(countDigits(j) > numIterations){
                    numToWrite = j * pow(10, maxDigits - countDigits(j));
                    write(getNthDigit(numToWrite, i));
                }else{
                    write(" ");
                }
                write(" ");
            }
            writeln();
            numIterations++;
        }
    }
}

int countDigits(int num){
    if(num == 0){
        return 1;
    }
    int count = 0;
    while(num > 0){
        num /= 10;
        count += 1;
    }
    return count;
}

int getNthDigit(int num, int digit){
    return (num / pow(10, digit - 1)) % 10;
}

unittest{

    import std.stdio;

    int number = 89304;
    writeln(getNthDigit(89304, 5));
    writeln(getNthDigit(89304, 4));
    writeln(getNthDigit(89304, 3));
    writeln(getNthDigit(89304, 2));
    writeln(getNthDigit(89304, 1));

    World world = new World(4, 30, 40, '_', '+');
    world.printWorld();

}
