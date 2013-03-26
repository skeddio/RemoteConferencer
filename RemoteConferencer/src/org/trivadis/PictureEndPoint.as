package org.trivadis {
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.core.Singleton;
	
	import org.trivadis.peer2peer.MultiCastingService;
	import org.trivadis.peer2peer.events.ServiceEvent;
	
	
	[Event(name="connected", type="org.trivadis.peer2peer.events.ServiceEvent")]
	[Event(name="disconnected", type="org.trivadis.peer2peer.events.ServiceEvent")]
	[Event(name="peerconnect", type="org.trivadis.peer2peer.events.ServiceEvent")]
	[Event(name="peerdisconnect", type="org.trivadis.peer2peer.events.ServiceEvent")]
	public class PictureEndPoint extends EventDispatcher {
		
		private static var instance:PictureEndPoint;
		
		private var service:MultiCastingService;
		private var timer:Timer = new Timer(200, 0);
		
		public function PictureEndPoint(target:IEventDispatcher, clz:Singleton) {
			super(target);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			
			service = new MultiCastingService(null, true, "picturegroup");
			
			service.addEventListener(ServiceEvent.CONNECTED, onConnection, false, 0, true);
			service.addEventListener(ServiceEvent.DISCONNECTED, onLostConnection, false, 0, true);
			service.addEventListener(ServiceEvent.PEER_CONNECT, onPeerConnect, false, 0, true);
			service.addEventListener(ServiceEvent.PEER_DISCONNECT, onPeerDisconnect, false, 0, true);
			timer.start();
		}
		
		public static function getInstance(target:IEventDispatcher=null):PictureEndPoint {
			if (!instance)
				instance = new PictureEndPoint(target, new Singleton());
			return instance;
		}
		
		public function post(message:Object, what:String):void {
			service.post(message, what, null, true);
		}
		
		private function onTimer(e:TimerEvent):void {
			service.connect();
			timer.stop();
		}
		
		public function get isReady():Boolean {
			return service.isReady;
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
		
		private function onPeerConnect(e:ServiceEvent):void {
//			var e2:ServiceEvent = new ServiceEvent(ServiceEvent.PEER_CONNECT);
//			dispatchEvent(e2);
		}
		
		private function onPeerDisconnect(e:ServiceEvent):void {
//			var e2:ServiceEvent = new ServiceEvent(ServiceEvent.PEER_DISCONNECT);
//			dispatchEvent(e2);
		}
	}
}
class Singleton {}