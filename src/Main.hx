import Utils;

class Main {
	static function main() {
		var m = Numcp.ones([1,2,3]);
		//var n = Numcp.array([[[1,1,1],[1,1,1]]]);
		//var s = Numcp.array([[1,2,3],[4,5,6]]);
		trace(m);

		//n.vec[0][0][0] = 90;
		//m.vec[0][0][0] = 90;
		m.setItemOnIndex([0,0,0],99);
		trace(m);
	}
}
