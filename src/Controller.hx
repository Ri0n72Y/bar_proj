class Controller {
    var keys_down : Int;
    var object : h2d.Object;
    public var direction : h3d.Vector;
    public function new() {
        keys_down = 0;
        this.direction = new h3d.Vector(0, 0);
    }

    public function setControl(obj : h2d.Object) {
        this.object = obj;
    }

    public function move(speed : Float, dt : Float) {
        if (this.object != null) {
            this.object.x += direction.x * speed * dt;
            this.object.y += direction.y * speed * dt;
        }
    }

    public function keyPressed() {
        keys_down ++;
    }
    public function keyReleased() {
        keys_down --;
    }
}
