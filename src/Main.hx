import Item;
import KeySetting as Keys;
import Entity;
import Controller;
import ResMgr.LAYER_ENTITY;
import ResMgr.TILE_SIZE;
import ResMgr.SCALED_SIZE;
import ResMgr.loadTileToSize;

class Main extends hxd.App {

    static inline var P_MOVESPEED = 160; // 移动速度

    var player : Player;
    var layers : h2d.Layers;
    var ptiles : Array<h2d.Bitmap>;
    var resMgr : ResMgr;

    // change character texture, return the direction of move
    // TODO: Refactor for Joystick input

    override function init() {
        layers = new h2d.Layers(s2d); // 初始化世界层
        resMgr = new ResMgr(layers);

        // TODO: 将object对象的导入整合到以 scene 的 json 来导入
        player = new Player(); // add sample entity player
        player.name = "player";
        var controller = new Controller(); // initialize controller for player
        controller.setControl(player); // set controller

        layers.add(player, LAYER_ENTITY); 
        player.layer = layers; // add double-link
        player.layerNum = LAYER_ENTITY;
        
        player.x = Std.int(s2d.width  / 3); // set initial position
        player.y = Std.int(s2d.height / 2);

        var f = new h2d.Bitmap(loadTileToSize(resMgr.tiles, 0, 0, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, 1));
        var l = new h2d.Bitmap(loadTileToSize(resMgr.tiles, 0, TILE_SIZE, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, 1));
        var b = new h2d.Bitmap(loadTileToSize(resMgr.tiles, 0, TILE_SIZE * 2, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, 1));
        var r = new h2d.Bitmap(loadTileToSize(resMgr.tiles, 0, TILE_SIZE * 3, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, 1));

        player.getObjectByName("sprite").addChild(f); // 添加初始图像

        ptiles = [f,l,b,r]; // 可能会挂到player对象里面

        var item = new Fruit(WF); // 添加示例物品对象
        item.sprite = new h2d.Bitmap(loadTileToSize(resMgr.tiles, 0, TILE_SIZE * 4, TILE_SIZE, TILE_SIZE, SCALED_SIZE, SCALED_SIZE, 1));
        item.getObjectByName("sprite").addChild(item.sprite);
        item.x = Std.int(s2d.width  / 1.5);
        item.y = Std.int(s2d.height / 2);
        layers.add(item, LAYER_ENTITY);

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
            chara.sprite = ptiles[2];
            direction.x = 0;
            direction.y = -1.0;
        } else if (key == Keys.MOVE_VERTICAL_INC) {
            chara.sprite = ptiles[0];
            direction.x = 0;
            direction.y = 1.0;
        } else if (key == Keys.MOVE_HORISONTAL_DEC) {
            chara.sprite = ptiles[1];
            direction.x = -1.0;
            direction.y = 0;
        } else if (key == Keys.MOVE_HORISONTAL_INC) {
            chara.sprite = ptiles[3];
            direction.x = 1.0;
            direction.y = 0;
        } else {
            return;
        }
        
        chara.controller.move(P_MOVESPEED, dt);
        // TODO : 优化：使其无需每次都删除-添加子对象
        var sprite = chara.getObjectByName("sprite");
        sprite.removeChildren();
        sprite.addChild(chara.sprite);
    }

    function onEvent(event : hxd.Event) {
        // player texture switch
        switch (event.kind) {
            case EKeyDown: {
                if (event.keyCode == Keys.ACTION_INTERACT) {
                    player.interact(layers.getLayer(LAYER_ENTITY));
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
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}

