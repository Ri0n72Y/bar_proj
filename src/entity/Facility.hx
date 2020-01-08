package entity;

import entity.Plant.Plant_Waterfruit;
import entity.Item.FruitType;
import entity.Item.ItemType;

class Facility extends Entity {
    var id : String;
    var description : String;

    function put(i: Item) {
    }
}

class PlantSoil extends Facility {
    var state : Int; // unused
    var plant : Plant;
    var interactions : String; // place holder
    public function new(sprite: h2d.Bitmap) {
        super();
        this.sprite = sprite;
        this.isSpriteChanged = true;
    }

    public override function put(plant: Item) {
        if ((plant == null) || !(plant is Item.Seed)) return; // debug
        switch (plant.type) {
            case ItemType.Seed:
                switch (plant.fruitType) {
                    case FruitType.WF:
                        this.plant = new Plant_Waterfruit();
                        this.getObjectByName("holds").addChild(this.plant);
                        return;
                    default:
                        return;
                }
            default :
                return;
        }
    }

    public override function update(dt:Float) {
        super.update(dt);
        if (this.plant != null)
            this.plant.update(dt);
    }
}