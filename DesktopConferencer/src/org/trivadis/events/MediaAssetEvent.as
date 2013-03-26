package org.trivadis.events {
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import org.trivadis.MediaVO;
	
	public class MediaAssetEvent extends Event {
		
		public static const MEDIA:String = "media";
		public static const UPDATE:String = "update";

		public var media:MediaVO;
		public var matrix:Matrix;
		
		public function MediaAssetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}