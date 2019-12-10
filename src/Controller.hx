import hxd.Key;
import Entity;

class Controller {
    var object : h2d.Object;
    public var direction : h3d.Vector;
    public function new() {
        this.direction = new h3d.Vector(0, 0);
    }

    public function setControl(obj : Character) {
        this.object = obj;
        obj.controller = this;
    }

    // move the object being controlled
    public function move(speed : Float, dt : Float) {
        if (this.object != null) {
            this.object.x += direction.x * speed * dt;
            this.object.y += direction.y * speed * dt;
        }
    }
    public function isKeyPressed() : Int {
        for (k in KeySetting.ACTION_KEYS) {
            if (Key.isDown(k))
                return k;
        }
        return -1;
    }
}
