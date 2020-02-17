import haxe.macro.Expr.Error;
import entity.Entity.Character;

class MainPort extends hxd.App {
    static inline var MOVE_SPEED = 150;
    var main_character : Character;
    var layers : h2d.Layers;
    var entities : Array<Dynamic>;
    public var resManager : ResMgr;
    static inline var FIXED_WIDTH = 540; 
    static inline var FIXED_HEIGHT = 960; 

    var index = {
        background : 0,
        handbook : 1,
        slimes : 2,
        slimeAnims : 3
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
        initEntities();
    }

    function initEntities() {
        var res = resManager.res;
        var slimeSprite = res[index.slimes];

        var i = 0;
        while (i < 8) {
            var slime = new Character(slimeSprite.slice(i * 4, (i+1)*4)); // main chef
            slime.name = "slime";
            slime.x = FIXED_WIDTH / 2;
            slime.y = FIXED_HEIGHT / 2;
            var event = new DraggableEntity(64, 64, slime, s2d);
            layers.addChildAt(slime, ResMgr.LAYER_ENTITY); 
            entities.push(slime);
            i++;
        }
    }

    override function update(dt: Float) {
        for (entity in entities) {
            entity.update(dt);
        }
    }

    static function main() {
        hxd.Res.initEmbed();
        new MainPort();
    }
}

class DraggableEntity extends h2d.Interactive {
    var e : Dynamic;
    var s2d : h2d.Scene;
    var isFollow : Bool = false;
    public function new(width, height, entity, s2d) {
        super(width, height, entity);
        this.s2d = s2d;
        this.e = entity;
        this.onPush = function(event: hxd.Event) {
            entity.alpha = 0.8;
            entity.scale(6 / 5);
            var layer = entity.parent;
            layer.removeChild(entity);
            layer.addChildAt(entity, ResMgr.LAYER_UI);
            isFollow = true;
        }
        this.onRelease = function(event: hxd.Event) {
            isFollow = false;
            entity.alpha = 1; entity.scale(5 / 6);
            entity.x = s2d.mouseX - width * 5 / 12;
            entity.y = s2d.mouseY - height * 5 / 12;
            var layers: Dynamic = entity.parent;
            layers.addChildAt(entity, ResMgr.LAYER_ENTITY);
            layers.ysort(ResMgr.LAYER_ENTITY); // bug posible
        }
    }
    public function update(dt:Float) {
        if (isFollow) {
            this.parent.x = s2d.mouseX - width * 0.6;
            this.parent.y = s2d.mouseY - height * 0.6;
        }
    }
}