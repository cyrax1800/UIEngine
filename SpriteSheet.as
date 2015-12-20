package 
{
	import flash.geom.Point;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	/**
	 * ...
	 * @author Michael;
	 */
	public class SpriteSheet extends Sprite
	{
		public var Bg:Quad;
		public function SpriteSheet() 
		{
			Bg = new Quad(1024, 600);
			this.addChild(Bg);
			
			var X:Quad = new Quad(200, 200,0);
			X.addEventListener(TouchEvent.TOUCH, onItemTouch);
			X.x = 500;
			X.y = 100;
			this.addChild(X);
			
			this.width = 1024;
			this.height = 600;
			this.addEventListener(TouchEvent.TOUCH, onSheetTouch);
			this.alignPivot();
		}
		
		private function onItemTouch(e:TouchEvent):void 
		{
			if (e.getTouch(this, "began"))
			{
				this.removeEventListener(TouchEvent.TOUCH, onSheetTouch);
				trace("Item");
			}
			else if (e.getTouch(this, "moved")) {
				trace("ItemMove");
			}
			else if (e.getTouch(this, "ended")) {
				this.addEventListener(TouchEvent.TOUCH, onSheetTouch);
				trace("ItemEnded");
			}
		}
		
		public const StageMidPoint:Point = new Point(512, 300);
		public var differX:int;
		public var differY:int;
		public var pos:Point;
		public var dx:int;
		public var dy:int;
		public var finger1:Touch;
		public var finger2:Touch;
		public var distancePrev:int;
		public var distance:int;
		public var currentScale:Number;
		public var minScale:Number = .2;
		public var maxScale:Number = 3;
		private function onSheetTouch(e:TouchEvent):void 
		{
			var touches:Vector.<Touch> = e.touches;
			
			if (touches.length == 1) {
				if(touches[0].phase == "began") {
					pos = new Point(touches[0].globalX, touches[0].globalY);
					differX = pos.x - this.x;
					differY = pos.y - this.y;
				}
				else if (touches[0].phase == "moved") {
					this.x = touches[0].globalX - differX;
					this.y = touches[0].globalY - differY;
				}
				else if (touches[0].phase == "ended") {
					this.x = touches[0].globalX - differX;
					this.y = touches[0].globalY - differY;
				}
			}
			else if (touches.length == 2) {
				finger1 = touches[0];
				finger2 = touches[1];
				if (finger1.phase == "moved" && finger2.phase == "moved") {
					if(distancePrev==0)
						distancePrev = fingerDistance(finger1, finger2) / currentScale;
					distance = fingerDistance(finger1, finger2);
					if (distance / distancePrev > minScale && distance / distancePrev < maxScale)
						this.scale = currentScale = distance / distancePrev;
				}
			}
		}
		
		private function fingerDistance(finger1:Touch, finger2:Touch):int
		{
			dx = Math.abs ( finger1.globalX - finger2.globalX );
			dy = Math.abs ( finger1.globalY - finger2.globalY );

			return Math.sqrt(dx*dx+dy*dy);
		}
		
	}

}