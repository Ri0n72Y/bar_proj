import Controller;

class Entities {

}
// TODO : add All given entities to this class

class Player extends h2d.Object {
    public var sprite : h2d.Bitmap;
    
    public function new() {
        super();
        var sprite = new h2d.Object(this);
        sprite.name = "sprite";
    }
}
