import Utils;

@:generic
class Ndarray<T>{
    public var vec:Array<T>;
    private var _shape:Array<Int>;
    private var _dim:Int;
    private var showFull:Array<Bool>;

    public function new (?vec:Array<T>){
        if(vec == null){
            this.vec = [];
            return;
        }
        this.vec = vec;
        this._dim = getDimNumber();
        this.showFull = [];
        this._shape = getShape();
        // this._dim = getDimNumber();
        // this.showFull = [];
        // this._shape = getShape();
    }

    public function toList():Array<T>{
        return Reflect.copy(this.vec);
    }

    public function shape():Ndarray<Int>{
        var shape = new Ndarray(this._shape);
        return shape;
    }

    private function getSlicedIndex(slice_array:Array<String>):Array<Array<Int>>{
        var slices:Array<Array<Int>> = [];
        var i:Int = 0;
        
        for(_range in slice_array){
            //trace(_range);
            
            var _range_trim = StringTools.trim(_range);
            if(_range_trim == ":"){
                slices.push([-1]);
            }
            var _int_range = _range.split(":");
            if(_int_range.length == 2){
                var first = Std.parseInt(_int_range[0]);
                var second = Std.parseInt(_int_range[1]);
                if(first > second){
                    return [];
                }
                slices.push([first,second]);
            }
        }
        return slices;
    }

    public function slice(slice_array:Array<String>){
        var slices = getSlicedIndex(slice_array);
        var ret = this.vec;
        for(i in 0...slices.length){
            var slice_range = slices[i];
            if(slice_range != [-1]){
                ret = ret.splice(slice_range[0],slice_range[1]);
                trace("now ret="+ret);
            }
            else{
                trace("keep as it is");
            }
        }
        return new Ndarray(ret);
    }

    public function dim():Int{
        return this._dim;
    }


    private function getDimNumber():Int{
        var str_presentation = "" + this.vec;
        //trace(str_presentation);
        var last_index = str_presentation.indexOf("]");
        str_presentation = str_presentation.substring(0,last_index);
        //trace(str_presentation);
        var bracket_pos =  str_presentation.indexOf("[");
        var dims = 0;
        while(bracket_pos>=0){
            dims ++;
            str_presentation = str_presentation.substring(1);
            bracket_pos =  str_presentation.indexOf("[");
        }
        return dims;
    }


    public function transform(func:Float->Float){
        return __transformArray(func);
    }

    public function broadcastOperation(another:Dynamic,func){
        if(Numcp.isNdarray(another))
        {
            //trace("ndarray");
            return __broadcastOperation(another,func);
        }
        else if(Numcp.isArray(another)){
            //trace("array");
            var antherNDarray = new Ndarray<Dynamic>(another);
            return __broadcastOperation(antherNDarray,func);
        }
        else{
            //trace("number");
            return __broadcastOperationWithSingleItem(another,func);
        }
    }


    public function adds(another:Dynamic){
        var addFunc = function(a:Float,b:Float) return a+b;
        return broadcastOperation(another,addFunc);
    }

    public function minus(another:Dynamic){
        var func = function(a:Float,b:Float) return a-b;
        return broadcastOperation(another,func);
    }

    public function times(another:Dynamic){
        var func = function(a:Float,b:Float) return a*b;
        return broadcastOperation(another,func);
    }

    public function divides(another:Dynamic){
        var func = function(a:Float,b:Float) return a/b;
        return broadcastOperation(another,func);
    }

    public function mods(another:Dynamic){
        var func = function(a:Float,b:Float) return a%b;
        return broadcastOperation(another,func);
    }

    public function floor(){
        var func = function(a:Float) return Math.ffloor(a);
        return transform(func);
    }

    public function ceil(){
        var func = function(a:Float) return Math.fceil(a);
        return transform(func);
    }

    public function sum(axis:Int=0){
        //if(axis)
    }




    

    
    private function __broadcastOperationWithSingleItem(item,func){
        var allIndexes = getAllItemIndexes();
        var copiedOfThisObj = new Ndarray(ArrayUtil.deepCopy(this.vec));
        for(selection in allIndexes){
            var a = copiedOfThisObj.getItemOnIndex(selection);
            var a_ = cast(a,Float);
            var b_ = cast(item,Float);
            copiedOfThisObj.setItemOnIndex(selection,func(a_,b_));
        }
        return copiedOfThisObj;
    }

