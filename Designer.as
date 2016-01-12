package
{
	import adobe.utils.CustomActions;
	import feathers.controls.Button;
	import feathers.controls.ButtonGroup;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.List;
	import feathers.controls.PickerList;
	import feathers.controls.popups.DropDownPopUpContentManager;
	import feathers.controls.popups.VerticalCenteredPopUpContentManager;
	import feathers.controls.Radio;
	import feathers.controls.renderers.DefaultListItemRenderer;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.controls.Slider;
	import feathers.controls.TabBar;
	import feathers.controls.text.TextBlockTextRenderer;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.controls.TextInput;
	import feathers.core.ITextRenderer;
	import feathers.core.ToggleGroup;
	import feathers.data.ListCollection;
	import feathers.display.Scale9Image;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.VerticalLayout;
	import feathers.textures.Scale9Textures;
	import feathers.themes.MetalWorksDesktopTheme;
	import flash.display3D.IndexBuffer3D;
	import flash.geom.Rectangle;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.TextFormat;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.fluocode.Fluocam;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	/**
	 * ...
	 * @author Michael;
	 */
	public class Designer extends Sprite
	{
		[Embed(source="feathers/assets/images/metalworks_desktop.xml",mimeType="application/octet-stream")]
		private static const ATLAS_XML:Class;
		
		[Embed(source="feathers/assets/images/metalworks_desktop.png")]
		private static const ATLAS_BITMAP:Class;
		
		//Constanta
		public const BACKGROUND:int = 0;
		public const UI:int = 1;
		public const TEXT:int = 2;
		public const ALL:int = 3;
		
		
		public var UIAtlas:TextureAtlas;
		//variable for Sheet;
		public var Sheet:SpriteSheet;
		
		//variable for Panel Left;
		public var PanelLeft:Sprite;
		public var PanelLeftBackground:Quad
		
		//variable for Panel Right;
		public var PanelRight:Sprite;
		public var PanelRightBackground:Quad;
		
		//variable LeftPanel;
		public var NewButton:Button;
		public var OpenButton:Button;
		public var SaveButton:Button;
		public var DisplayObjectPickerList:PickerList;
		public var PickerString:Vector.<String> = new <String>["Starling.Image", "Starling.Button", "Feathers.Scale9Button", "Feathers.Scale9Image", "Feathers.Scale3Button", "Feathers.scale3Image"];
		public var searchInput:TextInput;
		public var TextureTab:TabBar;
		public var TextureList:List;
		public var ListDataProvider:Vector.<ListCollection>;
		public var SearchListDataProvider:ListCollection;
		public var DataProviderText:Vector.<Vector.<String>>;
		public var SearchListDataProviderIndex:Vector.<int>;
		public var DrawShapeLabel:Label;
		public var QuadButton:Button;
		public var RectButton:Button;
		public var PolyButton:Button;
		public var CircleButton:Button;
		public var EllipseButton:Button;
		
		public var Text:Image;
		//variable RightPanel;
		public var PropertiesLabel:Label;
		public var VariableName:Label;
		public var VariableNameInput:TextInput;
		public var CoordXLabel:Label;
		public var CoordXInput:TextInput;
		public var CoordYLabel:Label;
		public var CoordYInput:TextInput;
		public var widthLabel:Label;
		public var widthInput:TextInput;
		public var heightLabel:Label;
		public var heightInput:TextInput;
		public var PivotX:Label;
		public var PivotXToggleRadioGroup:ToggleGroup;
		public var PivotXToggleRadioContainer:LayoutGroup;
		public var PivotXRight:Radio;
		public var PivotXMiddle:Radio;
		public var PivotXLeft:Radio;
		public var PivotY:Label;
		public var PivotYToggleRadioGroup:ToggleGroup;
		public var PivotYToggleRadioContainer:LayoutGroup;
		public var PivotYTop:Radio;
		public var PivotYMiddle:Radio;
		public var PivotYBottom:Radio;
		public var AlphaLabel:Label;
		public var AlphaInput:TextInput;
		public var AlphaSlider:Slider;
		public var colorPicker:ColorPicker;
		public var ColorLabel:Label;
		public var ColorInput:TextInput;
		
		public function Designer()
		{
			var texture:Texture = Texture.fromEmbeddedAsset(ATLAS_BITMAP);
			var xml:XML = XML(new ATLAS_XML());
			UIAtlas = new TextureAtlas(texture, xml);
			new MetalWorksDesktopTheme();
			
			ListDataProvider = new Vector.<ListCollection>(4);
			DataProviderText = new Vector.<Vector.<String>>(4);
			DataProviderText[BACKGROUND] = new Vector.<String>();
			DataProviderText[UI] = new Vector.<String>();
			DataProviderText[TEXT] = new Vector.<String>();
			DataProviderText[ALL] = new Vector.<String>();
			
			SearchListDataProvider = new ListCollection();
			SearchListDataProviderIndex = new Vector.<int>();
			
			//Text = new Image(UIAtlas.getTexture("back-button-disabled-skin0000"));
			
			initSheet();
			initLeftPanel();
			initRightPanel();
		}
		
		private function onShapeButtonTriggered(event:Event):void{
			var button:Button = Button(event.currentTarget);
			trace(button.label + " triggered.");
		}
		
		private function tabBar_changeHandler(e:Event):void {
			var target:TabBar = e.currentTarget as TabBar;
			if (target.selectedIndex == 0) {
				TextureList.dataProvider = ListDataProvider[BACKGROUND];
			}
			else if (target.selectedIndex == 1) {
				TextureList.dataProvider = ListDataProvider[UI];
			}
			else if (target.selectedIndex == 2) {
				TextureList.dataProvider = ListDataProvider[TEXT];
			}
			else if (target.selectedIndex == 3) {
				TextureList.dataProvider = ListDataProvider[ALL];
			}
			searchInput.text = "";
		}
		
		private function PickerListChangeHandler(e:Event):void {
			if (PanelRight == null) return;
			PanelRight.removeChildren(2);
			var target:PickerList = e.currentTarget as PickerList;
			PropertiesLabel.text = "Properties: " + PickerString[target.selectedIndex];
			if (target.selectedIndex == 0) {
				StarlingImageProperTies();
			}
		}
		
		public function getTex(texture:Texture, rectX:int, rectY:int, rectWidth:int, rectHeight:int):Scale9Textures{
			var rect:Rectangle = new Rectangle(rectX, rectY, rectWidth, rectHeight);
			var textures:Scale9Textures = new Scale9Textures( texture, rect );
			return textures;
		}
		
		public function initLeftPanel():void {
			PanelLeft = new Sprite();
			PanelLeftBackground = new Quad(200, 700, 0x7a7669);
			PanelLeft.addChild(PanelLeftBackground);
			this.addChild(PanelLeft);
			
			NewButton = new Button();
			NewButton.width = 50;
			NewButton.height = 20;
			NewButton.label = "New";
			NewButton.name = "New";
			NewButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(NewButton);
			
			OpenButton = new Button();
			OpenButton.width = 50;
			OpenButton.height = 20;
			OpenButton.label = "Open";
			OpenButton.name = "Open";
			OpenButton.x = 60;
			OpenButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(OpenButton);
			
			SaveButton = new Button();
			SaveButton.width = 50;
			SaveButton.height = 20;
			SaveButton.label = "Save";
			SaveButton.name = "Save";
			SaveButton.x = 120;
			SaveButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(SaveButton);
			
			DisplayObjectPickerList = new PickerList();
			DisplayObjectPickerList.dataProvider = new ListCollection(
			[
				{text: "Starling.Image"},
				{text: "Starling.Button"},
				{text: "feathers.scale9Button"},
				{text: "feathers.scale9Image"},
				{text: "feathers.scale3Button"},
				{text: "feathers.scale3Image"},
			]);
			DisplayObjectPickerList.listProperties.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();
				renderer.labelField = "text";
				return renderer;
			};
			DisplayObjectPickerList.addEventListener( Event.CHANGE, PickerListChangeHandler );
			DisplayObjectPickerList.prompt = "Select an Item";
			DisplayObjectPickerList.labelField = "text";
			DisplayObjectPickerList.selectedIndex = -1;
			DisplayObjectPickerList.popUpContentManager = new DropDownPopUpContentManager();
			DisplayObjectPickerList.y = 30;
			DisplayObjectPickerList.width = 200;
			PanelLeft.addChild( DisplayObjectPickerList );
			
			searchInput = new TextInput();
			searchInput.styleNameList.add(TextInput.ALTERNATE_STYLE_NAME_SEARCH_TEXT_INPUT);
			searchInput.prompt = "Search";
			searchInput.y = 80;
			searchInput.width = 200;
			searchInput.addEventListener(Event.CHANGE, onSearchTextChange);
			PanelLeft.addChild(searchInput);
			
			TextureTab = new TabBar();
			TextureTab.dataProvider = new ListCollection(
			[
				{ label: "Background" },
				{ label: "UI" },
				{ label: "Text" },
				{ label: "All" },
			]);
			TextureTab.addEventListener(Event.CHANGE, tabBar_changeHandler);
			TextureTab.layoutData = new AnchorLayoutData(NaN, 0, 0, 0);
			TextureTab.y = 60;
			TextureTab.distributeTabSizes = true;
			TextureTab.maxWidth = 200;
			PanelLeft.addChild(TextureTab);
			
			var items:Array = [];
			for(var i:int = 0; i < 30; i++)
			{
				var item:Object = {text: "Item " + (i * 1).toString()};
				items[i] = item;
				DataProviderText[BACKGROUND].push("Item " + (i * 1).toString());
			}
			ListDataProvider[BACKGROUND] = new ListCollection(items);
			var items:Array = [];
			for(var i:int = 0; i < 30; i++)
			{
				var item:Object = {text: "Item " + (i * 2).toString()};
				items[i] = item;
				DataProviderText[UI].push("Item " + (i * 2));
			}
			ListDataProvider[UI] = new ListCollection(items);
			var items:Array = [];
			for(var i:int = 0; i < 30; i++)
			{
				var item:Object = {text: "Item " + (i *3).toString()};
				items[i] = item;
				DataProviderText[TEXT].push("Item " + (i * 3));
			}
			ListDataProvider[TEXT] = new ListCollection(items);
			var items:Array = [];
			for(var i:int = 0; i < 30; i++)
			{
				var item:Object = {text: "Item " + (i * 4).toString()};
				items[i] = item;
				DataProviderText[ALL].push("Item " + (i * 4));
			}
			ListDataProvider[ALL] = new ListCollection(items);
			
			TextureList = new List();
			//BackgroundListDataProvider = new ListCollection(items);
			TextureList.typicalItem = {text: "Item 1000"};
			TextureList.dataProvider = ListDataProvider[BACKGROUND];
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.gap = 10;
			verticalLayout.paddingTop = 5;
			verticalLayout.paddingBottom = 5;
			verticalLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_LEFT;
			verticalLayout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			TextureList.layout = verticalLayout;
			TextureList.padding = 5;
			TextureList.y = 100;
			TextureList.height = 400;
			TextureList.width = 200;
			TextureList.itemRendererFactory = function():IListItemRenderer
			{
				var renderer:DefaultListItemRenderer = new DefaultListItemRenderer();

				//enable the quick hit area to optimize hit tests when an item
				//is only selectable and doesn't have interactive children.
				renderer.isQuickHitAreaEnabled = true;

				renderer.labelField = "text";
				return renderer;
			};
			TextureList.addEventListener(Event.CHANGE, TextureListChangHandler);
			PanelLeft.addChild(TextureList);
			
			DrawShapeLabel = new Label();
			DrawShapeLabel.text = "Shape:";
			DrawShapeLabel.x = 10;
			DrawShapeLabel.y = 510;
			PanelLeft.addChild(DrawShapeLabel);
			
			QuadButton = new Button();
			QuadButton.width = 80;
			QuadButton.height = 25;
			QuadButton.label = "Quad";
			QuadButton.name = "Quad";
			QuadButton.x = 10;
			QuadButton.y = 530;
			QuadButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(QuadButton);
			
			RectButton = new Button();
			RectButton.width = 80;
			RectButton.height = 25;
			RectButton.label = "Rectangle";
			RectButton.name = "Rectangle";
			RectButton.x = 10;
			RectButton.y = 560;
			RectButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(RectButton);
			
			PolyButton = new Button();
			PolyButton.width = 80;
			PolyButton.height = 25;
			PolyButton.label = "Polygon";
			PolyButton.name = "Polygon";
			PolyButton.x = 10;
			PolyButton.y = 590;
			PolyButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(PolyButton);
			
			CircleButton = new Button();
			CircleButton.width = 70;
			CircleButton.height = 25;
			CircleButton.label = "Circle";
			CircleButton.name = "Circle";
			CircleButton.x = 100;
			CircleButton.y = 530;
			CircleButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(CircleButton);
			
			EllipseButton = new Button();
			EllipseButton.width = 70;
			EllipseButton.height = 25;
			EllipseButton.label = "Ellipse";
			EllipseButton.name = "Ellipse";
			EllipseButton.x = 100;
			EllipseButton.y = 560;
			EllipseButton.addEventListener(Event.TRIGGERED, onShapeButtonTriggered);
			PanelLeft.addChild(EllipseButton);
		}
		
		private function TextureListChangHandler(e:Event):void 	{
			
		}
		
		private function onSearchTextChange(e:Event):void {
			SearchListDataProvider.removeAll();
			SearchListDataProviderIndex.length = 0;
			var CurrentTab:int = TextureTab.selectedIndex;
			var SeachtText:String = searchInput.text.toLowerCase();
			trace(DataProviderText[CurrentTab]);
			for (var i = 0; i < ListDataProvider[CurrentTab].length ; i++) {
				if (DataProviderText[CurrentTab][i].toLowerCase().indexOf(SeachtText) != -1) {
					SearchListDataProviderIndex.push(i);
				}
			}
			trace(SearchListDataProviderIndex);
			for (var i = 0; i < SearchListDataProviderIndex.length ; i++) {
				SearchListDataProvider.addItem(ListDataProvider[CurrentTab].getItemAt(SearchListDataProviderIndex[i]));
			}
			TextureList.dataProvider = SearchListDataProvider;
			trace(searchInput.text);
		}
		
		public function initRightPanel():void {
			PanelRight = new Sprite();
			PanelRightBackground = new Quad(300, 700, 0x7a7669);
			PanelRight.addChild(PanelRightBackground);
			PanelRight.x = 675;
			this.addChild(PanelRight);
			
			PropertiesLabel = new Label();
			PropertiesLabel.text = "Properties:";
			PropertiesLabel.x = PropertiesLabel.y = 10;
			PanelRight.addChild(PropertiesLabel);
			
			
		}
		
		public function StarlingImageProperTies():void {
			VariableName = new Label();
			VariableName.text = "Variable Name:";
			VariableName.x = 10;
			VariableName.y = 30;
			PanelRight.addChild(VariableName);
			
			VariableNameInput = new TextInput();
			VariableNameInput.prompt = "Variable Name";
			VariableNameInput.x = 120;
			VariableNameInput.y = 25;
			PanelRight.addChild(VariableNameInput);
			
			CoordXLabel = new Label();
			CoordXLabel.text = "X:                    px";
			CoordXLabel.x = 35;
			CoordXLabel.y = 60;
			PanelRight.addChild(CoordXLabel);
			
			CoordXInput = new TextInput();
			CoordXInput.prompt = "";
			CoordXInput.x = 50;
			CoordXInput.y = 55;
			CoordXInput.maxChars = 4;
			CoordXInput.restrict = "0-9";
			CoordXInput.width = 50;
			PanelRight.addChild(CoordXInput);
			
			CoordYLabel = new Label();
			CoordYLabel.text = "Y:                    px";
			CoordYLabel.x = 180;
			CoordYLabel.y = 60;
			PanelRight.addChild(CoordYLabel);
			
			CoordYInput = new TextInput();
			CoordYInput.prompt = "";
			CoordYInput.x = 195;
			CoordYInput.y = 55;
			CoordYInput.maxChars = 4;
			CoordYInput.restrict = "0-9";
			CoordYInput.width = 50;
			PanelRight.addChild(CoordYInput);
			
			widthLabel = new Label();
			widthLabel.text = "width:                    px";
			widthLabel.x = 10;
			widthLabel.y = 90;
			PanelRight.addChild(widthLabel);
			
			widthInput = new TextInput();
			widthInput.prompt = "";
			widthInput.x = 50;
			widthInput.y = 85;
			widthInput.maxChars = 4;
			widthInput.restrict = "0-9";
			widthInput.width = 50;
			PanelRight.addChild(widthInput);
			
			heightLabel = new Label();
			heightLabel.text = "height:                    px";
			heightLabel.x = 150;
			heightLabel.y = 90;
			PanelRight.addChild(heightLabel);
			
			heightInput = new TextInput();
			heightInput.prompt = "";
			heightInput.x = 195;
			heightInput.y = 85;
			heightInput.maxChars = 4;
			heightInput.restrict = "0-9";
			heightInput.width = 50;
			PanelRight.addChild(heightInput);
			
			PivotX = new Label();
			PivotX.text = "PivotX";
			PivotX.x = 10;
			PivotX.y = 120;
			PanelRight.addChild(PivotX);
			
			PivotXToggleRadioGroup = new ToggleGroup();
			PivotXToggleRadioGroup.addEventListener(Event.CHANGE, PivotXChangeToggle);
			
			PivotXToggleRadioContainer = new LayoutGroup();
			PivotXToggleRadioContainer.x = 55;
			PivotXToggleRadioContainer.y = 115;
			PanelRight.addChild(PivotXToggleRadioContainer);
			
			PivotXLeft = new Radio();
			PivotXLeft.label = "Left";
			PivotXToggleRadioGroup.addItem(PivotXLeft);
			PivotXToggleRadioContainer.addChild(PivotXLeft);
			
			PivotXMiddle = new Radio();
			PivotXMiddle.label = "Middle";
			PivotXMiddle.x = 50;
			PivotXToggleRadioGroup.addItem(PivotXMiddle);
			PivotXToggleRadioContainer.addChild(PivotXMiddle);
			
			PivotXRight = new Radio();
			PivotXRight.label = "Right";
			PivotXRight.x = 120;
			PivotXToggleRadioGroup.addItem(PivotXRight);
			PivotXToggleRadioContainer.addChild(PivotXRight);
			
			PivotY = new Label();
			PivotY.text = "PivotY";
			PivotY.x = 10;
			PivotY.y = 140;
			PanelRight.addChild(PivotY);
			
			PivotXToggleRadioGroup.selectedIndex = 1;
			
			PivotYToggleRadioGroup = new ToggleGroup();
			PivotYToggleRadioGroup.addEventListener(Event.CHANGE, PivotYChangeToggle);
			
			PivotYToggleRadioContainer = new LayoutGroup();
			PivotYToggleRadioContainer.x = 55;
			PivotYToggleRadioContainer.y = 135;
			PanelRight.addChild(PivotYToggleRadioContainer);
			
			PivotYTop = new Radio();
			PivotYTop.label = "Top";
			PivotYToggleRadioGroup.addItem(PivotYTop);
			PivotYToggleRadioContainer.addChild(PivotYTop);
			
			PivotYMiddle = new Radio();
			PivotYMiddle.label = "Middle";
			PivotYMiddle.x = 50;
			PivotYToggleRadioGroup.addItem(PivotYMiddle);
			PivotYToggleRadioContainer.addChild(PivotYMiddle);
			
			PivotYBottom = new Radio();
			PivotYBottom.label = "Bottom";
			PivotYBottom.x = 120;
			PivotYToggleRadioGroup.addItem(PivotYBottom);
			PivotYToggleRadioContainer.addChild(PivotYBottom);
			
			PivotYToggleRadioGroup.selectedIndex = 1;
			
			AlphaLabel = new Label();
			AlphaLabel.text = "Alpha :";
			AlphaLabel.x = 10;
			AlphaLabel.y = 170;
			PanelRight.addChild(AlphaLabel);
			
			AlphaSlider = new Slider();
			AlphaSlider.x = 110;
			AlphaSlider.y = 170;
			AlphaSlider.width = 100;
			AlphaSlider.height = 20;
			AlphaSlider.direction = Slider.DIRECTION_HORIZONTAL;
			AlphaSlider.minimum = 0;
			AlphaSlider.maximum = 1;
			AlphaSlider.value = 1;
			AlphaSlider.step = 0.01;
			AlphaSlider.page = 100;
			AlphaSlider.liveDragging = true;
			AlphaSlider.addEventListener(Event.CHANGE, AlphaChangeHandler);
			PanelRight.addChild(AlphaSlider);
			
			AlphaInput = new TextInput();
			AlphaInput.prompt = "";
			AlphaInput.x = 55;
			AlphaInput.y = 165;
			AlphaInput.maxChars = 4;
			AlphaInput.restrict = "0-9.";
			AlphaInput.width = 50;
			AlphaInput.text = String(AlphaSlider.value);
			PanelRight.addChild(AlphaInput);
			
			colorPicker = new ColorPicker();
			ColorPicker._Designer = this;
			colorPicker.x = 160;
			colorPicker.y = 195;
			PanelRight.addChild(colorPicker);
			
			ColorLabel = new Label();
			ColorLabel.text = "Color :";
			ColorLabel.x = 10;
			ColorLabel.y = 200;
			PanelRight.addChild(ColorLabel);
			
			ColorInput = new TextInput();
			ColorInput.prompt = "0";
			ColorInput.x = 50;
			ColorInput.y = 195;
			ColorInput.maxChars = 8;
			ColorInput.restrict = "0-9xabcdef";
			ColorInput.width = 100;
			ColorInput.addEventListener(Event.CHANGE, onColorInputTextChange);
			PanelRight.addChild(ColorInput);
			
		}
		
		private function onColorInputTextChange(e:Event):void 
		{
			colorPicker.value = uint(ColorInput.text);
		}
		
		private function AlphaChangeHandler(e:Event):void 
		{
			AlphaInput.text = String(AlphaSlider.value);
		}
		
		private function PivotYChangeToggle(e:Event):void 
		{
			
		}
		
		private function PivotXChangeToggle(e:Event):void 
		{
			
		}
		
		//init Sheet and Cam for Sheet
		public function initSheet():void
		{
			Sheet = new SpriteSheet();
			this.addChild(Sheet);
			Sheet.x = 425;
			Sheet.y = 300;
			Sheet.scale = Sheet.currentScale = .4;
		}
	
	}

}