package org.trivadis {
	
	public class CurrentIndex { 
		
		private static var instance:CurrentIndex;
		
		public var index:int;
		
		public function CurrentIndex(clz:Singleton=null){
			
		}
		
		public static function getInstance():CurrentIndex {
			if (!instance)
				instance = new CurrentIndex(new Singleton());
			return instance;
		}
	}
}

class Singleton {}