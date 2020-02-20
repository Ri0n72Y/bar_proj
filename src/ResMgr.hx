import haxe.Json;
import haxe.macro.Expr.Error;
import h2d.Object;
import h2d.Tile;
import AssetManager.getAssetSize;
import AssetManager.mlayoutData;

class ResMgr {
    public var player : h2d.Tile;
    public var plants : h2d.Tile;
    public var items : h2d.Tile;
    public var tiles : h2d.Tile;
    
    public static inline final LAYER_STATIC = 0; // 静物层
    public static inline final LAYER_COLLIS = 2; // 实体碰撞箱
    public static inline final LAYER_ENTITY = 3; // 实体层
    public static inline final LAYER_UI = 5; // UI层
    public static final LAYERS = [LAYER_STATIC, LAYER_COLLIS, LAYER_ENTITY];

    public static final TILE_SIZE = 32; // 像素块标准大小
    public static final SCALED_SIZE = 80;
    public static final SCALE = 2.5;

    var tile_dirt1 : h2d.Tile;
    var tile_dirt2 : h2d.Tile;
    var tile_grass1 : h2d.Tile;
    var tile_grass2 : h2d.Tile;

    public var fac_plantsoil : h2d.Tile;
    public var fac_plantsoil_avl : h2d.Tile;

    public var map : h2d.Object;

    public static final plant_waterfruit: Array<h2d.Tile> = [];

    // data for mobile version use
    public var res : Array<Dynamic> ;


    

    public final s = {
        f : {
            a : {offx:0, offy:0},
            b : {offx:0, offy:1},
            c : {offx:-2, offy:4},
            d : {offx:-4, offy:4},
            e : {offx:-4, offy:4}
        },
        b : {
            a : {offx:0, offy:0},
            b : {offx:0, offy:0},
            c : {offx:2, offy:-2},
            d : {offx:3, offy:-3},
            e : {offx:3, offy:-4}
        }
    }

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

    public function new(type : String) {
        switch (type) {
            case "main" :
                player = hxd.Res.player.toTile();
                items = hxd.Res.items.toTile();
                plants = hxd.Res.plants.toTile();
                tiles = hxd.Res.tiles.toTile(); 
                loadMain();
            case "mobile" :
                items = hxd.Res.m256x.toTile();
                var s = haxe.Json.parse(hxd.Res.msizeData.entry.getText());
                AssetManager.msizeData = s;
                var m = Json.parse(hxd.Res.mlayoutData.entry.getText());
                AssetManager.mlayoutData = m;
                loadMobile();
            default :
                throw new Error("Unknown Resourse Scenario.", {min: 49, max: 62, file: "src/ResMgr"});
        }
    }

