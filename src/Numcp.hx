package;

import Ndarray;
import ArrayUtil;

@:keep
class Numcp{
    public static function array(vec:Array<Dynamic>){
        var ndarry = new Ndarray<Dynamic>(vec);
        return ndarry;
    }

    private static function arrayWithSameElement(shape:Array<Int>,element:Any):Array<Dynamic>{
        //var ret = [];
        var dim = shape.length;
        shape.reverse();
        //var base:Array<Dynamic> = [for (i in 0...shape[0]) Reflect.copy(element)];
        var base:Array<Dynamic> = createAListOfCopies(shape[0],element);
        for (i in 1...dim){
            //var baseTemp = Reflect.copy(base);
            //base = [for (i in 0...shape[i]) Reflect.copy(baseTemp)];
            base = createAListOfCopies(shape[i], base);
        }
        return base;
    }

    private static function createAListOfCopies(num,obj){
        var retList = [];
        for(i in 0...num){
            var objCopied = obj;
            if(Std.is(obj,Array)){
                objCopied = ArrayUtil.deepCopy(obj);
            }
            retList.push(objCopied);
        }
        return retList;
    }

    private static function createElementRecursive(){
         
    }

    public static function zeros(shape:Array<Int>){
        return new Ndarray<Dynamic>(arrayWithSameElement(shape,0));
    }

    public static function ones(shape:Array<Int>){
        return new Ndarray<Dynamic>(arrayWithSameElement(shape,1.0));
    }

    public static function all(array_like:Any){
        if(Std.is(array_like,Array)){

        }
        else if(Std.is(array_like,Ndarray)){

        }
    }

    public static function add(array_or_number1:Any,array_or_number2:Any){
        if(Std.is(array_or_number1,Array) && Std.is(array_or_number2,Array)){
            var ndarray1 = new Ndarray<Any>(array_or_number1);
            var ndarray2 = new Ndarray<Any>(array_or_number2);
            if(ndarray1.shape().toList() == ndarray2.shape().toList()){

            }
        }
        else if(Std.is(array_or_number1,Ndarray)){

        }
    }

    private static function all_nadarray(array:Ndarray<Any>){
        var shape = array.shape();
        
        while(true){
            //var current_dim = shape.shift();
            break;
        }
    }

}