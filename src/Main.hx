import h2d.Bitmap;
import entity.Facility.PlantSoil;
import entity.Item;
import KeySetting as Keys;
import entity.Entity;
import Controller;
import ResMgr.LAYER_ENTITY;
import ResMgr.LAYER_STATIC;
import ResMgr.LAYERS;
import ResMgr.SCALED_SIZE;
import ResMgr.SCALE;
import ResMgr.loadTileToSize;
import entity.Misc;
import AssetManager.getAssetSize;

class Main extends hxd.App {

    static inline var P_MOVESPEED = 320; // 移动速度

    var player : Player;
    var layers : h2d.Layers;
    var entities : Array<Dynamic>; // reference to find interactivable object
    public var resMgr : ResMgr;

    // TODO: Refactor for Joystick input

    override function init() {
        entities = new Array<Dynamic>();
        resMgr = new ResMgr();
        layers = new h2d.Layers(s2d); // 初始化世界层
        layers.add(resMgr.map, LAYER_STATIC);

        // TODO: 将object对象的导入整合到以 scene 的 json 导入

        var asset = getAssetSize("slime_front");
        var f = new h2d.Bitmap(loadTileToSize(resMgr.tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "centre"));
        var asset = getAssetSize("slime_left");
        var l = new h2d.Bitmap(loadTileToSize(resMgr.tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "centre"));
        var asset = getAssetSize("slime_back");
        var b = new h2d.Bitmap(loadTileToSize(resMgr.tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "centre"));
        var asset = getAssetSize("slime_right");
        var r = new h2d.Bitmap(loadTileToSize(resMgr.tiles, asset.x, asset.y, asset.w, asset.h, SCALED_SIZE, SCALED_SIZE, "centre"));

        player = new Player([f,l,b,r]); // add sample entity player
        player.getObjectByName("sprite").addChild(f); // 添加初始图像

        var controller = new Controller(); // initialize controller for player
        controller.setControl(player); // set controller

        layers.add(player, LAYER_ENTITY); 
        entities.push(player);

        player.layer = layers; // add double-link
        player.layerNum = LAYER_ENTITY;
        
        player.x = Std.int(s2d.width  / 3); // set initial position
        player.y = Std.int(s2d.height / 2);

        player.camera = new Camera(player, s2d.width, s2d.height);

        var item = new Seed(0, WF); // 添加示例物品对象
        var asset = getAssetSize("waterfruit");
        item.sprite = new h2d.Bitmap(loadTileToSize(resMgr.tiles, asset.x, asset.y, asset.w, asset.h, asset.w * SCALE, asset.h * SCALE, "centre"));
        item.getObjectByName("sprite").addChild(item.sprite);
        item.x = Std.int(s2d.width  / 1.5);
        item.y = Std.int(s2d.height / 2);
        layers.add(item, LAYER_ENTITY);
        entities.push(item);

        var soil = new PlantSoil(new Bitmap(resMgr.fac_plantsoil));
        soil.x = Std.int(s2d.width / 2);
        soil.y = Std.int(s2d.height / 1.5);
        layers.add(soil, LAYER_ENTITY);
        entities.push(soil);

        //set event listener to window
        hxd.Window.getInstance().addEventTarget(onEvent);
    }

    override function onResize() {
        if (player == null) return;
    }
    
    /**
     * 检查移动行为，依赖于全局变量 ptiles  // TODO : 解除依赖
     * @param chara 被移动的角色
     * @param direction 方向向量
     * @param key 按下的键代码
     * @param dt deltatime
     */
    function key_checkMove(chara : Character, direction : h3d.Vector, key : Int, dt : Float){
        if (key == Keys.MOVE_VERTICAL_DEC) {
            chara.sprite = chara.sprites[2];
            chara.isSpriteChanged = true;
            direction.x = 0;
            direction.y = -1.0;
        } else if (key == Keys.MOVE_VERTICAL_INC) {
            chara.sprite = chara.sprites[0];
            chara.isSpriteChanged = true;
            direction.x = 0;
            direction.y = 1.0;
        } else if (key == Keys.MOVE_HORISONTAL_DEC) {
            chara.sprite = chara.sprites[1];
            chara.isSpriteChanged = true;
            direction.x = -1.0;
            direction.y = 0;
        } else if (key == Keys.MOVE_HORISONTAL_INC) {
            chara.sprite = chara.sprites[3];
            chara.isSpriteChanged = true;
            direction.x = 1.0;
            direction.y = 0;
        } else {
            return;
        }
        
        chara.controller.move(P_MOVESPEED, dt);
    }

    function onEvent(event : hxd.Event) {
        // player texture switch
        switch (event.kind) {
            case EKeyDown: {
                if (event.keyCode == Keys.ACTION_INTERACT) {
                    player.interact(entities);
                }
            }
            case EKeyUp: {}
            case _ : {}
        }
    }

    override function update(dt:Float) {
        var key = player.controller.isKeyPressed();
        if (key != -1) {
            key_checkMove(player, player.controller.direction, key, dt);
        } else {
        }
        for (i in LAYERS) {
            player.camera.update(layers.getLayer(i));
        }
        player.update(dt);
        for (item in entities) {
            item.update(dt);
        }
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}

