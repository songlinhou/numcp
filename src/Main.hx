import Utils;

class Main {
	static function main() {

		// var m = Numcp.ones([1,2,3]);
		// //var n = Numcp.array([[[1,1,1],[1,1,1]]]);
		// var s = Numcp.array([[[1,2,3]],[[4,5,6]],[[7,8,9]]]);
		// var s2 = Numcp.array([[[1,2,3]],[[4,5,6]],[[7,8,9]]]);
		// var s3 = s.adds(s2);
		// trace(s3+"");
		var ms = Numcp.array([1,2,3]);
		var output = ms.adds(ms);
		trace(output);
	}
}
