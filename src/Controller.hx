import hxd.Key;

class Controller {
    var object : h2d.Object;
    public var direction : h3d.Vector;
    public function new() {
        this.direction = new h3d.Vector(0, 0);
    }

    public function setControl(obj : h2d.Object) {
        this.object = obj;
    }

    // move the object being controlled
    public function move(speed : Float, dt : Float) {
        if (this.object != null) {
            this.object.x += direction.x * speed * dt;
            this.object.y += direction.y * speed * dt;
        }
    }
    public function isKeyPressed() : Bool {
        for (k in KeySetting.ACTION_KEYS) {
            if (Key.isDown(k))
                return true;
        }
        return false;
    }
}
