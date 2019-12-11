import Item;
import h2d.Tile;
import KeySetting as Keys;
import Entity;
import Controller;

class Main extends hxd.App {

    static var FSIZE = 32;
    static var LAYER_STATIC = 0;
    static var LAYER_COLLIS = 2;
    static var LAYER_ENTITY = 3;
    static var LAYER_UI = 5;

    static inline var P_MOVESPEED = 160;

    var player : Player;
    var layers : h2d.Layers;
    var tiles : h2d.Tile;
    var ptiles : Array<h2d.Bitmap>;

    // change character texture, return the direction of move
    // TODO: Refactor for Joystick input

    override function init() {
        layers = new h2d.Layers(s2d); // 初始化世界层

        // TODO: 将object对象的导入整合到以 scene 的 json 来导入
        player = new Player(); // add sample entity player
        player.name = "player";
        var controller = new Controller(); // initialize controller for player
        controller.setControl(player);

        layers.add(player, LAYER_ENTITY);
        player.layer = layers;
        player.layerNum = LAYER_ENTITY;
        
        player.x = Std.int(s2d.width  / 3);
        player.y = Std.int(s2d.height / 2);


        //var ptiles = hxd.Res.charaAnim.toTile().split();
        tiles = hxd.Res.charaAnim.toTile();
        var f = loadTileToSize(tiles, 0, 0, FSIZE, FSIZE, 80, 80);
        var l = loadTileToSize(tiles, 0, FSIZE, FSIZE, FSIZE, 80, 80);
        var b = loadTileToSize(tiles, 0, FSIZE * 2, FSIZE, FSIZE, 80, 80);
        var r = loadTileToSize(tiles, 0, FSIZE * 3, FSIZE, FSIZE, 80, 80);

        player.getObjectByName("sprite").addChild(f);

        ptiles = [f,l,b,r];

        var item = new Fruit(WF);
        item.sprite = loadTileToSize(tiles, 0, FSIZE * 4, FSIZE, FSIZE, 80, 80);
        item.getObjectByName("sprite").addChild(item.sprite);
        item.x = Std.int(s2d.width  / 1.5);
        item.y = Std.int(s2d.height / 2);
        layers.add(item, LAYER_ENTITY);

        //set event listener to window
        hxd.Window.getInstance().addEventTarget(onEvent);
    }

    function loadTileToSize(tiles : Tile, x:Float, y:Float, w:Float, h:Float, scaleX:Float, scaleY:Float) : h2d.Bitmap {
        var tile = tiles.sub(x, y, w, h, -(scaleX * .5), -(scaleY * .5));
        tile.scaleToSize(scaleX, scaleY);
        return new h2d.Bitmap(tile);
    }

    override function onResize() {
        if (player == null) return;
    }
    
    function key_checkMove(chara : Player, direction : h3d.Vector, key : Int, dt : Float){
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

