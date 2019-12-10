class Item extends Entity {
    private var id : Int;
}

// TODO : All enum types need to be redesign for increasive prefermence.
enum ItemType {
    Food; Fruit; Resourse;
}

enum FruitType {
    WF;
}

class Fruit extends Item {
    var flavor : String;
    var tastes : Array<Float>;
    var generic_info : Map<String, Float>;
    var type : FruitType;

    public function new(type : FruitType) {
        super();
        this.type = type;
        tastes = [0,0,0,0,0];
    }
}

class Seed extends Fruit {
    var state = "Fresh"; // need to design other structure
    var timeBirth : Int;
    var species : String;

    public function new(time : Int, type : FruitType) {
        super(type);
        timeBirth = time;
    }
}