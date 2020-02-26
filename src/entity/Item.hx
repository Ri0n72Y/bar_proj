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

    public function put(item: Item):Bool {
        food.push(item);
        contains.add(item, 0);
        this.contains.ysort(0);
        return true;
    }
}

class Glass extends Plate {
    public function new() {
        super("glass");
    }

    override function put(item:Item):Bool {
        if (!(item is entity.Item.Food)) return false;
        var i:Dynamic=item;
        if (i.part != "juice")
            return false;
        var sp = this.getObjectByName("sprite");
        var r:Dynamic;
        if (isEmpty) { // checi if glass is empty
            r = new Juice();
            sp.addChildAt(r, 0);
            isEmpty = false;
        } else {
            r = sp.getChildAt(0); // should be class juice
        }

        if ((item is entity.Item.Fruit)) {
            r.putFruit(item); // possible cannot put
        } else if ((item is entity.Item.Juice))
            r.put(item);
        //TODO else if ((item is Tea)) 
        r.updateColor();
        item.remove();
        return true;
    }
}

class Juice extends Food {
    var juiceType: String; // a specific fruit or mix
    var mix: Array<Float>; // content that mixed inside

    static var fruits = ["apple", "orange", "lemon", "kiwi", "blueberry"];
    public function new() {
        super();
        mix = [0, 0, 0, 0, 0];
        this.getObjectByName("sprite").addChild(new h2d.Bitmap(hxd.Res.mui.toTile().sub(0, 24, 16, 16)));
    }
    public function put(juice:Juice) {
        for (i in 0...mix.length) {
            mix[i] += juice.mix[i];
        }
    }
    public function putFruit(juice:Fruit){
        var t = AssetManager.mtaste;
        var i = fruits.indexOf(juice.fruitType); // fruit id
        mix[i] += t.juice[i];
    }
    public function updateColor() {
        updateType();
        // change colour
        var matrix = new h3d.Matrix();
        matrix.colorSet(getFlavor(), 0.8);
        var shader = new h2d.filter.ColorMatrix(matrix);
        this.filter = shader;
    }

    function updateType() {
        var max = 0.0;
        var name: String = "mix";
        for (i in 0...mix.length) 
            if (mix[i] > max) {
                max = mix[i];
                name = fruits[i];
            }
        var r = getAmount();
        if (max / r < 0.7)
            juiceType = "mix";
        else
            juiceType = name;
    }

    public function getAmount():Float {
        var r = 0.0;
        for (i in mix)
            r += i;
        return r;
    }

    public function getFlavor():Int {
        var r = 0.0, g = 0.0;
        var t = AssetManager.mtaste;
        for (i in 0...mix.length) {
            r += t.taste[i][0] * mix[i]; // fruit sweetness
            g += t.taste[i][1] * mix[i]; // fruit sourness
        }
        var b = 0.0; // juice madness
        var chaosFactor:Float = fruits.length;
        if (juiceType != "mix") { 
            chaosFactor /= 2;
            b -= mix[fruits.indexOf(juiceType)] / chaosFactor;
        }
        for (i in 0...mix.length) {
            b += mix[i] / chaosFactor;
        }
        var sum = r + g + b;
        r = r / sum; g = g / sum; b = b / sum; // normalize
        var c = Std.int(r * 255) << 16;
        c += Std.int(g * 255) << 8;
        c += Std.int(b * 255);
        trace(c);
        return c;
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