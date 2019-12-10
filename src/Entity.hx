import h2d.Object;

// Base of All sprited object in the game
class Entity extends Object{
    public var sprite : h2d.Bitmap;
    public function new() {
        super();
        // add sprite object
        var s = new Object(this);
        s.name = "sprite";
        this.addChild(s);
    }
}

enum State {
    Idle; Working;
}

enum Tool {
    Hammer; Axe; Pickaxe; Sickle; // 镰刀
    Hoe; None;
}

// TODO : add All given entities to class

class Character extends Entity {
    public var triggers : Array<Object>;
    
    public function new() {
        super();
    }
}

class Player extends Character {
    public var state : State;
    private var toolInventory : Array<Tool>;
    private var currentTool : Tool;
    private var carry : Item;
    
    public function new() {
        super();
    }

    public function interact(list : Iterator<Object>) {
        while (list.hasNext()) {
            var item = list.next();
            if (item.name != "player") {

            }
        }
    }

    function isInteractable(item : Object) {
        
    }
}
