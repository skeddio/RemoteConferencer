package org.trivadis {
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	
	[Bindable]
	public class MediaVO {
		
		public static const PIC:int = 1;
		public static const VID:int = 2;
		
		public var id:int;
		public var path:String;
		public var name:String;
		public var date:Date;
		public var type:int;
		
		public var bytes:ByteArray;
		public var update:Matrix;
		
	}
}