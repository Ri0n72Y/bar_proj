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
        var slime = new Character(res[index.slimes]); // main chef
        slime.x = FIXED_WIDTH / 2;
        slime.y = FIXED_HEIGHT / 2;
        layers.addChildAt(slime, ResMgr.LAYER_ENTITY); 
        entities.push(slime);
    }

    override function update(dt: Float) {
        for (entitiy in entities) {
            entitiy.update(dt);
        }
    }

    static function main() {
        hxd.Res.initEmbed();
        new MainPort();
    }
}

class DraggableEntity extends h2d.Interactive {
    var entity : Dynamic;
    public function new(width, height, entity, ?shape) {
        super(width, height, entity, shape);
        this.entity = entity;
        this.onPush = function(event: hxd.Event) {
            entity.alpha = 0.8;
            entity.scale(1.5);
            entity.parent.addChildAt(entity, ResMgr.LAYER_UI);
            this.startDrag(function(event) {
                this.entity.x = event.relX - (width  / 2);
                this.entity.y = event.relY - (height / 2);
            });
        }
        this.onRelease = function(event: hxd.Event) {
            this.stopDrag();
            entity.alpha = 1; entity.scale(1);
            var layers: Dynamic = entity.parent;
            layers.addChildAt(entity, ResMgr.LAYER_ENTITY);
            layers.ysort(ResMgr.LAYER_ENTITY); // bug posible
        }
    }

    public function update(dt:Float) {
        entity.update(dt);
    }
}