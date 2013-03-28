package org.trivadis {
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;
	
	public class MediaManager {
		
		private static var instance:MediaManager;
		
		public function MediaManager(clz:Singleton) {

		}
		
		public static function getInstance():MediaManager {
			if (!instance)
				instance = new MediaManager(new Singleton());
			return instance;
		}
		
		public function readMedia(path:File=null):ArrayCollection {
			var folder:File;
			if (!path){
				//use the Camera folder where is stored the photo shot by your camera (Android device)
				folder = new File(File.documentsDirectory.nativePath + "/DCIM/Camera/");
			}
			else{
				folder = path;
			}
			trace("<<<folder.nativePath>>> " + folder.nativePath);
			
			var arr:Array = folder.getDirectoryListing();
			var media:MediaVO;
			var ret:ArrayCollection = new ArrayCollection();
			var type:int;
			var j:int = 0;
			for (var i:int = 0,l:int = arr.length; i < l; i++ ) {
				type = getType(arr[i]);
				if (type) {
					media = new MediaVO();
					media.id = j++;
					media.path = arr[i].url;
					media.name = arr[i].name;
					media.date = arr[i].creationDate;
					media.type = type;
					ret.addItem(media);
				} 
			}
			return ret;
		}
		
		private function getType(f:File):int {
			if (f.extension == "jpg" || f.extension == "JPG"|| f.extension == "PNG"|| f.extension == "png") {
				return MediaVO.PIC;
			} else if (f.extension == "3gp") {
				return 0;
//				return MediaVO.VID;
			}
			return 0;
		}

	}
}

class Singleton {}