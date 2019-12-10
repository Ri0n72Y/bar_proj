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

    var ctrls : Array<Controller>;
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

        ctrls = [controller];
        layers.add(player, LAYER_ENTITY);
        
        player.x = Std.int(s2d.width  / 2);
        player.y = Std.int(s2d.height / 2);

        //var ptiles = hxd.Res.charaAnim.toTile().split();
        tiles = hxd.Res.charaAnim.toTile();
        var f = loadTileToSize(tiles, 0, 0, FSIZE, FSIZE, 80, 80);
        var l = loadTileToSize(tiles, 0, FSIZE, FSIZE, FSIZE, 80, 80);
        var b = loadTileToSize(tiles, 0, FSIZE * 2, FSIZE, FSIZE, 80, 80);
        var r = loadTileToSize(tiles, 0, FSIZE * 3, FSIZE, FSIZE, 80, 80);

        player.getObjectByName("sprite").addChild(f);

        ptiles = [f,l,b,r];

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
    
    function key_checkMove(chara : Player, direction : h3d.Vector, key : Int) : h3d.Vector{
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
        
        var sprite = chara.getObjectByName("sprite");
        sprite.removeChildren();
        sprite.addChild(chara.sprite);

        return direction;
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
        var key = ctrls[0].isKeyPressed();
        if (key != -1) {
            ctrls[0].direction = key_checkMove(player, ctrls[0].direction, key);
            ctrls[0].move(P_MOVESPEED, dt);
        } else {
        }
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}

