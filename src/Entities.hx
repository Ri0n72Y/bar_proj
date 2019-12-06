class Entities {

}
// TODO : add All given entities to this class

class Player extends h2d.Object {
    public var sprite : h2d.Bitmap;
    public var direction : h3d.Vector = new h3d.Vector();
    
    override function onAdd() {
        super.onAdd();
        var sprite = new h2d.Object(this);
        sprite.name = "sprite";
    }
}
