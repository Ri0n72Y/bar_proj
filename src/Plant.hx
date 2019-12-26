import h2d.Bitmap;

class Plant extends Entity {
    public var stage = 0;
    public final MAX_STAGE : Int;
    public var sprites : Array<Bitmap>;
    public function new(stage : Int, max : Int) {
        super();
        this.stage = stage;
        this.MAX_STAGE = max;
    }

    function growth() : Bool {
        return false;
    }
}

class Plant_Waterfruit extends Plant {
    public function new(sprites : Array<Bitmap>) {
        super(0, sprites.length);
        this.sprites = sprites;
        this.sprite = sprites[0];
    }

    public override function growth() : Bool {
        if (this.stage + 1 >= MAX_STAGE) return false;
        stage ++;
        sprite = this.sprites[stage];
        isSpriteChanged = true;
        return true;
    }

    public override function update() {
        super.update();
    }
}