    private function __transformArray(func){
        var copiedOfThisObj = new Ndarray(ArrayUtil.deepCopy(this.vec));
        var allIndexes = getAllItemIndexes();
        for(selection in allIndexes){
            var a = copiedOfThisObj.getItemOnIndex(selection);
            var a_ = cast(a,Float);
            var targetValue = func(a_);
            copiedOfThisObj.setItemOnIndex(selection,targetValue);
        }
        return copiedOfThisObj;
    }

    private function __broadcastOperation(another:Ndarray<Dynamic>,func){
        var equalInShape = Utils.equalInSimpleIntList(this.shape().toList(),another.shape().toList());
        if(equalInShape){
            var copiedOfThisObj = new Ndarray(ArrayUtil.deepCopy(this.vec));
            var allIndexes = getAllItemIndexes();
            //trace("allindex"+allIndexes);
            for(selection in allIndexes){
                var a = copiedOfThisObj.getItemOnIndex(selection);
                var b = another.getItemOnIndex(selection);
                var a_ = cast(a,Float);
                var b_ = cast(b,Float);
                var targetValue:Float = func(a_,b_);
                //trace("op"+a_ +" " + b_ + "=" + targetValue);
                copiedOfThisObj.setItemOnIndex(selection,targetValue);
            }
            return copiedOfThisObj;
        }
        else{
            trace("ERROR: shape not matched, expect " + this.shape().toList() + ", but got " + another.shape().toList());
            return null;
        }
    }

    public function getAllItemIndexes(){
        // [2,3] => [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2]]
        // [2,3,4] => [[0,0,0],[0,0,1]]
        var arrayShape = this._shape;
        var retList = [for(i in 0...arrayShape[0]) i+""];
        for (i in 1...arrayShape.length){
            var dimNum = arrayShape[i];
            retList = generateIndexes(retList,dimNum);
        }
        var result = [];
        for (indexStr in retList){
            var indice = indexStr.split('-');
            var itemList = [];
            for(index in indice){
                var intIndex = Std.parseInt(index);
                itemList.push(intIndex);
            }
            result.push(itemList);
        }
        return result;
    }


    private function generateIndexes(resultList:Array<String>,dim:Int){
        var newRetList = [];
        for(arrayItem in resultList){
            //var newList = [];
            for(i in 0...dim){
                //newList.push(arrayItem + "-" + i);
                newRetList.push(arrayItem + "-" + i);
            }
            //newRetList.push(newList);
        }
        return newRetList;
    }

    public function setItemOnIndex(item_index:Array<Int>,value){
        var __vec__ = cast(vec,Array<Dynamic>);
        for(i in 0...(item_index.length-1)){
            var index = item_index[i];
            __vec__ = __vec__[index];
        }
        var lastIndex = item_index[item_index.length-1];
        __vec__[lastIndex] = value;
    }

    public function getItemOnIndex(item_index:Array<Int>){
        var __vec__ = cast(vec,Array<Dynamic>);
        for(i in 0...(item_index.length)){
            var index = item_index[i];
            __vec__ = __vec__[index];
        }
        return __vec__;
    }

    private function getShape():Array<Int>{
        
        
        //trace(dims);
        var dim_list = [];
        // var subset = <Array<Any>>(this.vec);
        var subset = cast(this.vec,Array<Dynamic>);
        while(true){
            if(dim_list.length >= this._dim){
                break;
            }
            var current_dim_length = subset.length;
            if(current_dim_length>=200){
                this.showFull.push(false);
            }
            else{
                this.showFull.push(true);
            }
            dim_list.push(current_dim_length);
            subset = subset[0];
        }
        return (dim_list);
        //trace(dim_list);
        
    }



    public function toString(){

        var str =  ("\narray("+ this.vec + ")");
        var output = StringTools.replace(str,"]],[[","]],\n\t[[");
        output = StringTools.replace(output,"],[","],\n\t[");
        //output = StringTools.replace(output,",",",\t");
        return output;
        // var content = ""+this.vec;
        // return ();
    }
}