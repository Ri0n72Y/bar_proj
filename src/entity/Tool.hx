package entity;

import entity.Item.ItemType;

enum ToolType {
    Rake; Pickaxe; Sickle; // 镰刀
    None;
}

class Tool extends Item {
    public final toolType : ToolType;
    public function new(type : ToolType) {
        super(ItemType.Tool);
        this.toolType = type;
    }
}