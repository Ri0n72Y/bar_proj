import h2d.Bitmap;

class Plant extends Entity {
    public var stage = 0;
    public final MAX_STAGE : Int;
    public var sprites : Array<Bitmap>;
    public var nextStage : Float; // seconds to the next stage
    /**
     * Basic Class for all plant class
     * @param stage number of current stage, start with 0,
     * @param max number of maximum stages, equals to the length of array sprites
     * @param next seconds to the next stage
     */
    public function new(stage : Int, max : Int, next : Float) {
        super();
        this.stage = stage;
        this.MAX_STAGE = max;
        this.nextStage = next;
    }

    function growth() : Bool {
        return false;
    }
}

class Plant_Waterfruit extends Plant {
    public function new(sprites : Array<Bitmap>) {
        super(0, sprites.length, 10);
        this.sprites = sprites;
        this.sprite = sprites[0];
    }

    public override function growth() : Bool {
        if (this.stage + 1 >= MAX_STAGE) return false;
        stage ++;
        nextStage = 10; // TODO : take to next stage algorithm
        sprite = this.sprites[stage];
        isSpriteChanged = true;
        return true;
    }

    public override function update(dt: Float) {
        super.update(dt);
        this.nextStage -= dt;
        if (nextStage <= 0) growth();
    }
}