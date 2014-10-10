package components
{
	import flash.system.Capabilities;
	import mx.events.FlexEvent;
	import mx.graphics.SolidColorStroke;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Image;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.components.supportClasses.ItemRenderer;
	import spark.core.ContentCache;
	import spark.primitives.BitmapImage;
	import spark.primitives.Line;
	public class MenuItem extends ItemRenderer
	{
		static public const s_imageCache:ContentCache = new ContentCache();
		public var v1:VGroup = new VGroup();
		public var addedallitems:Boolean = false;
		public var gapo:uint = 4;
		public var subvalue:uint = 25;
		public function MenuItem()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, init);
			this.addEventListener(FlexEvent.DATA_CHANGE, dchange);
		}
		public function init(event:FlexEvent):void {
			var neededwidth:Number = this.parent.width/2-gapo;
			v1.width = neededwidth;
			v1.percentHeight = 100;
			v1.gap = 0;
			v1.mouseEnabled = false;
			this.addElement(v1);
			if ((data.viz == true)&&(addedallitems == false)){
				if (data.name == "Loading More Items"){
					var ll:Label = new Label();
					ll.width = neededwidth;
					ll.horizontalCenter = 0;
					ll.top = 50/(320/Capabilities.screenDPI);
					ll.styleName = styleManager.getStyleDeclaration("textsize3");
					ll.setStyle("color",0x36ccba);
					ll.text = data.name;
					v1.addElement(ll);
				}
				else if (data.name == "catsep"){
					var l4:Label = new Label();
					l4.width = neededwidth-(20/(320/Capabilities.screenDPI));
					l4.setStyle("paddingTop",20/(320/Capabilities.screenDPI));
					l4.setStyle("fontWeight","bold");
					l4.height = neededwidth;
					l4.width = neededwidth;
					l4.horizontalCenter = 0;
					l4.verticalCenter = 0;
					l4.styleName =  "textsize10";
					l4.setStyle("color","#36ccba");
					l4.text = data.catname;
					l4.maxDisplayedLines = 5;
					l4.setStyle("verticalAlign","middle");
					l4.setStyle("textAlign","center");
					v1.addElement(l4);
				}
				else {
					loadrest();
				}
			}
		}
		public function dchange(event:FlexEvent):void {
			if (data != null){
				var neededwidth:Number = this.parent.width/2-gapo;
				if ((data.viz == true)&&(addedallitems == false)){
					if (data.name == "Loading More Items"){
						
					}
					else if (data.name == "catsep"){
						
					}
					else {
						loadrest();
					}
				}
				else {
					v1.removeAllElements();
					addedallitems = false;
					if (data.viz){
						if (data.name == "Loading More Items"){
							var ll:Label = new Label();
							ll.width = neededwidth;
							ll.horizontalCenter = 0;
							ll.top = 50/(320/Capabilities.screenDPI);
							ll.styleName = styleManager.getStyleDeclaration("textsize3");
							ll.setStyle("color",0x36ccba);
							ll.text = data.name;
							v1.addElement(ll);
						}
						else if (data.name == "catsep"){
							var l4:Label = new Label();
							l4.width = neededwidth-(20/(320/Capabilities.screenDPI));
							l4.setStyle("paddingTop",20/(320/Capabilities.screenDPI));
							l4.setStyle("fontWeight","bold");
							l4.height = neededwidth;
							l4.width = neededwidth;
							l4.horizontalCenter = 0;
							l4.verticalCenter = 0;
							l4.styleName =  "textsize10";
							l4.setStyle("color","#36ccba");
							l4.text = data.catname;
							l4.maxDisplayedLines = 5;
							l4.setStyle("verticalAlign","middle");
							l4.setStyle("textAlign","center");
							v1.addElement(l4);
						}
						else {
							loadrest();
						}
					}
					
				}
			}
		}
		public function loadrest():void {
			var neededwidth:Number = this.parent.width/2-gapo;
			if (addedallitems == false){
				addedallitems = true;
				var bmpImg:BitmapImage = new BitmapImage();
				if ((data.picture == "None")||(data.picture == "")||(data.picture == null)||(data.picture == "null")){
					bmpImg.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";
				}
				else if (data.picture.indexOf("dish") != -1){
					bmpImg.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";
				}
				else {
					bmpImg.source = data.picture;
				}
				bmpImg.contentLoader = s_imageCache;
				bmpImg.width = neededwidth;
				bmpImg.height = neededwidth/(3/2);
				v1.addElement(bmpImg);
				
				var hg:HGroup = new HGroup();
				hg.horizontalAlign = "center";
				hg.paddingTop = 0; 
				hg.percentWidth = 100;
				hg.maxWidth = neededwidth;
				hg.gap = 0;
				hg.verticalAlign = "middle";
				
				
				
				
				var stroke1:SolidColorStroke = new SolidColorStroke();
				stroke1.color = 0xe6e6e6;
				stroke1.weight = 1/(320/Capabilities.screenDPI);
				var line1:Line = new Line();
				line1.right = 0;
				line1.left = 0;
				line1.bottom = 0;
				line1.stroke = stroke1;
				var line2:Line = new Line();
				line2.top = 0;
				line2.bottom = 0;
				line2.right = 0;
				line2.stroke = stroke1;
				line2.rotation = 90;
				var line3:Line = new Line();
				line3.right = 0;
				line3.left = 0;
				line3.bottom = 0;
				line3.stroke = stroke1;
				var line4:Line = new Line();
				line4.top = 0;
				line4.bottom = 0;
				line4.right = 0;
				line4.stroke = stroke1;
				line4.rotation = 90;
				var line5:Line = new Line();
				line5.right = 0;
				line5.left = 0;
				line5.bottom = 0;
				line5.stroke = stroke1;
				var line6:Line = new Line();
				line6.top = 0;
				line6.bottom = 0;
				line6.right = 0;
				line6.stroke = stroke1;
				line6.rotation = 90;
				
				var g1:Group = new Group();
				g1.width = neededwidth/3;
				g1.height = 50/(320/Capabilities.screenDPI);
				var l1:Label = new Label();
				l1.setStyle("textAlign","center");
				l1.horizontalCenter = 0;
				l1.verticalCenter = 0;
				l1.styleName = "textsize1";
				l1.setStyle("fontWeight","bold");
				l1.setStyle("color","#36ccba");
				var ratingstring:String =data.rating.toString();
				var ratingnumber:Number = Number(data.rating);
				if (ratingnumber == 0){
					l1.text = "-";
				}
				else if (ratingnumber >= 10){
					ratingnumber = 10;
					l1.text = "10";
				}
				else {
					l1.text = ratingnumber.toPrecision(2).toString();
				}
				g1.addElement(line1);
				g1.addElement(line2);
				g1.addElement(l1);
				
				
				var g2:Group = new Group();
				g2.width = neededwidth/3;
				g2.height = 50/(320/Capabilities.screenDPI);
				var l2:Label = new Label();
				l2.setStyle("textAlign","center");
				l2.horizontalCenter = 0;
				l2.verticalCenter = 0;
				l2.styleName = "textsize0";
				l2.setStyle("color","#999999");
				l2.text = "  $"+Number(data.cost).toFixed(2);
				g2.addElement(line3);
				g2.addElement(line4);
				g2.addElement(l2);
				
				var g3:Group = new Group();
				g3.width = neededwidth/3;
				g3.height = 50/(320/Capabilities.screenDPI);
				var l3:Label = new Label();
				l3.setStyle("textAlign","center");
				l3.horizontalCenter = 0;
				l3.verticalCenter = 0;
				l3.styleName =  "textsize0";
				l3.setStyle("color","#999999");
				if (data.goodforme == false){
					var bmpImg2:Image = new Image();
					bmpImg2.source = "../assets/"+getDPIHeight().toString()+"/alertlarge.png";
					bmpImg2.right = 20/(320/Capabilities.screenDPI);
					bmpImg2.verticalCenter = 0;
					//bmpImg2.contentLoader = s_imageCache;
					g3.addElement(bmpImg2);
				}
				
				
				
				
				g3.addElement(line5);
				
				
				
				hg.addElement(g1);
				hg.addElement(g2);
				hg.addElement(g3);
				
				var v2:VGroup = new VGroup();
				v2.width = neededwidth;
				v2.gap = 8/(320/Capabilities.screenDPI);
				v2.paddingTop = 18/(320/Capabilities.screenDPI);
				v2.paddingBottom = 10/(320/Capabilities.screenDPI);
				
				var l4:Label = new Label();
				l4.width = neededwidth-(20/(320/Capabilities.screenDPI));
				l4.setStyle("paddingLeft",20/(320/Capabilities.screenDPI));
				l4.setStyle("fontWeight","bold");
				l4.horizontalCenter = 0;
				l4.verticalCenter = 0;
				l4.styleName =  "textsize1";
				l4.setStyle("color","#36ccba");
				l4.text = data.name;
				l4.maxDisplayedLines = 1;
				l4.setStyle("verticalAlign","middle");
				
				
				
				var g4:Group = new Group();
				g4.width = neededwidth;
				
				var l6:Label = new Label();
				l6.width = neededwidth-(20/(320/Capabilities.screenDPI));
				l6.setStyle("paddingLeft",10/(320/Capabilities.screenDPI));
				l6.setStyle("fontWeight","bold");
				l6.horizontalCenter = 0;
				l6.verticalCenter = 0;
				l6.left = 0;
				l6.styleName =  "textsize0";
				l6.setStyle("color","#4d4d4d");
				l6.text = data.categoryname;
				l6.maxDisplayedLines = 1;
				l6.setStyle("verticalAlign","middle");
				
				v2.addElement(l4);
				g4.addElement(l6);
				
				v2.addElement(g4);
				
				v1.addElement(hg);
				v1.addElement(v2);
				
			}	
		}
		public function getDPIHeight():Number {
			var _runtimeDPI:int;
			if(Capabilities.screenDPI < 200){
				_runtimeDPI = 160;
			}
			else if(Capabilities.screenDPI >=200 && Capabilities.screenDPI <= 240){
				_runtimeDPI = 240
			}
			else if (Capabilities.screenDPI < 480){
				_runtimeDPI = 320;
			}
			else if (Capabilities.screenDPI < 640){
				_runtimeDPI = 480;
			}
			else if (Capabilities.screenDPI >=640){
				_runtimeDPI = 640;
			}
			return(_runtimeDPI)
		}	
	}
}