class AssetManager {
    /*
    static final SLIME_FRONT = [0.,  0, 32, 32];
    static final SLIME_LEFT  = [0., 32, 32, 32];
    static final SLIME_BACK  = [0., 64, 32, 32];
    static final SLIME_RIGHT = [0., 96, 32, 32];

    static final WATERFRUIT = [ 0., 128, 20, 19];
    static final BLUE_BALL  = [21., 128, 24, 24];
    static final PLANT_SOIL = [46., 128, 42, 16];
    
    static final TILE_GRASS_A = [ 0., 0, 32, 32];
    static final TILE_GRASS_B = [32., 0, 32, 32];
    static final TILE_DIRT_A  = [96., 0, 32, 32];
    static final TILE_DIRT_B  = [128., 0, 32, 32];

    static final PLANT_WATERFRUIT_SEED = [48., 144, 16, 8];
    static final PLANT_WATERFRUIT_STAGE_A = [ 0., 152, 48, 40];
    static final PLANT_WATERFRUIT_STAGE_B = [48., 152, 48, 40];
    static final PLANT_WATERFRUIT_STAGE_C = [96., 152, 48, 40];
    */
    public static var sizeData : Dynamic; 

    public static function getAssetSize(name : String) : Dynamic{
        switch (name) {
            case "slime_front": return sizeData.slime_front;
            case "slime_left" : return sizeData.slime_left;
            case "slime_back" : return sizeData.slime_back;
            case "slime_right": return sizeData.slime_right;
            case "waterfruit" : return sizeData.waterfruit;
            case "blue_ball"  : return sizeData.blue_ball;
            case "plant_soil" : return sizeData.plant_soil;
            case "tile_grass_a": return sizeData.tile_grass_a;
            case "tile_grass_b": return sizeData.tile_grass_b;
            case "tile_dirt_a": return sizeData.tile_dirt_a;
            case "tile_dirt_b": return sizeData.tile_dirt_b;
            case "plant_waterfruit_seed": return sizeData.plant_waterfruit_seed;
            case "plant_waterfruit_stage_a": return sizeData.plant_waterfruit_stage_a;
            case "plant_waterfruit_stage_b": return sizeData.plant_waterfruit_stage_b;
            case "plant_waterfruit_stage_c": return sizeData.plant_waterfruit_stage_c;
            default : 
                trace ("Unknown tile name: " + name);
                return {x:-1., y:-1., w:-1., z:-1.};
        }
    }
}