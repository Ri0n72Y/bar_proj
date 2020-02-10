import haxe.macro.Expr.Error;
import entity.Entity.Character;

class MainPort extends hxd.App {
    static inline var MOVE_SPEED = 150;
    var main_character : Character;
    var layers : h2d.Layers;
    var entities : Array<Dynamic>;
    public var resManager : ResMgr;

    var index = {
        background : 0,
        handbook : 1,
        slimes : 2
    }
    var animIndex = {
        blue:0, red:4, lemon:8, kiwi:12,
        pink:16, deepblue:20, orange:24, purple:28
    }

    override function init() {
        entities = new Array<Dynamic>();
        resManager = new ResMgr("mobile");
        var res = resManager.res;
        if (res == null) 
            throw new Error("resourse load fail.", {min: 18, max: 19, file: "MainPort.hx"});
        // build scene
        layers = new h2d.Layers(s2d);
        layers.addChildAt(res[index.background], ResMgr.LAYER_STATIC);
    }

    static function main() {
        hxd.Res.initEmbed();
        new MainPort();
    }k
}