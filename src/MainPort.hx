import h2d.filter.Blur;
import haxe.macro.Expr.Error;
import entity.Entity.Character;

import entity.Facility;

class MainPort extends hxd.App {
    static inline var MOVE_SPEED = 150;
    var layers : h2d.Layers;
    var entities : Array<Dynamic>;
    var facilities : Array<Facility>;
    public var resManager : ResMgr;
    public static var IS_MENU_OPEN : Bool;
    static inline var FIXED_WIDTH = 270; 
    static inline var FIXED_HEIGHT = 480; 

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
        facilities = new Array<Facility>();
        resManager = new ResMgr("mobile");
        var res = resManager.res;
        if (res == null) 
            throw new Error("resourse load fail.", {min: 18, max: 19, file: "MainPort.hx"});
        // build scene
        layers = new h2d.Layers(s2d);
        layers.addChildAt(res[index.background], ResMgr.LAYER_STATIC);

        loaditems();
        initMenu();
        initFacilities();
        initEntities();
        s2d.scale(2);
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
            new DraggableEntity(32, 32, slime, s2d);
            layers.addChildAt(slime, ResMgr.LAYER_ENTITY); 
            entities.push(slime);
            i++;
        }
    }
    function  initFacilities() {
        // cupboard
        // mixer
        var mixer = findByNameInArray("mixer", facilities);
        // cut
        // chopping_board
    }

    function initMenu() {
        // cellar menu
        IS_MENU_OPEN = false;
        var menu = new h2d.Layers();
        menu.add(resManager.res[index.cellar], 0);
        var x = [120, 120, 66, 180, 152];
        var y = [150, 334, 198, 292, 219];

        for (f in fruitIndex) {
            var i = getFruitIndex(f);
            var fruit = new h2d.Interactive(40, 50, menu);
            fruit.x = x[i]; fruit.y = y[i];
            fruit.onPush = function (e: hxd.Event){
                onLeaveMenu(menu);
                var item = spawnFruit(f);
                item.onPush(e);
            }
        }
        // bound menu button
        var cellar = findByNameInArray("entry", facilities);
        var button = new h2d.Interactive(94, 48, cellar);
        button.onPush = function (e:hxd.Event) {
            if (IS_MENU_OPEN) return;
            onOpenMenu(menu);
        }
    }
    function onOpenMenu(menu:h2d.Object) {
        var i= 0; var max = layers.numChildren;
        while (i < max) {
            layers.getChildAt(i).filter = new Blur(10, 0.8, 1, 0);
            i++;
        }
        IS_MENU_OPEN = true;
        layers.addChildAt(menu, ResMgr.LAYER_UI);
    }
    function onLeaveMenu(menu:h2d.Object) {
        layers.removeChild(menu);
        IS_MENU_OPEN = false;
        var i= 0; var max = layers.numChildren;
        while (i < max) {
            layers.getChildAt(i).filter = null;
            i++;
        }
    }

    function findByNameInArray(n:String, a:Array<Dynamic>) {
        for (e in a) {
            if ((e is h2d.Object) && (e.name == n)) return e;
        }
        return null;
    }

    function spawnFruit(type: String) {
        var fruit = new entity.Item.Fruit(type);
        var sprite = new h2d.Bitmap(resManager.res[index.fruits][getFruitIndex(type)][0]);
        fruit.getObjectByName("sprite").addChild(sprite);
        layers.addChild(fruit);
        entities.push(fruit);
        return new DraggableEntity(16, 16, fruit, s2d);
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
        var list: Array<Dynamic> = resManager.res[index.items];
        var facs: Array<Dynamic> = AssetManager.mlayoutData.scene;
        for (f in facs) {
            trace(f);
            var fac = new Facility();
            fac.name = f;
            fac.x = f.x; fac.y = f.y;
            switch (f.name) {
                case "rectangle":
                    var list = [findByNameInArray("rectangle_up", list), 
                                findByNameInArray("rectangle_down", list)];
                    var sp = new h2d.Layers(fac);
                    sp.add(list[0], 2); sp.add(list[1], 0);
                    fac.getObjectByName("sprite").addChild(sp);
                case "mixer":
                    var list = [findByNameInArray("mixer", list), 
                                findByNameInArray("mixer_open", list)];
                    fac.sprites = list;
                    fac.state = 0;
                    fac.getObjectByName("sprite").addChild(list[0]);
                case "cut":
                    var list = [findByNameInArray("cut_open", list), 
                                findByNameInArray("cut_close", list)];
                    fac.sprites = list;
                    fac.state = 0;
                    fac.getObjectByName("sprite").addChild(list[0]);
                case "chopping_board":
                    var list = [findByNameInArray("chopping_board", list), 
                                findByNameInArray("knife_flat", list),
                                findByNameInArray("knife_stand", list)];
                    fac.sprites = list;
                    fac.state = 0;
                    fac.getObjectByName("sprite").addChild(list[0]);
                default:
                    var sprite = fac.getObjectByName("sprite");
                    var bmp = findByNameInArray(f.name, list);
                    sprite.addChild(bmp);
            }
            layers.add(fac, ResMgr.LAYER_STATIC);
            facilities.push(fac);
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
            if (MainPort.IS_MENU_OPEN) return;
            entity.alpha = 0.8;
            entity.scale(6 / 5);
            var layer = entity.parent;
            if ((layer != null) && (layer.getChildIndex(entity) != -1)) layer.removeChild(entity);
            layer.addChildAt(entity, ResMgr.LAYER_UI);
            isFollow = true;
        }
        this.onRelease = function(event: hxd.Event) {
            if (MainPort.IS_MENU_OPEN) return;
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