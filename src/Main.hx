import KeySetting as Keys;
import Entities;
import Controller;

enum Dirc {
    FW; //前
    BW; //后
    LF; //左
    RH; //右
    DIR(x : Float, y : Float);
}

class Main extends hxd.App {

    static var FSIZE = 32;
    static var LAYER_STATIC = 0;
    static var LAYER_COLLIS = 2;
    static var LAYER_ENTITY = 3;
    static var LAYER_UI = 5;

    static inline var P_MOVESPEED = 60;

    var controllers : Array<Controller>;
    var player : Player;
    var layers : h2d.Layers;
    var tiles : h2d.Tile;
    var ptiles : Array<h2d.Bitmap>;

    // change character texture, return the direction of move
    // TODO: Refactor for Joystick input


    override function init() {
        layers = new h2d.Layers(s2d);

        // game objects
        player = new Player();
        player.name = "player";
        var controller = new Controller();
        controller.setControl(player);

        controllers = [controller];
        layers.add(player, LAYER_ENTITY);
        
        player.x = Std.int(s2d.width  / 2);
        player.y = Std.int(s2d.height / 2);

        //var ptiles = hxd.Res.charaAnim.toTile().split();
        tiles = hxd.Res.charaAnim.toTile();
        var p_front = tiles.sub(0, 0, FSIZE, FSIZE).center();
        var p_left  = tiles.sub(0, FSIZE, FSIZE, FSIZE).center();
        var p_back  = tiles.sub(0, FSIZE * 2, FSIZE, FSIZE).center();
        var p_right = tiles.sub(0, FSIZE * 3, FSIZE, FSIZE).center();

        var f = new h2d.Bitmap(p_front);
        var l = new h2d.Bitmap(p_left);
        var b = new h2d.Bitmap(p_back);
        var r = new h2d.Bitmap(p_right);

        player.sprite = f;

        ptiles = [f,l,b,r];

        //set event listener to window
        hxd.Window.getInstance().addEventTarget(onEvent);
    }

    override function onResize() {
        if (player == null) return;
    }
    
    function key_checkMove(chara : Player, key : Int) : h3d.Vector{
        var direction = new h3d.Vector();
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
        }

        return direction;
    }

    function onEvent(event : hxd.Event) {
        // player texture switch
        switch (event.kind) {
            case EKeyDown: {
                controllers[0].direction = key_checkMove(player, event.keyCode);
                var sprite = player.getObjectByName("sprite");
                sprite.removeChildren();
                sprite.addChild(player.sprite);
            }
            case EKeyUp: {
            }
            case EPush: {}
            case ERelease: {}
            case EMove: {}
            case EOver: {}
            case EOut: {}
            case EWheel: {}
            case EFocus: {}
            case EFocusLost: {}
            case EReleaseOutside: {}
            case ETextInput: {}
            case ECheck: {}
        }
    }

    override function update(dt:Float) {
        controllers[0].move(P_MOVESPEED, dt);
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}

