package components
{
	import flash.system.Capabilities;
	
	import mx.events.FlexEvent;
	import mx.graphics.SolidColor;
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
	import spark.primitives.Rect;
	
	public class MenuItem extends ItemRenderer
	{
		static public const s_imageCache:ContentCache = new ContentCache();
		public var v1:VGroup = new VGroup();
		public var addedallitems:Boolean = false;
		public var gapo:uint = 4;
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
					l4.height = neededwidth+30;
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
							l4.height = neededwidth+30;
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
				var rc7:Rect = new Rect();
				var gg1:Group = new Group();
				gg1.width = neededwidth;
				gg1.height = neededwidth/(3/2);
				addedallitems = true;
				var bmpImg:BitmapImage = new BitmapImage();
				if ((data.picture == "None")||(data.picture == "")||(data.picture == null)||(data.picture == "null")){
					bmpImg.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";
					rc7.fill = new SolidColor(0x4d4d4d, 0.95);
				}
				else if (data.picture.indexOf("dish") != -1){
					bmpImg.source = "assets/"+getDPIHeight().toString()+"/dish_place_wide.png";
					rc7.fill = new SolidColor(0x4d4d4d, 0.95);
				}
				else {
					bmpImg.source = data.picture;
					rc7.fill = new SolidColor(0xc4c4c4, 0.95);
				}
				bmpImg.contentLoader = s_imageCache;
				bmpImg.width = neededwidth;
				bmpImg.height = neededwidth/(3/2);
				bmpImg.top = 0;
				bmpImg.scaleMode = "zoom";
				gg1.addElement(bmpImg);
				
				var gr6:Group = new Group();
				var rc6:Rect = new Rect();
				rc6.fill = new SolidColor(0x36ccba, 0.95);
				rc6.percentHeight = 100;
				rc6.percentWidth = 100;
				rc6.radiusX =9;
				rc6.radiusY = 9;
				var l1:Label = new Label();
				l1.setStyle("textAlign","center");
				l1.horizontalCenter = 0;
				l1.verticalCenter = 3;
				l1.styleName = "textsize0";
				l1.setStyle("fontWeight","bold");
				l1.setStyle("color","#ffffff");
				l1.setStyle("paddingLeft",15);
				l1.setStyle("paddingRight",15);
				l1.setStyle("paddingBottom",5);
				l1.setStyle("paddingTop",5);
				var ratingstring:String =unescape(data.rating.toString());
				var ratingnumber:Number = Number(unescape(data.rating));
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
				gr6.addElement(rc6);
				gr6.addElement(l1);
				
				var gr7:Group = new Group();
				
				rc7.radiusX = 9;
				rc7.radiusY = 9;
				
				rc7.percentHeight = 100;
				rc7.percentWidth = 100;
				var l2:Label = new Label();
				l2.setStyle("textAlign","center");
				l2.horizontalCenter = 0;
				l2.setStyle("paddingLeft",10);
				l2.setStyle("paddingRight",10);
				l2.setStyle("paddingBottom",5);
				l2.setStyle("paddingTop",5);
				l2.verticalCenter = 3;
				l2.styleName = "textsize0";
				l2.setStyle("color","#ffffff");
				
				var tempText:String = Number(data.cost).toFixed(2);
				try{
					if (tempText.substr(tempText.length-2,tempText.length) == "00"){
						tempText = tempText.substr(0,tempText.length-3);
					}
				}
				catch(e:Error){
					
				}
				l2.text =  "$"+tempText;
				
				gr7.addElement(rc7);
				gr7.addElement(l2);
				
				var hg2:HGroup = new HGroup();
				hg2.paddingLeft = 15;
				hg2.gap = 15;
				hg2.addElement(gr6);
				hg2.addElement(gr7);
				hg2.bottom = 15;
				gg1.addElement(hg2)
				v1.addElement(gg1);
				
				
				var tempdisttext:String = "";
				if ((data.distance != '')&&(data.distance != 'null')&&(data.distance != null)){
					var dist:Number = data.distance;
					if (dist >= 1){
						tempdisttext = dist.toFixed(1)+ " km";
					}
					else {
						dist = dist * 1000;
						tempdisttext = dist.toFixed(0)+ " m";
					}
				}
				else {
					tempdisttext = "";
				}
				
				var v2:VGroup = new VGroup();
				v2.width = neededwidth;
				v2.gap = 8/(320/Capabilities.screenDPI);
				v2.paddingTop = 18/(320/Capabilities.screenDPI);
				v2.paddingBottom = 10/(320/Capabilities.screenDPI);
				
				var l4:Label = new Label();
				l4.width = neededwidth-(20/(320/Capabilities.screenDPI));
				l4.setStyle("fontWeight","bold");
				l4.horizontalCenter = 0;
				l4.verticalCenter = 0;
				l4.styleName =  "textsize1";
				l4.setStyle("color","#4d4d4d");
				l4.text = data.name;
				l4.maxDisplayedLines = 1;
				l4.percentHeight = 100;
				l4.setStyle("verticalAlign","middle");
				
			
				
		
				var l6:Label = new Label();
				l6.maxWidth = neededwidth;
				l6.horizontalCenter = 0;
				l6.verticalCenter = 0;
				l6.setStyle("paddingLeft",20/(320/Capabilities.screenDPI));
				l6.left = 0;
				l6.styleName =  "textsize0";
				l6.setStyle("color","#4d4d4d");
				l6.text = data.categoryname;
				l6.maxDisplayedLines = 1;
				l6.setStyle("verticalAlign","middle");
				
			
				
				var hg4:HGroup = new HGroup();
				hg4.gap = 5/(320/Capabilities.screenDPI);
				hg4.paddingLeft = 20/(320/Capabilities.screenDPI);
				hg4.verticalAlign = "middle";
				hg4.verticalCenter = 0;
				if (data.goodforme == false){
					var bmpImg2:Image = new Image();
					bmpImg2.source = "../assets/"+getDPIHeight().toString()+"/alertlarge.png";
					bmpImg2.contentLoader = s_imageCache;
					hg4.addElement(bmpImg2);
				}
				hg4.addElement(l4);
				v2.addElement(hg4);
				v2.addElement(l6);
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
			return(_runtimeDPI);
		}
	}
}