class ArrayUtil
{
    static public function main() {
        var test : Array<Array<Int>> = [[0,1,2],[3,4,5]];
        var copyA = test.copy();
        var copyB = deepCopy(test);


        test[1][0] = 100;


        for(i in 0...copyA.length)
            for(j in 0...copyA[i].length)
                trace(copyA[i][j]);


        for(i in 0...copyB.length)
            for(j in 0...copyB[i].length)
                trace(copyB[i][j]);
    }
    /**
    * Does a deep copy on the array, assuming the items are
    * further arrays or have "copy" semantics (such as fundamentals)
    */
    static public function deepCopy<T>( arr : Array<T> ) : Array<T>
    {


        if(arr.length > 0 && Std.is(arr[0], Array)){
            var r = new Array<T>();
            for( i in 0...arr.length ) {
                r.push(cast deepCopy(untyped arr[i]));
            }
            return r;
        } else {
            return arr.copy();
        }
    }
}