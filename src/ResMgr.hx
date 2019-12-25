import h2d.Object;
import h2d.Tile;

class ResMgr {
    public final tiles : h2d.Tile;
    public final mapTiles : h2d.Tile;
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

    public function new(layers : h2d.Layers) {
        tiles = hxd.Res.charaAnim.toTile(); 
        mapTiles = hxd.Res.tiles.toTile();
        
        tile_grass1 = loadTileToSize(mapTiles, 0, 0, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, "default");
        tile_grass2 = loadTileToSize(mapTiles, TILE_SIZE, 0, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, "default");
        tile_dirt1  = loadTileToSize(mapTiles, TILE_SIZE * 3, 0, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, "default");
        tile_dirt2  = loadTileToSize(mapTiles, TILE_SIZE * 4, 0, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, "default");
        
        this.layers = layers;
        layers.add(parseMap(mapTiles, testmap), LAYER_STATIC);
    }

    function onLoad() {
    }

    public function parseMap(tile : h2d.Tile, maps : String) : h2d.Object {
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
                dx = -scaleX; dy = -(scaleY * .5);
            default :
                null;
        }
        var tile = tiles.sub(x, y, w, h, dx, dy);
        tile.scaleToSize(scaleX, scaleY);
        return tile;
    }
}