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
    public var isEmpty : Bool;
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
        isEmpty = true;
        food = [];
    }

    public function put(item: Item) {
        food.push(item);
        contains.add(item, 0);
        this.contains.ysort(0);
    }
}

class Glass extends Plate {
    public function new() {
        super("glass");
    }

    override function put(item:Item) {
        var sp = this.getObjectByName("sprite");
        if (isEmpty)
            sp.addChildAt(item, 0);
        else {
            var r:Dynamic = sp.getChildAt(0); // should be class juice
            if ((item is Fruit))
                r.putFruit(item);
            else if ((item is Juice))
                r.put(item);
            //TODO else if ((item is Tea)) 
        }
    }
}

class Juice extends Food {
    var juiceType: String; // a specific fruit or mix
    var mix: Array<Float>; // content that mixed inside

    static var fruits = ["apple", "orange", "lemon", "kiwi", "blueberry"];
    public function new() {
        super();
        mix = [0, 0, 0, 0, 0];
    }
    public function put(juice:Juice) {
        for (i in 0...mix.length) {
            mix[i] += juice.mix[i];
        }
        updateColor();
    }
    public function putFriut(juice:Fruit):Bool{
        if (juice.part != "juice")
            return false;
        var t = AssetManager.mtaste;
        var i = fruits.indexOf(juice.fruitType); // fruit id
        mix[i] += t.juice[i][1];
        return true;
    }
    function updateColor() {
        // change colour
        var matrix = new h3d.Matrix();
        matrix.colorSet(getFlavor(), 0.8);
        var shader = new h2d.filter.ColorMatrix(matrix);
        this.filter = shader;
    }
    public function getAmount():Float {
        var r = 0.0;
        for (i in mix)
            r += i;
        return r;
    }
    public function getFlavor():Int {
        var r, g, b;
        var t = AssetManager.mtaste;
        for (i in 0...mix.length) {
            r += t.taste[i][0] * mix[i]; // fruit sweetness
            g += t.taste[i][1] * mix[i]; // fruit sourness
            b += t.juice[i][0] * mix[i]; // juice hardness
        }
        var sum = r + g + b;
        r = r / sum; g = g / sum; b = b / sum; // normalize
        return Std.int(r * 255) << 16 + Std.int(g * 255) << 8 + Std.int(b * 255);
    }
}

class Food extends Item {
    public function new() {
        super(ItemType.Food);
    }
}

class Fruit extends Food{
    var flavor : String; //unused
    var tastes : Array<Float>; 
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