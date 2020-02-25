import h2d.filter.ColorMatrix;
import entity.Entity;
import entity.Item.Fruit;
import entity.Item.Plate;
import h2d.filter.Blur;
import haxe.macro.Expr.Error;
import entity.Entity.Character;

import entity.Facility;

class MainPort extends hxd.App {
    static inline var MOVE_SPEED = 150;
    var layers : h2d.Layers;
    var entities : Array<Dynamic>;
    var facilities : Array<Facility>;
    var menus: Array<Dynamic>;
    public static var hold : h2d.Object;
    public var resManager : ResMgr;
    public static var IS_MENU_OPEN : Bool;
    public static var IS_DRAGGING : Bool;
    static inline var FIXED_WIDTH = 270; 
    static inline var FIXED_HEIGHT = 480; 
    public static inline var SELECT_SCALE = (8/5);

    var index = {
        background : 0,
        handbook : 1,
        slimes : 2,
        slimeAnims : 3,
        fruits : 4,
        items : 5,
        cellar : 6,
        cupboard : 7
    }
    var animIndex = {
        blue:0, red:4, lemon:8, kiwi:12,
        pink:16, deepblue:20, orange:24, purple:28
    }
    var fruitIndex = ["apple", "orange", "lemon", "kiwi", "blueberry"];

