package xd.parts
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.GestureEvent;
	import flash.events.GesturePhase;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import xd.geometry.MatrixHelper;
	
	[Event (name='change', type='flash.events.Event')]
	public class MultiDraggable extends Sprite {
		
		public var id:String;
		
		protected var _downQueue:Vector.<int> = new Vector.<int>;
		private var _touches:Dictionary = new Dictionary; // id --> point map
		private var _downMatrix:Matrix;
		private var pts:Array = [null, null, null, null];
		
		public function MultiDraggable(id:String)
		{
			this.id = id;
//			addEventListener(TransformGestureEvent.GESTURE_ZOOM, onZoom);
//			addEventListener(TransformGestureEvent.GESTURE_ROTATE, onRotate);
//			addEventListener(TransformGestureEvent.GESTURE_PAN, onPan);
			
			addEventListener(TouchEvent.TOUCH_BEGIN, start);			
	//		pts.length = 4;
			mouseEnabled = true;
		}
		
		private function onZoom(e:TransformGestureEvent):void {
			trace("<<<zoom>>>");
			this.scaleX *= e.scaleX;
			this.scaleY *= e.scaleY;
		}
		
		private var rotate:Number;
		
		private function onRotate(e:TransformGestureEvent):void {
			trace("<<<rotate>>>" + e.phase + " | " + e.rotation);
			if (e.phase==GesturePhase.BEGIN)
				rotate = e.rotation;
			else (e.phase==GesturePhase.UPDATE)
				rotate += e.rotation;
			if (e.phase==GesturePhase.END)
				this.rotation = rotate;
		}
		
		private function onPan(e:TransformGestureEvent):void {
			trace("<<<on pan image>>>");
			trace("On pan... " + e.offsetX + " offset Y " + e.offsetY);
			if (e.phase==GesturePhase.UPDATE) {
				this.x += e.offsetX;
				this.y += e.offsetY;
			}

		}
		
		private function get p0():Point {
			var t:Point = _touches[_downQueue[0]];
			return t;
		}
		private function get p1():Point { 
			if(_downQueue.length < 2) return null;
			var t:Point = _touches[_downQueue[1]];
			return t;
		}
		
		protected function start(e:TouchEvent):void {
			if(_downQueue.length == 0) {			
				stage.addEventListener(TouchEvent.TOUCH_MOVE, update);
				stage.addEventListener(TouchEvent.TOUCH_END, end);
			}
			
			_downQueue.push(e.touchPointID);
			_touches[e.touchPointID] =  new Point(e.stageX, e.stageY);
			
			//			if(_downQueue.length <=  2) {
			resync();
			//			}
			
		}
		
		private function resync():void {
			_downMatrix = transform.matrix;
			pts[0] = p0.clone();
			pts[1] = p1 ? p1.clone() : null;
		}
		
		
		protected function update(e:TouchEvent):void {
			var idx:int = _downQueue.indexOf(e.touchPointID);
			if(idx == -1) return;
			_touches[e.touchPointID] = new Point(e.stageX, e.stageY);
			
			pts[2] = p0.clone();
			pts[3] = p1? p1.clone() : null;
			
			var m1:Matrix = _downMatrix.clone();
			var m2:Matrix = MatrixHelper.deltaMatrixArray(pts);
			if(!m2) 
				return;
			m1.concat(m2);
			transform.matrix = m1;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function end(e:TouchEvent):void {
			var idx:int = _downQueue.indexOf(e.touchPointID);
			if(idx < 0) return;
			
			_downQueue.splice(idx,1);
			if(_downQueue.length > 0) {
				resync()
			} else  {
				stage.removeEventListener(TouchEvent.TOUCH_MOVE, update);
				stage.removeEventListener(TouchEvent.TOUCH_END, end);
			}
		}
	}
}