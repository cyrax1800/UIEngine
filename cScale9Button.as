package 
{
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.geom.Rectangle;
	import starling.display.Button;
	import starling.display.Quad;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Michael;
	 */
	public class cScale9Button extends Button
	{
		/**
		 * 
		 * @param	texture Texture
		 * @param	width Button width
		 * @param	height Butotn height
		 * @param	text Button text(label)
		 * @param	font Button fontFamily
		 * @param	fontSize Size of the font
		 * @param	fontColor font colot
		 */
		
		public function cScale9Button(texture:Texture, rectX:int, rectY:int, rectWidth:int, rectHeight:int) {
			var text:Texture = getTex(texture, rectX, rectY, rectWidth, rectHeight);
			super(text);
			this.width = 50;
			this.height = 50;
		}
		
		public function getTex(texture:Texture, rectX:int, rectY:int, rectWidth:int, rectHeight:int):Texture{
			var rect:Rectangle = new Rectangle(rectX, rectY, rectWidth, rectHeight);
			var textures:Scale9Textures = new Scale9Textures( texture, rect );
			//rect.setTo(0, 0, tmpScale9Image.width, tmpScale9Image.height);
			//Text.frame = rect;
			//Text = tmpScale9Image
			return textures.texture;
		}
		
		
	}

}