    override function init() {
        entities = new Array<Dynamic>();
        facilities = new Array<Facility>();
        menus = [];
        resManager = new ResMgr("mobile");
        var res = resManager.res;
        if (res == null) 
            throw new Error("resourse load fail.", {min: 18, max: 19, file: "MainPort.hx"});
        // build scene
        layers = new h2d.Layers(s2d);
        layers.addChildAt(res[index.background], ResMgr.LAYER_STATIC);

        loaditems();
        initMenu();
        initEntities();
        initData();
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
    function  initData() {
        IS_DRAGGING = false;
    }

    function initMenu() {
        // cellar menu
        IS_MENU_OPEN = false;
        var menu = new h2d.Layers();
        menu.name = "cellar";
        menu.add(resManager.res[index.cellar], 0);
        var x = [120, 120, 66, 180, 152];
        var y = [150, 334, 198, 292, 219];

        for (f in fruitIndex) {
            var i = getFruitIndex(f);
            var fruit = new h2d.Interactive(40, 50, menu);
            fruit.x = x[i]; fruit.y = y[i];
            fruit.onPush = function (e: hxd.Event){
                onLeaveMenu(menu);
                var item = spawnFruit(f, "whole");
                item.onPush(e); 
            }
        }
        // bound menu button
        var cellar = findByNameInArray("entry", facilities);
        var button = new h2d.Interactive(94, 48, cellar);
        button.onClick = function (e:hxd.Event) {
            if (IS_MENU_OPEN) return;
            onOpenMenu(menu);
        }
        // cupboard case
        cupboardPut("plate", 5);
        cupboardPut("bowl", 5);
        cupboardPut("glass_down", 5);
        // dragging bubble menu
        var selector = new h2d.Object();
        selector.name = "selector"; menus.push(selector);
        var mixSelector = new h2d.Interactive(51, 54, selector);
        mixSelector.x = 213; mixSelector.y = 314;
        mixSelector.onRelease = function (e:hxd.Event) {
            var mix:Dynamic = findByNameInArray("mixer", facilities);
            mix.interact(hold);
            onLeaveMenu(selector);
        }
        var cutSelector = new h2d.Interactive(64, 60, selector);
        cutSelector.x = 199; cutSelector.y = 238;
        cutSelector.onRelease = function (e:hxd.Event) {
            var cut:Dynamic = findByNameInArray("cut", facilities);
            cut.interact(hold);
        }
        var cbSelector = new h2d.Interactive(46, 25, selector);
        cbSelector.x = 117; cbSelector.y = 404;
        cbSelector.onRelease = function (e:hxd.Event) {
            var cb:Dynamic = findByNameInArray("chopping_board", facilities);
            cb.interact(hold);
        }
    }
    function onOpenMenu(menu:h2d.Object) {
        var i= 0; var max = layers.numChildren;
        while (i < max) {
            layers.getChildAt(i).filter = new Blur(10, 0.9, 1, 0);
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
    function onOpenBubbles(e:entity.Entity, list:Array<Dynamic>) {
        var menu = new h2d.Object();
        menu.name = "bubble";
        menu.addChild(e); // index 0
        for (i in list) {
            var bubble = getBubble(i);
            var event:Dynamic = bubble.getObjectByName("interact");
            event.onPush = function (e:hxd.Event) {
                layers.addChildAt(menu.getChildAt(0), ResMgr.LAYER_ENTITY);
                onLeaveMenu(menu);
                var item = i;
                if ((item is Fruit)) {
                    item = spawnFruit(i.fruitType, i.part);
                } else if ((item is Plate)) {
                    item = spawnPlate(i.size);
                } 
                item.onPush(e);
            }
            menu.addChild(bubble);
        }
        onOpenMenu(menu);
        return menu;
    }
    function getBubble(e: entity.Item):h2d.Bitmap {
        var bubble = new h2d.Bitmap(hxd.Res.mui.toTile().sub(0,0,22,22));
        bubble.x = e.x; bubble.y = e.y;
        var bmp:Dynamic = e.getObjectByName("sprite").getChildAt(0);
        var w = bmp.tile.width; var h = bmp.tile.height;
        bmp.x = (22-w)/2; bmp.y = (22-h)/2;
        bubble.addChild(bmp);
        var event = new h2d.Interactive(22, 22, bubble);
        event.name = "interact";
        return bubble;
    }

    function findByNameInArray(n:String, a:Array<Dynamic>) {
        for (e in a) {
            if ((e is h2d.Object) && (e.name == n)) return e;
        }
        return null;
    }

    function spawnFruit(type: String, part: String) {
        var fruit = new entity.Item.Fruit(type, part); 
        var name = type;
        if (part != "whole") name = name + "_" + part;
        if (ResMgr.getIndex(name) == -1) return null;
        var sprite = new h2d.Bitmap(resManager.res[index.fruits][getFruitIndex(type)][ResMgr.getIndex(name)]);
        fruit.getObjectByName("sprite").addChild(sprite);
        entities.push(fruit);
        layers.addChild(fruit);
        return new DraggableEntity(sprite.tile.width, sprite.tile.height, fruit, s2d);
    }

    function spawnPlate(type: String) {
        var plate = new Plate(type);
        var bmp : Dynamic = findByNameInArray(type, resManager.res[index.items]);// 套娃
        var sprite = new h2d.Bitmap(bmp.tile);
        plate.getObjectByName("sprite").addChild(sprite);
        entities.push(plate);
        layers.addChild(plate);
        return new DraggableEntity(sprite.tile.width, sprite.tile.height, plate, s2d);
    }
    
    function getFruitIndex(type: String){
        return fruitIndex.indexOf(type);
    }

    static function setColor(c:Int, alpha:Float, obj:h2d.Object) {
        var matrix = new h3d.Matrix();
        matrix.colorSet(c, alpha);
        var shader = new h2d.filter.ColorMatrix(matrix);
        var sp = obj.getObjectByName("sprite");
        sp.filter = shader;
    }

    function loaditems(){
        var list: Array<Dynamic> = resManager.res[index.items];
        var facs: Array<Dynamic> = AssetManager.mlayoutData.scene;
        for (f in facs) {
            var fac = new Facility();
            fac.name = f.name;
            fac.x = f.x; fac.y = f.y;
            switch (f.name) {
                case "rectangle":
                    var list = [findByNameInArray("rectangle_up", list), 
                                findByNameInArray("rectangle_down", list)];
                    var sp = new h2d.Layers(fac); sp.name = "stacks";
                    var bowls = new h2d.Object(); bowls.name = "bowls";
                    bowls.x = 7; bowls.y = 45;
                    var plates = new h2d.Object(); plates.name = "plates";
                    plates.x = 22; plates.y = 57;
                    var cups = new h2d.Object(); cups.name = "cups";
                    cups.x = 45; cups.y = 63;
                    sp.add(list[1], 0);
                    sp.add(bowls, 1);
                    sp.add(plates, 1);
                    sp.add(cups, 1);
                    sp.add(list[0], 2);
                    fac.getObjectByName("sprite").addChild(sp);
                    var e = new h2d.Interactive(72, 80, fac);
                    e.onClick = function (e:hxd.Event) {
                        var i1 = new Plate("bowl"); i1.x = 164; i1.y = 160; i1.getObjectByName("sprite").addChild(findByNameInArray("bowl", resManager.res[index.items]));
                        var i2 = new Plate("dish_small"); i2.x = 175; i2.y = 191; i2.getObjectByName("sprite").addChild(findByNameInArray("dish_small", resManager.res[index.items]));
                        var i3 = new Plate("dish_large"); i3.x = 207; i3.y = 213; i3.getObjectByName("sprite").addChild(findByNameInArray("dish_large", resManager.res[index.items]));
                        var i4 = new Plate("glass"); i4.x = 240; i4.y = 221; i4.getObjectByName("sprite").addChild(findByNameInArray("glass", resManager.res[index.items]));
                        onOpenBubbles(fac, [i1,i2,i3,i4]);
                    }
                case "mixer":
                    var m : Dynamic = findByNameInArray("mixer_open", list);
                    var list = [findByNameInArray("mixer", list), 
                                m];
                    fac.sprites = list;
                    fac.state = 0;
                    fac.getObjectByName("sprite").addChild(list[1]);
                    fac.state_update = function (dt: Float) {
                        if (fac.isSpriteChanged)
                            fac.sprite = fac.sprites[fac.state];
                    }

                    fac.interact = function (e: Dynamic) {
                        var f: entity.Item.Fruit = e;
                        var outs = ["dicebowl", "mush", "juice"];
                        var x = [177, 202, 241];
                        var y = [315, 286, 281];
                        var items = [];
                        var k = 0;
                        for (n in outs) {
                            var event = spawnFruit(f.fruitType, n);
                            if (event != null) {
                                var i = event.parent;
                                i.x = x[k]; i.y=y[k];
                                k++;
                                items.push(i);
                            }
                        }
                        if (items.length <= 0) return;
                        hold.remove();
                        hold = null;
                        onOpenBubbles(fac, items);
                    }
                case "cut":
                    var m : Dynamic = findByNameInArray("cut_open", list);
                    var list = [m, 
                                findByNameInArray("cut_close", list)];
                    fac.sprites = list;
                    fac.state = 0;
                    fac.getObjectByName("sprite").addChild(list[0]);
                    fac.state_update = function (dt: Float) {
                        if (fac.isSpriteChanged)
                            fac.sprite = fac.sprites[fac.state];
                    }
                    var event = new h2d.Interactive(m.tile.width, m.tile.height, fac);
                    event.onRelease = function (event:hxd.Event) {
                        if (!IS_DRAGGING) return;
                        var i = layers.getLayer(ResMgr.LAYER_UI);
                        if (i.hasNext())
                            fac.interact(i.next);
                    }
                    fac.interact = function (e: Dynamic) {
                        var f: entity.Item.Fruit = e;
                        var outs = ["dicebowl", "slicegroup"];
                        var x = [169, 164, 180];
                        var y = [282, 246, 215];
                        var items = [];
                        var k = 0;
                        for (n in outs) {
                            var event = spawnFruit(f.fruitType, n);
                            if (event != null) {
                                var i = event.parent;
                                i.x = x[k]; i.y=y[k];
                                k++;
                                items.push(i);
                            }
                        }
                        if (items.length <= 0) return;
                        hold.remove();
                        hold = null;
                        onOpenBubbles(fac, items);
                    }
                case "chopping_board":
                    var knife = findByNameInArray("knife_flat", list);
                    knife.x = 15; knife.y = 1;
                    var m : Dynamic = findByNameInArray("chopping_board", list);
                    var list = [m, 
                                knife,
                                findByNameInArray("knife_stand", list)];
                    fac.sprites = list;
                    fac.state = 0;
                    fac.getObjectByName("sprite").addChild(list[0]);
                    fac.getObjectByName("sprite").addChild(list[1]);
                    var event = new h2d.Interactive(m.tile.width, m.tile.height, fac);
                    event.onRelease = function (event:hxd.Event) {
                        if (!IS_DRAGGING) return;
                        var i = layers.getLayer(ResMgr.LAYER_UI);
                        if (i.hasNext())
                            fac.interact(i.next);
                    }
                    fac.interact = function (e: Dynamic) {
                        var f: entity.Item.Fruit = e;
                        var outs = ["dice", "slice", "half"];
                        var x = [82, 123, 164];
                        var y = [368, 368, 368];
                        var items = [];
                        var k = 0;
                        for (n in outs) {
                            var event = spawnFruit(f.fruitType, n);
                            if (event != null) {
                                var i = event.parent;
                                i.x = x[k]; i.y=y[k];
                                k++;
                                items.push(i);
                            }
                        }
                        if (items.length <= 0) return;
                        hold.remove();
                        hold = null;
                        onOpenBubbles(fac, items);
                    }
                default:
                    var sprite = fac.getObjectByName("sprite");
                    var bmp = findByNameInArray(f.name, list);
                    sprite.addChild(bmp);
            }
            layers.add(fac, ResMgr.LAYER_STATIC);
            facilities.push(fac);
        }
    }


    function cupboardPut(type: String, n: Int) {
        var c = findByNameInArray("rectangle", facilities);
        var stacks:Dynamic = c.getObjectByName("sprite").getObjectByName("stacks");
        var s:h2d.Object = null;
        var pad = 0;
        switch (type) {
            case "plate" : pad = 2; s = stacks.getObjectByName("plates"); type = "dish_small";
            case "bowl" : pad = 3; s = stacks.getObjectByName("bowls");
            case "glass_down" : pad = 5; s = stacks.getObjectByName("cups");
        }
        if (s == null) return; // debug use
        var sp:Dynamic = findByNameInArray(type, resManager.res[index.items]);
        if (n > 6) n = 6;
        while (n > 0) {
            var p = new h2d.Bitmap(sp.tile);
            var num = s.numChildren;
            p.y = -(num + 1) * pad;
            s.addChild(p);
            n --;
        }
    }
    function cupboardTake(type:String):Bool {
        var c = findByNameInArray("rectangle", facilities);
        var stacks:Dynamic = c.getObjectByName("sprite").getObjectByName("stacks");
        var s:h2d.Object=null;
        switch (type) {
            case "dish_small" : s = stacks.getObjectByName("plates");
            case "dish_large" : s = stacks.getObjectByName("plates");
            case "bowl" : s = stacks.getObjectByName("bowls");
            case "glass_down" : s = stacks.getObjectByName("cups");
            default: return false;
        }
        if (s.numChildren <= 0) return false;
        s.removeChild(s.getChildAt(s.numChildren - 1));
        return true;
    }

    override function update(dt: Float) {
        if ((IS_DRAGGING)&& !(IS_MENU_OPEN)) {
            layers.add(findByNameInArray("selector", menus), ResMgr.LAYER_UI);
        } else if (!IS_DRAGGING) {
            layers.removeChild(findByNameInArray("selector", menus));
        }
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
        this.name = "drag";
        this.e = entity;
        this.onPush = function(event: hxd.Event) {
            if ((MainPort.IS_MENU_OPEN) || isFollow) return;
            entity.alpha = 0.8;
            entity.scale(MainPort.SELECT_SCALE);
            var layer = entity.parent;
            if ((layer != null) && (layer.getChildIndex(entity) != -1)) layer.removeChild(entity);
            layer.addChildAt(entity, ResMgr.LAYER_UI);
            isFollow = true; MainPort.IS_DRAGGING = true;
            MainPort.hold = entity;
        }
        this.onRelease = function(event: hxd.Event) {
            if (MainPort.IS_MENU_OPEN) return;
            isFollow = false; MainPort.IS_DRAGGING = false;
            MainPort.hold = null;
            entity.alpha = 1; entity.scale(1 / MainPort.SELECT_SCALE);
            entity.x = s2d.mouseX - width * 0.5;
            entity.y = s2d.mouseY - height * 0.5;
            var layers: Dynamic = entity.parent;
            layers.addChildAt(entity, ResMgr.LAYER_ENTITY);
            layers.ysort(ResMgr.LAYER_ENTITY); // bug posible
        }
    }
    public function update(dt:Float) {
        if (isFollow) {
            this.parent.x = s2d.mouseX - width * MainPort.SELECT_SCALE * 0.5;
            this.parent.y = s2d.mouseY - height * MainPort.SELECT_SCALE * 0.5;
        }
    }
}