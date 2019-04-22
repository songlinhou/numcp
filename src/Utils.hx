#if neko
import neko.Lib;
#elseif php
import php.Lib;
#elseif cpp
import cpp.Lib;
#elseif python
import python.Lib;
#elseif java
import java.Lib;
#elseif js
import js.Lib;
#end

@:keep
class Utils{

    

    public static function print(content){
        #if !js
        Lib.print(content);
        #else
        trace(content);
        #end
    }

    public static function println(content){
        #if !js
        Lib.println(content);
        #else
        trace(content + "\n");
        #end
    }

    #if !js
    static var stdin = Sys.stdin();
    public static function readLine():String{
        return stdin.readLine();
    }
    #end

    public static function isNumber(param):Bool{
        if (Std.is(param, Int)){
            return true;
        }
        else if (Std.is(param, Float)){
            return true;
        }
        return false;
    }
    public static function isArray(param):Bool{
        return Std.is(param, Array);
    }
}