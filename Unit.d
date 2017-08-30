abstract class Army(){}
    this(location, owner):
        this.location = location
        this.owner = owner
        self.infantry = 0
        self.infantryDamage = 0
        self.tanks = 0
        self.tankDamage = 0
        self.artillery = 0
        self.artilleryDamage = 0
        self.supplies = 0
        self.supplyOrigin = location
        self.moves = 5
        self.type = 'army'
        self.attacks = ['front', 'artillery']

    def compileInfo(self):
        return [self.location, self.owner.playerNum, self.infantry, self.infantryDamage, self.tanks, self.tankDamage,
                self.artillery, self.artilleryDamage, self.supplies, self.supplyOrigin]

    def loadInfo(self, attribList, players):
        #print(attribList)
        self.location = tuple(attribList[0])
        self.owner = players[attribList[1]]
        self.infantry = attribList[2]
        self.infantryDamage = attribList[3]
        self.tanks = attribList[4]
        self.tankDamage = attribList[5]
        self.artillery = attribList[6]
        self.artilleryDamage = attribList[7]
        self.supplies = attribList[8]
        self.supplyOrigin = attribList[9]
        return self

    def getInfo(self):
        print('Number of Infantry: ' + str(self.infantry))
        print('Number of Tanks: ' + str(self.tanks))
        print('Number of Artillery: ' + str(self.artillery))
        print('Supplies Escorted: ' + str(self.supplies))

    def add(self, other):
        self.infantry += other.infantry
        self.tanks += other.tanks
        self.artillery += other.artillery

    def hasUnits(self):
        return self.infantry > 0 or self.tanks > 0 or self.artillery > 0 or self.supplies > 0

    def move(self, world, players):
        invalidTiles = [water] + playerMilitary
        while self.moves > 0:
            print('You have ' + str(self.moves) + ' moves remaining.')
            directions = ['n', 's', 'e', 'w', 'stop']
            if self.location[0] <= 0:
                directions.remove('n')
            elif self.location[0] >= len(world) - 1:
                directions.remove('s')
            if self.location[1] <= 0:
                directions.remove('w')
            elif self.location[1] >= len(world[0]) - 1:
                directions.remove('e')
            if 'n' in directions and world[self.location[0] - 1][self.location[1]] in invalidTiles:
                directions.remove('n')
            if 's' in directions and world[self.location[0] + 1][self.location[1]] in invalidTiles:
                directions.remove('s')
            if 'w' in directions and world[self.location[0]][self.location[1] - 1] in invalidTiles:
                directions.remove('w')
            if 'e' in directions and world[self.location[0]][self.location[1] + 1] in invalidTiles:
                directions.remove('e')
            print('Move to where? ' + str(directions))
            response = 'z'
            while len(response) == 0 or response[0] not in directions:
                response = input()
            if response == 'stop':
                print('Ok then.')
                break
            world[self.location[0]][self.location[1]] = self.owner.icons['territory']
            if response[0] == 'n':
                self.location = (self.location[0] - 1, self.location[1])
            elif response[0] == 's':
                self.location = (self.location[0] + 1, self.location[1])
            elif response[0] == 'w':
                self.location = (self.location[0], self.location[1] - 1)
            elif response[0] == 'e':
                self.location = (self.location[0], self.location[1] + 1)

            if world[self.location[0]][self.location[1]] != self.owner.icons['territory'] and world[self.location[0]][self.location[1]] not in playerCities:
                captureTerritory(world[self.location[0]][self.location[1]])
                world[self.location[0]][self.location[1]] = self.owner.icons['army']
                self.owner.territory += 1
                self.moves = 0
            elif world[self.location[0]][self.location[1]] == self.owner.icons['territory']:
                world[self.location[0]][self.location[1]] = self.owner.icons['army']
                displayWorld(world)
                self.moves -= 1
            else:
                self.owner.armies.remove(self)
                c = findMilitary(self.location, players)
                c.army.add(self)
                print('Garrisoned in city at ' + str(self.location))
                if self.supplies > 0:
                    c.addSupplies(self)
                c.army.infantryDamage = 0
                c.army.tankDamage = 0
                c.army.artilleryDamage = 0
                return False

        displayWorld(world)
        self.moves = 5
        return True

    def frontShot(self, enemy, world):
        enemy.resolveWounds(self.tanks * 10 + self.infantry, world)

    def frontSiege(self, enemy, world):
        enemy.defense -= self.tanks * 8 + self.infantry
        print('Bombarded city with ' + str(self.tanks * 6 + self.infantry) + ' damage!')
        print('Fortification HP remaining: ' + str(enemy.defense) + '/' + str(enemy.production*10))
        self.captureCity(enemy, world)

    def artilleryShot(self, enemy, world):
        enemy.resolveWounds(self.artillery * 14, world)

    def artillerySiege(self, enemy, world):
        enemy.defense -= self.artillery * 20
        print('Bombarded city with ' + str(self.artillery * 10) + ' damage!')
        print('Fortification HP remaining: ' + str(enemy.defense) + '/' + str(enemy.production*10))
        self.captureCity(enemy, world)

    def captureCity(self, enemy, world):
        if enemy.defense <= 0:
            print('City captured!!')
            enemy.production = int(enemy.production/2)
            enemy.defense = int(enemy.getDefense()/2)
            enemy.owner.cities.remove(enemy)
            enemy.owner.cities.army = Army(self.owner, enemy.location)
            enemy.owner.cities.fleet = Fleet(self.owner, enemy.location)
            enemy.owner = self.owner
            self.owner.cities.append(enemy)
            world[enemy.location[0]][enemy.location[1]] = self.owner.icons['city']

    def resolveWounds(self, damage, world):
        tankKilled = 0
        infantryKilled = 0
        artilleryKilled = 0
        while damage > 0:
            if self.tanks > 0:
                self.tankDamage += 1
                damage -= 1
                if self.tankDamage >= 30:
                    self.tanks -= 1
                    self.tankDamage -= 30
                    #print('Tank destroyed!')
                    tankKilled += 1
            else:
                if damage > 0 and self.infantry > 0:
                    #print('Infantry took damage')
                    self.infantryDamage += 1
                    if self.infantryDamage >= 2:
                        #print('Infantry destroyed.')
                        self.infantry -= 1
                        self.infantryDamage -= 2
                        infantryKilled += 1
                    damage -= 1
                if damage > 0 and self.artillery > 0:
                    self.artilleryDamage += 1
                    if damage > 0 and self.artilleryDamage >= 20:
                        self.artillery -= 1
                        self.artilleryDamage -= 20
                        artilleryKilled += 1
                    damage -= 1
            if self.artillery <= 0 and self.tanks <= 0 and self.infantry <= 0:
                self.owner.armies.remove(self)
                world[self.location[0]][self.location[1]] = self.owner.icons['territory']
                break
        print('Enemy Casualties: ')
        print('Infantry: ' + str(infantryKilled) + ', sustained ' + str(self.infantryDamage) + ' wounds.')
        print('Tanks: ' + str(tankKilled) + ', sustained ' + str(self.tankDamage) + ' damage.')
        print('Artillery: ' + str(artilleryKilled) + ', sustained ' + str(self.artilleryDamage) + ' damage.')

    def attack(self, players, world):
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
            print('No attacks remaining.')
