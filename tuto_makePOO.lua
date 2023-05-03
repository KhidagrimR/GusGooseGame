-- TUTO from here https://www.youtube.com/watch?v=g1iKA3lSFms&list=PL1A1gsSe2tMzpqi8hE5bCUCyQdAWwthuz&index=2

-- HERE WE MAKE A CLASS
Animal = {}
Animal.__index = Animal

function Animal.new(name)
    local instance = setmetatable({}, Animal)
    instance.name = name
    return instance
end

function Animal:displayName()
    print( self.name)
end


animal1 = Animal.new("doge")
animal2 = Animal.new("cat")
animal3 = Animal.new("quick")

animal1:displayName()
animal2:displayName()
animal3:displayName()



-- HERE WE MAKE ABSTRACT CLASSES

-- abstract animal
AnimalAbstract = {}
AnimalAbstract.__index = AnimalAbstract

-- to make it abstract, we remove the 'new' function 
function AnimalAbstract:displayName()
    print( self.name)
end

-- abstract fish
Fish = {}
Fish.__index = Fish
setmetatable(Fish, AnimalAbstract) -- Fish inherit from animal

RedHerring = {}
RedHerring.__index = RedHerring
setmetatable(RedHerring, Fish)

function RedHerring.new (name)
    local instance = setmetatable({}, RedHerring)
    instance.name = name
    return instance
end


fish1 = RedHerring.new("Bob")
fish1:displayName()

-- How does it work ? fish1 search in it's own table if there is a function displayName, if not, it check the metatable above
-- -> it allow to overshadow a function and cherrypick the one we want to override (cf tuto if not well explained here)
