class AssetManager {
    static final SLIME_FRONT = [0.,  0, 32, 32];
    static final SLIME_LEFT  = [0., 32, 32, 32];
    static final SLIME_BACK  = [0., 64, 32, 32];
    static final SLIME_RIGHT = [0., 96, 32, 32];

    static final WATERFRUIT = [ 0., 128, 20, 19];
    static final BLUE_BALL  = [21., 128, 24, 24];
    static final PLANT_SOIL = [46., 128, 42, 16];

    public static function getAssetSize(code : String) : Asset{
        switch (code) {
            case "slime_front":
                return getAsset(SLIME_FRONT);
            case "slime_left" :
                return getAsset(SLIME_LEFT);
            case "slime_back" :
                return getAsset(SLIME_BACK);
            case "slime_right":
                return getAsset(SLIME_RIGHT);
            case "waterfruit" :
                return getAsset(WATERFRUIT);
            case "blue_ball"  :
                return getAsset(BLUE_BALL);
            case "plant_soil" :
                return getAsset(PLANT_SOIL);
            default : 
                return new NullAsset();
        }
    }

    static function getAsset(size : Array<Float>) : Asset{
        return new Asset(size[0], size[1], size[2], size[3]);
    }
}

class Asset {
    public var x : Float;
    public var y : Float;
    public var w : Float;
    public var h : Float;

    public function new(x, y, w, h) {
        this.x = x; this.y = y; this.w = w; this.h = h;
    }
}

class NullAsset extends Asset {
    public function new() {
        super(-1, -1, -1, -1);
    }
}