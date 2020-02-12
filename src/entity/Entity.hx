package entity;

import h2d.Bitmap;
import h2d.Object;

// Base of All sprited object in the game
class Entity extends Object{
    public var sprite : h2d.Bitmap;
    public var isSpriteChanged : Bool;
    var INTERACT_DISTANCE = 100;
    var DROP_DISTANCE = 80;
    public var holds : Object;
    public function new() {
        super();
        // add sprite container
        var s = new Object(this);
        s.name = "sprite";
        isSpriteChanged = false;

        // add holding container
        var s = new Object(this);
        s.name = "holds";
    }

    function update(dt: Float) : Void{
        // detect any sprite change
        if (isSpriteChanged) {
            var s = this.getObjectByName("sprite");
            s.removeChildren();
            s.addChild(this.sprite);
            isSpriteChanged = false;
        }
    }

    public function isCarrible(entity: Entity): Bool {
        return false;
    }
}

enum State {
    Holding; Idle; Full;
}

// TODO : add All given entities to class

class Character extends Entity {
    public var triggers : Array<Object>;
    public var controller : Controller;
    public var camera : Misc.Camera;
    
    public var sprites : Array<Bitmap>;

    public var state : State;
    public var layer : h2d.Layers;
    public var layerNum : Int;

    /**
     * New character object
     * @param sprites All sprites the object use
     */
    public function new(sprites:Array<Bitmap>) {
        super();
        this.sprites = sprites;
        isSpriteChanged = true;
    }

    public override function update(dt: Float) {
        super.update(dt);
    }
}

