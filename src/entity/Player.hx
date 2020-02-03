package entity;

import h2d.Bitmap;
import entity.Entity.Character;

class Player extends Character {
    var toolInventory : Array<Tool>;

    var OFFSET_HOLD_X = 0;
    var OFFSET_HOLD_Y = -50;
    
    public function new(sprites:Array<Bitmap>) {
        super(sprites);
        this.state = Idle;
        this.name = "player";
    }

    public override function update(dt: Float) {
        super.update(dt);
    }

    /**
     * 让该角色和传入的其他对象互动
     * @param list 对象的list
     */
    public function interact(list : Array<Dynamic>) {
        var items = list.filter(isInDistanceInteractive); // all items in area
        if (state == Idle) {
            actionIdle(items);
        } else if ((state == Holding) && (items.length == 0)) { // throw out 
            var item = this.holds;
            item.x = this.x + DROP_DISTANCE * this.controller.direction.x;
            item.y = this.y + DROP_DISTANCE * this.controller.direction.y;
            this.layer.add(item, layerNum);
            this.holds = null;
            state = Idle;
        } else if ((state == Holding)) {
            var holds : Dynamic = this.getObjectByName("holds");
            if ((holds is Tool)) {
                actionHoldingTool(items, holds);
            } else {
                for (item in items) {
                    if ((item is Facility)){ // put holding food items to facility
                        item.interact(this);
                    }
                    break;
                }
            }
        }
    }

    function actionIdle(items : Array<Dynamic>) {
        for (item in items) {
            if ((item is Entity) && (item.isCarrible(this))) {
                this.holds = item;
                item.x = OFFSET_HOLD_X; item.y = OFFSET_HOLD_Y;
                this.getObjectByName("holds").addChild(item);
                state = Holding;
                break; // TODO: this method only take the first-found item in the distance, modify to make it better
            }
        }
    }

    function actionHoldingTool(items : Array<Dynamic>, tool : Tool) {
        switch (tool.toolType) {
            case Rake:
                return;
            case Pickaxe:
                return;
            case Sickle:
                return;
            default:
                return;
        }
    }

    function isInDistanceInteractive(item : h2d.Object) : Bool {
        return (item.name != "player" && Math.sqrt(Math.pow(item.x - this.x, 2) + Math.pow(item.y - this.y, 2)) <= INTERACT_DISTANCE);
    }
}
