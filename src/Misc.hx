import haxe.Int64;

class Misc {
    
}

class Machine extends Entity {
    var id : String;
    var description : String;
}

class PlantSoil extends Machine {
    var state : Int;
    var plant : Plant;
    var interactions : String;
}

class Container extends Entity {
    
}

