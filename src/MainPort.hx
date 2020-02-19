import haxe.macro.Expr.Error;
import entity.Entity.Character;

import AssetManager.getAssetSize;
import ResMgr.loadTileToSize;
import entity.Facility;

class MainPort extends hxd.App {
    static inline var MOVE_SPEED = 150;
    var main_character : Character;
    var layers : h2d.Layers;
    var entities : Array<Dynamic>;
    var menus : Array<Dynamic>;
    public var resManager : ResMgr;
    static inline var FIXED_WIDTH = 540; 
    static inline var FIXED_HEIGHT = 960; 

    var index = {
        background : 0,
        handbook : 1,
        slimes : 2,
        slimeAnims : 3,
        fruits : 4,
        items : 5,
        cellar : 6
    }
    var animIndex = {
        blue:0, red:4, lemon:8, kiwi:12,
        pink:16, deepblue:20, orange:24, purple:28
    }
    var fruitIndex = ["apple", "orange", "lemon", "kiwi", "blueberry"];

    override function init() {
        entities = new Array<Dynamic>();
        resManager = new ResMgr("mobile");
        var res = resManager.res;
        if (res == null) 
            throw new Error("resourse load fail.", {min: 18, max: 19, file: "MainPort.hx"});
        // build scene
        layers = new h2d.Layers(s2d);
        layers.addChildAt(res[index.background], ResMgr.LAYER_STATIC);

        loaditems();

        initEntities();
    }

    function initEntities() {
        // slimes
        var res = resManager.res;
        var slimeSprite = res[index.slimes];

        var i = 0;
        while (i < 8) {
            var slime = new Character(slimeSprite.slice(i * 4, (i+1)*4)); // main chef
            slime.name = "slime";
            slime.x = FIXED_WIDTH / 2;
            slime.y = FIXED_HEIGHT / 2;
            new DraggableEntity(64, 64, slime, s2d);
            layers.addChildAt(slime, ResMgr.LAYER_ENTITY); 
            entities.push(slime);
            i++;
        }

        // cellar entry

    }

    function onLoadMenu() {
        var menu = new h2d.Layers();
        menu.add(resManager.res[index.cellar], 0);

        var x = [120, 120, 66, 180, 152];

        var fruit = new h2d.Interactive(40, 50, menu);
        fruit.x = 120; fruit.y = 150;
        fruit.onPush = function (e: hxd.Event){
            var fruit = spawnFruit("apple");
            fruit.onPush(e);
        }
    }
    function onOpenMenu() {

    }
    function onLeaveMenu() {

    }

    function spawnFruit(type: String) {
        var fruit = new entity.Item.Fruit(type);
        var sprite = resManager.res[index.fruits][getFruitIndex(type)][0];
        fruit.getObjectByName("sprite").addChild(sprite);
        return new DraggableEntity(32, 32, fruit, s2d);
    }
    
    function getFruitIndex(type: String){
        return fruitIndex.indexOf(type);
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

    function loaditems(){

        var list: Array<Dynamic> = [];
        list = resManager.res[5];
        
        for (i in list) {

            var name = i[0];

            switch (name) {
              default:
                var item = new Facility();
                item.getObjectByName("sprite").addChild(i[1]);
                item.x = i[2];
                item.y = i[3];
                layers.addChildAt(item,ResMgr.LAYER_ENTITY);
            }
        } 
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