import hxd.Key as K;

class KeySetting {
    public static var MOVE_VERTICAL_DEC   : Int = K.W; // move up
    public static var MOVE_VERTICAL_INC   : Int = K.S; // move down
    public static var MOVE_HORISONTAL_DEC : Int = K.A; // move left
    public static var MOVE_HORISONTAL_INC : Int = K.D; // move right

    public static var ACTION_INTERACT : Int = K.J; // action try to interact with other object
    public static var ACTION_TALK     : Int = K.F; // action try to talInt to selected object
    public static var ACTION_CHECK    : Int = K.I; // action try to checInt selected object
    
    public static var SYS_MENU  : Int = K.ESCAPE; // open menu
    public static var SYS_ENTER : Int = K.ENTER; // select enter
    public static var SYS_EXIT  : Int = K.ESCAPE; // select cancel
    public static var SYS_SEL_UP :  Int = K.W; // move cursor up
    public static var SYS_SEL_DW :  Int = K.S; // move cursor down
    public static var SYS_SEL_LF :  Int = K.A; // move cursor left
    public static var SYS_SEL_RT :  Int = K.D; // move cursor right
    public static var SYS_PAGE_PRE  :  Int = K.Q; // menu page switch previous
    public static var SYS_PAGE_POST :  Int = K.E; // menw page switch next

    public function readConfig(config : String = "default") {
        // TODO: read key configration and set above keys to the configration
    }

    public function setDefault() {
        // TODO: set keys to default value
    }
}