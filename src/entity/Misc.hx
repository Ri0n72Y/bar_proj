package entity;

class Misc {
    
}

class Container extends Entity {
    
}

class Camera extends h2d.Object {
    public var following : Entity.Character;
    public var width : Float;
    public var height : Float;
    public function new(following : Entity.Character, width : Float, height : Float) {
        super();
        this.name = "camera";
        this.following = following;
        this.width = width; this.height = height;
        this.x = following.x - width  / 2;
        this.y = following.y - height / 2;
    }

    public function update(objs : Iterator<h2d.Object>) {
        this.x = following.x - width  / 2;
        this.y = following.y - height / 2;
        while (objs.hasNext()) {
            var obj = objs.next();
            obj.x -= this.x;
            obj.y -= this.y;
        }
    }
}