    function loadMain() {

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

    function loadMobile() {
        res = new Array<Dynamic>();
        // load background
        var tile = hxd.Res.mlayout_vert.toTile(); tile.scaleToSize(540, 960);
        var background = new h2d.Bitmap(tile);
        res.push(background); // index 0
        // load UI
        var tile = hxd.Res.mhandbook.toTile(); tile.scaleToSize(540, 960);
        var handbook = new h2d.Bitmap(tile);

        res.push(handbook); // index 1
        // build slime animations
        var slimes = hxd.Res.slimebase.toTile();
        var sprites = []; // stand sprite
        var anims = []; // animation clips
        var offx = 0, offy = 0, k = 0;
        while (k < 8) {
            var i = 0, j = 0;
            while (j < 128) {
                var frames = [];
                while (i < 128) {
                    var w = 32;
                    if ((i == 64) || (j > 64) && (i == 32)) w = 34;
                    var frame = loadTileToSize(slimes, offx + i, offy + j, w, 32, w * 2, 64, "default");
                    if (i == 0) sprites.push(new h2d.Bitmap(frame));
                    frames.push(frame); 
                    i += w;
                }
                i = 0;
                j += 32;
                anims.push(new h2d.Anim(frames));
            }
            k ++;
            offx = (k % 4) * 136; offy = Math.floor(k / 4) * 128; 
        }
        res.push(sprites); // index 2
        res.push(anims); // index 3
        // load fruits
        var fruits = [];
        var fruitTextures = [
            ["apple", "apple_half", "apple_peel", "apple_slice", "apple_slicegroup", "apple_dice"],
            ["orange", "orange_half", "orange_peel", "orange_slice", "orange_slicegroup"],
            ["lemon", "lemon_half", "lemon_slice", "lemon_slicegroup"],
            ["kiwi", "kiwi_half", "kiwi_slice", "kiwi_slicegroup", "kiwi_smash"],
            ["blueberry", "blueberry_mush"]
        ];
        for (textures in fruitTextures) {
            var fruit = []; 
            for (name in textures) {
                var size = getAssetSize(name);
                fruit.push(loadTileToSize(items, size.x, size.y, size.w, size.h, size.w * 2, size.h * 2, "default"));
            }
            fruits.push(fruit);
        }
        res.push(fruits); // index 4
        // Load items
        res.push(loaditems()); // index 5

        // Load cellar
        var tile = hxd.Res.mcellar.toTile();
        res.push(new h2d.Bitmap(tile)); // index 6

    }

    function loaditems(){
        var list : Array<Dynamic> = mlayoutData.scene;
        var layout_result: Array<Dynamic> = [];
        for (i in list) {
            var name = i.name;
            switch (name) {
              case "rectangle": 
                var elements: Array<Dynamic> = [];
                name = "rectangle_up";
                var asset = getAssetSize(name);
                var item_tile = loadTileToSize(items,asset.x,asset.y,asset.w,asset.h,asset.w*2,asset.h*2,"default");
                var item_bitmap = new h2d.Bitmap(item_tile);
                elements.push(name);
                elements.push(item_bitmap);
                elements.push(2*i.x);
                elements.push(2*i.y);
                
                var elements2: Array<Dynamic> = [];
                name = "rectangle_down";
                var asset = getAssetSize(name);
                var item_tile = loadTileToSize(items,asset.x,asset.y,asset.w,asset.h,asset.w*2,asset.h*2,"default");
                var item_bitmap = new h2d.Bitmap(item_tile);
                elements2.push(name);
                elements2.push(item_bitmap);
                elements2.push(2*i.x);
                elements2.push(2*i.y);
                layout_result.push(elements2);
                layout_result.push(elements);

              case "mixer":
                var elements: Array<Dynamic> = [];
                name = "mixer";
                var asset = getAssetSize(name);
                var item_tile = loadTileToSize(items,asset.x,asset.y,asset.w,asset.h,asset.w*2,asset.h*2,"default");
                var item_bitmap = new h2d.Bitmap(item_tile);
                elements.push(name);
                elements.push(item_bitmap);
                elements.push(2*i.x);
                elements.push(2*i.y+2);
                layout_result.push(elements);

              case "cut":
                var elements: Array<Dynamic> = [];
                name = "cut_open";
                var asset = getAssetSize(name);
                var item_tile = loadTileToSize(items,asset.x,asset.y,asset.w,asset.h,asset.w*2,asset.h*2,"default");
                var item_bitmap = new h2d.Bitmap(item_tile);
                elements.push(name);
                elements.push(item_bitmap);
                elements.push(2*i.x);
                elements.push(2*i.y);
                layout_result.push(elements);

              default:
                var elements: Array<Dynamic> = [];
                var asset = getAssetSize(name);
                var item_tile = loadTileToSize(items,asset.x,asset.y,asset.w,asset.h,asset.w*2,asset.h*2,"default");
                var item_bitmap = new h2d.Bitmap(item_tile);
                elements.push(name);
                elements.push(item_bitmap);
                elements.push(2*i.x);
                elements.push(2*i.y);
                layout_result.push(elements);
            }
        }
        //index = 5;
        return layout_result;
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