import h2d.Object;
import h2d.Tile;
import AssetManager.getAssetSize;

class ResMgr {
    public final player : h2d.Tile;
    public final plants : h2d.Tile;
    public final items : h2d.Tile;
    public final tiles : h2d.Tile;
    var layers : h2d.Layers;
    
    public static inline final LAYER_STATIC = 0; // 静物层
    public static inline final LAYER_COLLIS = 2; // 实体碰撞箱
    public static inline final LAYER_ENTITY = 3; // 实体层
    public static inline final LAYER_UI = 5; // UI层
    public static final LAYERS = [LAYER_STATIC, LAYER_COLLIS, LAYER_ENTITY];

    public static final TILE_SIZE = 32; // 像素块标准大小
    public static final SCALED_SIZE = 80;
    public static final SCALE = 2.5;

    final tile_dirt1 : h2d.Tile;
    final tile_dirt2 : h2d.Tile;
    final tile_grass1 : h2d.Tile;
    final tile_grass2 : h2d.Tile;

    public final fac_plantsoil : h2d.Tile;
    public final fac_plantsoil_avl : h2d.Tile;

    public var map : h2d.Object;

    public static final plant_waterfruit: Array<h2d.Tile> = [];
    
    static var testmap = 
"...ddddd.........
..ddgggddddddd...
dddggggggggggdddd
dggggggggggggggdd
dggggggggggggggdd
dggggggggggggggdd
dggggggggggggggdd
dgggggggggggggddd
ddgggggggggdddd..
..ddddggggddd....
.....dddddd......";

    public function new() {
        player = hxd.Res.player.toTile();
        items = hxd.Res.items.toTile();
        plants = hxd.Res.plants.toTile();
        tiles = hxd.Res.tiles.toTile(); 

        onLoad();
        
        // add static map tiles
        var asset = getAssetSize("tile_grass_a");
        tile_grass1 = loadTileToSize(tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "default");
        var asset = getAssetSize("tile_grass_b");
        tile_grass2 = loadTileToSize(tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "default");
        var asset = getAssetSize("tile_dirt_a");
        tile_dirt1  = loadTileToSize(tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "default");
        var asset = getAssetSize("tile_dirt_b");
        tile_dirt2  = loadTileToSize(tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "default");
        
        map = parseMap(testmap);

        // load plant tiles
        var asset = getAssetSize("plant_waterfruit_seed");
        plant_waterfruit.push(loadTileToSize(plants, asset.x, asset.y, asset.w, asset.h, asset.w * SCALE, asset.h * SCALE, "bottom"));
        var asset = getAssetSize("plant_waterfruit_stages");
        plant_waterfruit.push(loadTileToSize(plants, asset.a.x, asset.a.y, asset.a.w, asset.a.h, asset.a.w * SCALE, asset.a.h * SCALE, "bottom"));
        plant_waterfruit.push(loadTileToSize(plants, asset.b.x, asset.b.y, asset.b.w, asset.b.h, asset.b.w * SCALE, asset.b.h * SCALE, "bottom"));
        plant_waterfruit.push(loadTileToSize(plants, asset.c.x, asset.c.y, asset.c.w, asset.c.h, asset.c.w * SCALE, asset.c.h * SCALE, "bottom"));

        // load plantsoil
        var ps = getAssetSize("plant_soil");
        var asset = ps.full;
        fac_plantsoil = loadTileToSize(items, asset.x, asset.y, asset.w, asset.h, asset.w * SCALE, asset.h * SCALE, "centre");

        var ps = getAssetSize("plant_soil_avl");
        var asset = ps.full;
        fac_plantsoil_avl = loadTileToSize(items, asset.x, asset.y, asset.w, asset.h, asset.w * SCALE, asset.h * SCALE, "centre");
    }

    function onLoad() {
        try {
            var s = haxe.Json.parse(hxd.Res.imageSizeData.entry.getText());
            AssetManager.imageSizeData = s;
            var s = haxe.Json.parse(hxd.Res.tileSizeData.entry.getText());
            AssetManager.tileSizeData = s;
        } catch (e : Dynamic) {
            trace("Error on load json file.");
        }
    }

    public function parseMap(maps : String) : h2d.Object {
        var map = new h2d.Object();
        map.name = "map";
        var len = maps.indexOf('\n');
        var j = 0;
        for (i in 0...maps.length) {
            var char = maps.charAt(i);
            var tile;
            if (char == "d") {
                if (i % 2 == 0)
                    tile = new h2d.Bitmap(tile_dirt1);
                else
                    tile = new h2d.Bitmap(tile_dirt2);
            } else if ((char == "g")) {
                if (i % 2 == 0)
                    tile = new h2d.Bitmap(tile_grass1);
                else
                    tile = new h2d.Bitmap(tile_grass2);
            } else if (char == '\n') {
                j ++;
                continue;
            } else {
                continue;
            }
            tile.x = (i - j * (len + 1)) * SCALED_SIZE;
            tile.y = j * SCALED_SIZE;
            map.addChild(tile);
        }
        return map;
    }

    /**
     * 将图片 load 成对应大小的 tile
     * @param tiles 整块的png
     * @param x 左上x
     * @param y 左上y
     * @param w 宽
     * @param h 高  
     * @param scaleX 缩放后的宽
     * @param scaleY 缩放后的高
     * @param centre "centre", "default", "bottom"
     * @return 切分调整完成的tile
     */
    public static function loadTileToSize(tiles : Tile, x:Float, y:Float, w:Float, h:Float, scaleX:Float, scaleY:Float, centre : String) : h2d.Tile {
        var dx = 0.0; var dy = 0.0;
        switch (centre) {
            case "centre" : 
                dx = -(scaleX * .5); dy = -(scaleY * .5);
            case "bottom" :
                dx = -(scaleX * .5); dy = -scaleY;
            default :
                null;
        }
        var tile = tiles.sub(x, y, w, h, dx, dy);
        tile.scaleToSize(scaleX, scaleY);
        return tile;
    }
}