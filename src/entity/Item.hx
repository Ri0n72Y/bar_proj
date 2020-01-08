package entity;

class Item extends Entity {
    private var id : Int; // unused variable
    public final type : ItemType;
    public var fruitType : FruitType;
    public function new(type: ItemType) {
        super();
        this.type = type;
    }
}

// TODO : All enum types need to be redesign for increasive prefermence.
enum ItemType {
    Food; Fruit; Resourse; Seed;
}

enum FruitType {
    WF;
}


class Fruit extends Item{
    var flavor : String; //unused
    var tastes : Array<Float>; //unused
    var generic_info : Map<String, Float>; //unused

    public function new(type : FruitType) {
        super(ItemType.Fruit);
        this.fruitType = type;
        tastes = [0,0,0,0,0];
    }

    public override function isCarrible(e:Entity) : Bool {
        return true;
    }
}

class Seed extends Fruit {
    var state = "Fresh"; // need to design other structure
    var timeBirth : Int; // unused
    var species : String; // unused

    public function new(time : Int, type : FruitType) {
        super(type);
        this.type = ItemType.Seed;
        timeBirth = time;
    }
}