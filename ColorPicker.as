package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.filters.ColorMatrixFilter;
	import starling.animation.Tween;
	import starling.textures.Texture;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
 
	//////
	import starling.events.Event;
	import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
	//////
 
	public class ColorPicker extends Sprite
	{
		[Embed(source="palette.png")]
		private static const Palette:Class;
 
		private static const CHANGED:String = "changed";
		private static const CHANGING:String = "changeding";
 
		private var paletteBMD:BitmapData;
		private var bitmap:Bitmap;
 
		private var palette:Image;
		private var tween:Tween;
		private var _value:uint;
		public var currentValue:uint;
		private var quad:Quad;
 
		private var squart:Sprite;
		public var filterTint:ColorMatrixFilter = new ColorMatrixFilter();
 
		private var hAlign:String;
		private var vAlign:String;
 
		/////////
		private var touches:Vector.<Touch>;
		private var m_TouchEndedPoint:Point;
		private var m_TouchTarget:DisplayObject;
		private var touch:Touch;
		/////////
		
		public static var _Designer:Designer;
 
		public function ColorPicker(hAlign:String="right",vAlign:String="top")
		{
			this.hAlign = hAlign;
			this.vAlign = vAlign;
 
			bitmap = new Palette();
			paletteBMD = bitmap.bitmapData;
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
 
		private function onAdded(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			init();
		}
 
		private function init():void {
			palette = new Image(Texture.fromBitmapData(paletteBMD));
			palette.visible = false;
			palette.alignPivot("right", "top");
			addChild(palette);
 
			squart = new Sprite();
			addChild(squart);
			var colorBG:uint = 0;
 
			quad = new Quad(20, 20);
			quad.setVertexColor(0, colorBG);//top
			quad.setVertexColor(1, colorBG);//top
			quad.setVertexColor(2, colorBG);//bottom
			quad.setVertexColor(3, colorBG);//bottom
 
			quad.filter = filterTint;
			squart.addChild(quad);
 
			var invisibleBtn:Button = new Button(Texture.fromColor(40, 40, 0));
			invisibleBtn.addEventListener(Event.TRIGGERED, showHidePalette);
			addChild(invisibleBtn);
 
			setPositionPallete();
		}
 
		private function setPositionPallete():void {
			trace("COLOR PICKER", hAlign,vAlign);
			if (hAlign == "right") {
				palette.x = squart.x + squart.width;
			}else if (hAlign == "left") {
				palette.x = squart.x - squart.width - palette.width;
			}else {
				palette.x = squart.x + (squart.width>>1) - (palette.width>>1);
			}
 
			if (vAlign == "top") {
				palette.y = squart.y + /*palette.height +*/ squart.height;
			}else if (vAlign == "bottom") {
				palette.y = squart.y;
			}else {
				palette.y = squart.y + (squart.height>>1) - (palette.height>>1);
			}
		}
 
		private function getColor(_x:int,_y:int):void {
			currentValue = paletteBMD.getPixel(_x, _y);
			trace("COLOR", currentValue.toString(16).toUpperCase());
			filterTint.reset();
			filterTint.tint(currentValue);
			dispatchEvent(new Event(CHANGING));
			_Designer.ColorInput.text = "0x" + String(currentValue.toString(16).toUpperCase());
		}
 
		public function set value(c:uint):void {
			_value = c;
			filterTint.reset();
			filterTint.tint(_value);
		}
 
		public function get value():uint {
			return _value;
		}
 
		private function showPalette():void {
			tween = new Tween(palette, 0.2);
			palette.alpha = 0;
			palette.visible = true;
			tween.fadeTo(1);
			Starling.juggler.add(tween);
			tween.onComplete = function(){
				Starling.juggler.remove(tween);
				palette.addEventListener(TouchEvent.TOUCH, onTouchPalette);
			};
		}
 
		private function hidePalette():void {
			tween = new Tween(palette, 0.2);
			palette.alpha = 1;
			palette.visible = true;
			tween.fadeTo(0);
			Starling.juggler.add(tween);
			tween.onComplete = function(){
								Starling.juggler.remove(tween);
								palette.removeEventListener(TouchEvent.TOUCH, onTouchPalette);
								palette.visible=false;
							};
		}
 
		////////////
 
		private function showHidePalette(e:Event):void {
			palette.visible?hidePalette():showPalette();
		}
 
		private function onTouchPalette(e:TouchEvent):void {
			touches = e.getTouches(stage);
			if (touches.length == 1)
			{
				touch = touches[0];
				m_TouchEndedPoint = new Point(touch.globalX, touch.globalY);
				if (touch.phase == TouchPhase.BEGAN){
					m_TouchTarget = touch.target;
					touch.getLocation(palette, m_TouchEndedPoint);
					getColor(int(m_TouchEndedPoint.x), int(m_TouchEndedPoint.y));
				}
				if (touch.phase == TouchPhase.ENDED){
					if (stage.hitTest(m_TouchEndedPoint, true) == m_TouchTarget)
					{
						value = currentValue;
						trace("CHANGED", currentValue.toString(16).toUpperCase());
						dispatchEvent(new Event(CHANGED));
						hidePalette();
					}
				}
				if (touch.phase == TouchPhase.MOVED){
					if (stage.hitTest(m_TouchEndedPoint, true) == m_TouchTarget)
					{
						touch.getLocation(palette, m_TouchEndedPoint);
						getColor(int(m_TouchEndedPoint.x), int(m_TouchEndedPoint.y));
					}
				}
			}
		}
 
	}
 
}