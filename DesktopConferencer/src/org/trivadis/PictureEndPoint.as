package org.trivadis {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import org.trivadis.events.MediaAssetEvent;
	import org.trivadis.peer2peer.MultiCastingService;
	import org.trivadis.peer2peer.events.ServiceEvent;
	
	[Event(name="connected", type="org.corlan.peer2peer.events.ServiceEvent")]
	[Event(name="disconnected", type="org.corlan.peer2peer.events.ServiceEvent")]
	[Event(name="peerconnect", type="org.corlan.peer2peer.events.ServiceEvent")]
	[Event(name="peerdisconnect", type="org.corlan.peer2peer.events.ServiceEvent")]
	[Event(name="media", type="org.trivadis.events.MediaAssetEvent")]
	[Event(name="update", type="org.trivadis.events.MediaAssetEvent")]
	
	public class PictureEndPoint extends EventDispatcher {
		
		
		private var service:MultiCastingService;
		private var timer:Timer = new Timer(200, 0);
		
		public function PictureEndPoint(target:IEventDispatcher=null) {
			super(target);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			service = new MultiCastingService(null, true, "picturegroup");
			service.addEventListener(ServiceEvent.CONNECTED, onConnection, false, 0, true);
			service.addEventListener(ServiceEvent.DISCONNECTED, onLostConnection, false, 0, true);
			service.addEventListener(ServiceEvent.RESULT, onResult, false, 0, true);
			service.addEventListener(ServiceEvent.PEER_DISCONNECT, onPeerDisconnect, false, 0, true);
			service.addEventListener(ServiceEvent.PEER_CONNECT, onPeerConnect, false, 0, true);
			timer.start();
		}
		
		public function connect():void {
			service.connect();
		}
		
		public function disconnect():void {
			service.disconnect();
		}
		
		public function get neighborCount():int {
			return service.neighborCount;
		}
		
		private function onTimer(e:TimerEvent):void {
			service.connect();
			timer.stop();
		}
		
		private function onConnection(e:ServiceEvent):void {
			timer.stop();
			var e2:ServiceEvent = new ServiceEvent(ServiceEvent.CONNECTED);
			dispatchEvent(e2);
		}
		
		private function onLostConnection(e:ServiceEvent):void {
			var e2:ServiceEvent = new ServiceEvent(ServiceEvent.DISCONNECTED);
			dispatchEvent(e2);
			timer.start();
		}
		
		private function onPeerDisconnect(e:ServiceEvent):void {
			var e2:ServiceEvent = new ServiceEvent(ServiceEvent.PEER_DISCONNECT);
			dispatchEvent(e2);
		}

		private function onPeerConnect(e:ServiceEvent):void {
			var e2:ServiceEvent = new ServiceEvent(ServiceEvent.PEER_CONNECT);
			dispatchEvent(e2);
		}
		
		private function onResult(e:ServiceEvent):void {
			trace("RECEIVE " + e.from + " | " + e.what + " | " + (e.body ? e.body.toString() : "")); 
			var e2:MediaAssetEvent;
			switch (e.what) {
				case MediaAssetEvent.MEDIA:
					e2 = new MediaAssetEvent(MediaAssetEvent.MEDIA);
					e2.media = new MediaVO();
					e2.media.id = e.body.id;
					e2.media.bytes = e.body.bytes;
					e2.media.type = e.body.type;
					break;
				case MediaAssetEvent.UPDATE:
					e2 = new MediaAssetEvent(MediaAssetEvent.UPDATE);
					e2.media = new MediaVO();
					e2.media.id = e.body.id;
					var m:Object = e.body.matrix;
					var matrix:Matrix = new Matrix(m.a, m.b, m.c, m.d, m.tx, m.ty);
					e2.matrix = matrix;
					break;
				default:
					break;
			}
			if (e2)
				dispatchEvent(e2);
		}
	}
}