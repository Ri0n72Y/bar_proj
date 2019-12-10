import Item.Fruit;
import h2d.Object;

// Base of All sprited object in the game
class Entity extends Object{
    public var sprite : h2d.Bitmap;
    var INTERACT_DISTANCE = 100;
    var DROP_DISTANCE = 60;
    public var holds : Object;
    public function new() {
        super();
        // add sprite container
        var s = new Object(this);
        s.name = "sprite";

        // add holding container
        var s = new Object(this);
        s.name = "holds";
    }
}

enum Tool {
    Hammer; Axe; Pickaxe; Sickle; // 镰刀
    Hoe; None;
}

// TODO : add All given entities to class

class Character extends Entity {
    public var triggers : Array<Object>;
    public var controller : Controller;
    
    public function new() {
        super();
    }
}

enum State {
    Holding; Idle;
}

class Player extends Character {
    public var state : State;
    public var layer : h2d.Layers;
    public var layerNum : Int;

    var toolInventory : Array<Tool>;
    var currentTool : Tool;

    var OFFSET_HOLD_X = 0;
    var OFFSET_HOLD_Y = -50;
    
    public function new() {
        super();
        this.state = Idle;
    }

    public function interact(list : Iterator<Object>) {
        if (state == Idle) {
            while (list.hasNext()) {
                var item = list.next();
                if ((item is Fruit) && (isInteractable(item))) {
                    this.holds = item;
                    item.x = OFFSET_HOLD_X; item.y = OFFSET_HOLD_Y;
                    this.getObjectByName("holds").addChild(item);
                    state = Holding;
                    break; // TODO : this method only take the first-found item in the distance, modify to make it better
                }
            }
        } else if (state == Holding) {
            var item = this.holds;
            item.x = this.x + DROP_DISTANCE * this.controller.direction.x;
            item.y = this.y + DROP_DISTANCE * this.controller.direction.y;
            this.layer.add(item, layerNum);

            this.holds = null;
            state = Idle;
        }
    }

    function isInteractable(item : Object) : Bool {
        return (Math.sqrt(Math.pow(item.x - this.x, 2) + Math.pow(item.y - this.y, 2)) <= INTERACT_DISTANCE);
    }
}
