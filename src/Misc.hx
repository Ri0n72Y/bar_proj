import haxe.Int64;

class Misc {
    
}

class Facility extends Entity {
    var id : String;
    var description : String;
}

class PlantSoil extends Facility {
    var state : Int;
    var plant : Plant;
    var interactions : String;
}

class Container extends Entity {
    
}

