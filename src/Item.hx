class Item extends Entity {
    private var id : Int;
}

// TODO : All enum types need to be redesign for increasive prefermence.
enum ItemType {
    Food; Fruit; Resourse;
}

enum FruitType {
    Fruit; Nut; Seed;
}

class Fruit extends Item {
    var type : FruitType;
    var flavor : String;
    var tastes : Array<Float>;
    var generic_info : Map<String, Float>;

    public function new() {
        super();
        tastes = [0,0,0,0,0];
    }
}

class Seed extends Fruit {
    var state = "Fresh"; // need to design other structure
    var timeBirth : Int;
    var species : String;

    public function new(time : Int) {
        super();
        this.type = Seed;
        timeBirth = time;
    }
}