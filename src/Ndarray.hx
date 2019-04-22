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
        trace(str_presentation);
        var last_index = str_presentation.indexOf("],");
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

    public function broadcastOperation(another:Ndarray<Any>,func){
        if(this.shape().toList() == another.shape().toList()){

        }
        else{
            trace("ERROR: shape not matched");
        }
    }

    private function getAllItemIndexes(){
        // [2,3] => [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2]]
        // [2,3,4] => [[0,0,0],[0,0,1]]
        var arrayShape = this._shape;
        var totalNum = [];
        var product = 1;
        for (d in arrayShape){
            product = product * d;
        }
        for (i in 0...arrayShape.length){ // length = 3, i=0,j=2, i=1,j=1, i=2,j=0
            var j = arrayShape.length - i - 1;
            
        }
        //TODO
    }

    private function generateIndex(tub:String,array:Array<Dynamic>){
        for(i in 0...array.length){

        }
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
        output = StringTools.replace(str,"],[","],\n\t[");
        return output;
        // var content = ""+this.vec;
        // return ();
    }
}