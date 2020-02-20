package entity;

import entity.Entity.Character;
import entity.Plant.Plant_Waterfruit;
import entity.Item.FruitType;
import entity.Item.ItemType;

class Facility extends Entity {
    var id : String;
    var description : String;
    var state : Int;
    var counter : Int;
    var sprites : Dynamic;

    public function interact(entity:Dynamic) {
    }

    override function update(dt:Float) {
        super.update(dt);
    }
}

class PlantSoil extends Facility {
    // var state : Int; //0:clean, 1:has plants, 2:has dead plants, 3:rough
    var plant : Plant;
    var interactions : String; // place holder
    public function new(sprite: h2d.Bitmap) {
        super();
        this.sprite = sprite;
        this.isSpriteChanged = true;
    }

    function put(plant: Dynamic) : Bool{
        if ((plant == null) || !(plant is Item.Seed)) return false; // debug
        switch (plant.type) {
            case ItemType.Seed:
                switch (plant.fruitType) {
                    case FruitType.WF:
                        this.plant = new Plant_Waterfruit();
                        this.getObjectByName("holds").addChild(this.plant);
                        return true;
                    default:
                        return false;
                }
            default :
                return false;
        }
    }

    public override function interact(entity : Dynamic) {
        if (!(entity is Character)) return;
        var chara : Character = entity;
        switch (this.state) {
            // TODO : play correspond animation
            case 0:
                var holds = chara.getObjectByName("holds");
                var suc = this.put(holds.getChildAt(0)); // TODO: the method can only put staff at position 0;
                if (suc) {
                    holds.removeChildren();
                    this.state = 1;
                }
            case 1:
                return; // TODO: here to update logic about updating plants
            case 2:
                return;
            case 3:
                this.state = 0;
                return;
            default:
                trace("Error: invalid state of plant soil " + this);
        }
    }

    public override function update(dt:Float) {
        super.update(dt);
        if (this.state == 1)
            this.plant.update(dt);
    }
}