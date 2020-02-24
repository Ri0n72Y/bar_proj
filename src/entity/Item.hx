package entity;

class Item extends Entity {
    private var id : Int; // unused variable
    public final type : ItemType;
    public function new(type: ItemType) {
        super();
        this.type = type;
    }
}

// TODO : All enum types need to be redesign for increasive prefermence.
enum ItemType {
    Food; Fruit; Resourse; Seed; Tool; Plate;
}

enum FruitType {
    WF;
}

class Plate extends Item {
    public var isDirty : Bool;
    var food : Array<Dynamic>;
    var contains : h2d.Layers;
    public var size : String;
    public function new(size: String) {
        super(ItemType.Plate);
        this.size = size;
        contains = new h2d.Layers(this);
        contains.name = "food";
        this.addChild(contains);
        isDirty = false;
        food = [];
    }

    public function put(item: Item) {
        food.push(item);
        contains.add(item, 0);
        this.contains.ysort(0);
    }
}

class Juice extends Food {
    var juiceType: String;
    var mix: Array<Float>;
    public function new() {
        super();
        mix = [];
    }
    public function getMix() {
        return(mix);
    }
    public function put(juice:Juice) {
        var i = 0;
        for (e in mix) {
            e = (e + juice.mix[i]) / 2;
            i ++; 
        }
    }
}

class Food extends Item {
    public function new() {
        super(ItemType.Food);
    }
}

class Fruit extends Food{
    var flavor : String; //unused
    var tastes : Array<Float>; //unused
    public var fruitType : String;
    public var part : String;
    var generic_info : Map<String, Float>; //unused

    public function new(type : String, part: String) {
        super();
        this.fruitType = type;
        this.part = part;
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

    public function new(time : Int, type : String) {
        super(type, "seed");
        this.type = ItemType.Seed;
        timeBirth = time;
    }
}