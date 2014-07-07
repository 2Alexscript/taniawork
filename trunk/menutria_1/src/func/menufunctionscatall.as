import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.GeolocationEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.filesystem.File;
import flash.geom.ColorTransform;
import flash.geom.Rectangle;
import flash.html.HTMLLoader;
import flash.net.URLRequest;
import flash.sensors.Geolocation;
import events.ActionEvent;
import spark.components.SplitViewNavigator;
import spark.components.ViewNavigator;
import spark.containers.Navigator;
import views.restrictionThinList;
import views.menuThinList;
import views.menuFullList;
import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.effects.effectClasses.FadeInstance;
import mx.events.FlexEvent;
import mx.events.PropertyChangeEvent;
import mx.events.ResizeEvent;
import mx.rpc.events.ResultEvent;
import spark.collections.SortField;
import spark.components.supportClasses.StyleableTextField;
import spark.core.ContentCache;
import spark.effects.Fade;
import spark.events.IndexChangeEvent;
import spark.events.ListEvent;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;
[Bindable]
public var actions:ArrayCollection;
[Bindable]
private var _addrString:String;
[Bindable]
private var _distString:String;
[Bindable]
public var googleTravelUrl:String = "";
protected var g:Geolocation = new Geolocation();    
[Bindable]
public var radiusOptions:ArrayCollection = new ArrayCollection();
[Bindable]
public var sortMode:Number = 0;
[Bindable]
public var reverse:Boolean = false;
[Bindable]
public var emailGo:String = "none";
[Bindable]
public var locatoinidGo:Number = -1;
[Bindable]
public var busy:Boolean = true;
[Bindable]
public var currentselectmode:Number = 0;
[Bindable]
public var listData:ArrayCollection = new ArrayCollection();
[Bindable]
public var resData:ArrayCollection = new ArrayCollection();
[Bindable]
public var modData:ArrayCollection = new ArrayCollection();
[Bindable]
public var backuplistdata:ArrayCollection = new ArrayCollection();
[Bindable]
public var ratingpriceoptionval:uint = 0;
[Bindable]
public var filterData1:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData2:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData3:ArrayCollection = new ArrayCollection();
[Bindable]
public var filterData4:ArrayCollection = new ArrayCollection();

protected function init():void
{
	
	setLoginVars();
	
	filterData1 = new ArrayCollection();
	filterData2 = new ArrayCollection();
	filterData3 = new ArrayCollection();
	filterData1.addItem({name:"All"});
	filterData2.addItem({name:"Highest"});
	filterData2.addItem({name:"Lowest"});
	filterData3.addItem({name:"Highest"});
	filterData3.addItem({name:"Lowest"});	
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS resvalues (" +
		"id int(255)," +
		"name longtext," +
		"chosen  varchar(255))";							
	stmt.execute();
	
	
	showloading();
	warn.visible = false;
	busy = true;
	emailGo = "guest";
	getMenu.send();
	filterarea.visible = true;
	widepic.visible = true;
}	

public function afterGetMenu(ev:ResultEvent):void
{	
	busy = false;
	hideloading();
	listData = new ArrayCollection();
	modData = new ArrayCollection();
	resData = new ArrayCollection();
	
	try{			
		listData = ev.result[0].ress.res;		
	}
	catch(e:Error){
		try{	
			listData.addItem(ev.result[0].ress.res);
		}
		catch(e:Error){}
	}
	
	try{			
		resData = ev.result[0].ress2.res2;		
	}
	catch(e:Error){
		try{	
			resData.addItem(ev.result[0].ress2.res2);
		}
		catch(e:Error){}
	}
	
	try{			
		modData = ev.result[0].ress3.res3;		
	}
	catch(e:Error){
		try{	
			modData.addItem(ev.result[0].ress3.res3);
		}
		catch(e:Error){}
	}
	afterGetMenuCont();
	
}
public function afterGetMenuCont():void {
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT * FROM resvalues";
	stmt.execute();
	var resvaluesData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	
	
	if (resvaluesData.length > 0){
		for (var j:uint = 0; j < listData.length; j++){
			var goodstatus:Number = 0;
			var permabad:Boolean = false;
			for (var k:uint = 0; k < resData.length; k++){
				if (resData[k].menuid == listData[j].id){
					for (var i:uint = 0; i<resvaluesData.length; i++){
						if ((resvaluesData[i].id == resData[k].restrictid)&&(resvaluesData[i].chosen == 'yes')){
							goodstatus = 1;
							for (var l:uint = 0; l < modData.length; l++){
								if ((resvaluesData[i].id == modData[l].restrictid)&&(modData[l].menuid == resData[k].menuid)){
									//show it but add warning
									if (resData[k].menuid == "286"){
										var stp:String = "";
									}
									goodstatus = 2;
								}
							}
							
							if (goodstatus == 1){
								permabad = true;
								if (resData[k].menuid == "286"){
									var stpre:String = "";
								}
							}
						}
					}
				}
			}
			

			if (permabad){
				//no mod for an item so its bad
				listData[j].hideall = true;
				listData[j].goodforme = false;
			}
			else if (goodstatus == 2){
				// a mod exsists to a restriction so just add warning
				listData[j].hideall = false;
				listData[j].goodforme = false;
			}
			else {
				//all good show away. 
				listData[j].hideall = false;
				listData[j].goodforme = true;
			}
			
			
		}
		
		listData.refresh();
		menuList.dataProvider = listData;
		
	}
	
	
	if (listData.length <= 0){
		warn.visible = true;
	}
	else {
		/*for (var i:uint = 0; i < listData.length; i++){
			listData[i].business_name = data.business_name;
		}*/
		filterList1.visible = true;
		filterList2.visible = false;
		filterList3.visible = false;
		
		selectview1.alpha = 1;
		selectview2.alpha = 0;
		selectview3.alpha = 0;
		
		
		selectview1.mouseEnabled = true;
		selectview1.mouseEnabledWhereTransparent = true;
		
		selectview2.mouseEnabled = false;
		selectview2.mouseEnabledWhereTransparent = false;
		
		selectview3.mouseEnabled = false;
		selectview3.mouseEnabledWhereTransparent = false;
		generateCategoryFilterArray();
		populatelist(0);
	}
	
} 
public function generateCategoryFilterArray():void {
	var tempfilter2:ArrayCollection = new ArrayCollection();
	if (listData.length > 0){
		for (var i:uint =  0; i < listData.length; i++){
			var tempfail:Boolean = false;
			for (var j:uint = 0; j < tempfilter2.length; j++){
				if (tempfilter2[j].name == listData[i].categoryname){
					tempfail = true;
				}
			}
			if (tempfail == false){
				tempfilter2.addItem({name:listData[i].categoryname});
			}
			
		}
	}
	
	var filtercatsf:SortField = new SortField();
	filtercatsf.name = "name";
	filtercatsf.numeric = false;
	var fcst:Sort = new Sort();
	fcst.fields = [filtercatsf];
	tempfilter2.sort = fcst;
	tempfilter2.refresh();
	
	
	filterData1 = new ArrayCollection();
	filterData1.addItem({name:"All"});
	for (var k:uint = 0; k < tempfilter2.length; k++){
		filterData1.addItem({name:tempfilter2[k].name});
	}
}
public function populatelist(u:uint):void {
	var srt:Sort = new Sort();
	if ((u == 1)||(u==0)){
		srt.fields = [new SortField("categoryname")];
		listData.sort = srt;
		listData.refresh();
		var lastcat:String = "";
		for (var i:uint = 0; i < listData.length; i++){
			if ((listData[i].categoryname.toLowerCase() != lastcat)||(lastcat == "")){
				listData[i].divtype = 1;
			}
			else {
				listData[i].divtype = 0;
				
			}
			lastcat = listData[i].categoryname.toLowerCase();
		}
	}
	else if (u == 2){
		srt.fields = [new SortField("rating",!reverse,true)];
		listData.sort = srt;
		listData.refresh();
		for (var i:uint = 0; i < listData.length; i++){
			listData[i].divtype = 0;
		}
	}
	else if (u == 3){
		srt.fields = [new SortField("cost",!reverse,true)];
		listData.sort = srt;
		listData.refresh();
		for (var i:uint = 0; i < listData.length; i++){
			listData[i].divtype = 0;
		}
	}
	else if (u == 33){
		srt.fields = [new SortField("categoryname")];
		listData.sort = srt;
		listData.refresh();
		var lastcat:String = "";
		
		
		for (var i:uint = 0; i < listData.length; i++){
			if ((listData[i].categoryname.toLowerCase() != lastcat)||(lastcat == "")){
				listData[i].divtype = 1;
			}
			else {
				listData[i].divtype = 0;
				
			}
			lastcat = listData[i].categoryname.toLowerCase();
		}
	}
	menuList.dataProvider = listData;	
}
public var doneonece:Boolean = false;
public function menuListClick():void {	
			var splitNavigator:SplitViewNavigator = navigator.parentNavigator as SplitViewNavigator;
			var detailNavigator:ViewNavigator = splitNavigator.getViewNavigatorAt(1) as ViewNavigator;
			var sidebarnav:ViewNavigator = splitNavigator.getViewNavigatorAt(0) as ViewNavigator;
			detailNavigator.pushView(dishFullView, {selectedData:listData[menuList.selectedIndex]});
			if (detailNavigator.activeView.title == "Menu"){
				sidebarnav.pushView(menuThinList);
			}
}
public function searchClick():void
{
	listData.filterFunction = filterCompleted;
	listData.refresh();
	menuList.dataProvider = listData;
	
}
private function filterCompleted(item:Object):Boolean{
	//if((item.cost.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)||
	//(item.name.toString().toLowerCase().indexOf(key.text.toLowerCase()) != -1)
	//)
	return true;
	//return false;
}
private function returnall(item:Object):Boolean{
	return true;
}


public function goback(ev:MouseEvent):void {
	navigator.popView();
}
public function filterClick(u:uint):void {
	listData.filterFunction = allFilter;
	listData.refresh();
	menuList.dataProvider = listData;
	
	var fadein:Fade = new Fade();
	fadein.alphaFrom = 0;
	fadein.alphaTo = 1;
	fadein.duration = 500;
	
	var fadeout:Fade = new Fade();
	fadeout.alphaFrom = 1;
	fadeout.alphaTo = 0;
	fadeout.duration = 500;
	
	if ((currentselectmode == 1)&&(currentselectmode != u)){
		fadeout.targets = [filterimage1];
	}
	else if ((currentselectmode == 2)&&(currentselectmode != u)){
		fadeout.targets = [filterimage2];
	}
	else if ((currentselectmode == 3)&&(currentselectmode != u)){
		fadeout.targets = [filterimage3];
	}

	if ((u == 1)&&(currentselectmode != u)){
		sv1label.text = "All";
		sv2label.text = "Highest";
		sv3label.text = "Highest";
		filterList1.visible = true;
		filterList2.visible = false;
		filterList3.visible = false;
		
		selectview1.alpha = 1;
		selectview2.alpha = 0;
		selectview3.alpha = 0;
		
		fadein.targets = [filterimage1];
		
		selectview1.mouseEnabled = true;
		selectview1.mouseEnabledWhereTransparent = true;
		
		selectview2.mouseEnabled = false;
		selectview2.mouseEnabledWhereTransparent = false;
		
		selectview3.mouseEnabled = false;
		selectview3.mouseEnabledWhereTransparent = false;
		

		
	}
	else if ((u == 2)&&(currentselectmode != u)){
		sv1label.text = "All";
		sv2label.text = "Highest";
		sv3label.text = "Highest";
		filterList1.visible = false;
		filterList2.visible = true;
		filterList3.visible = false;
		
		selectview1.alpha = 0;
		selectview2.alpha = 1;
		selectview3.alpha = 0;
		
		fadein.targets = [filterimage2];
		
		selectview1.mouseEnabled = false;
		selectview1.mouseEnabledWhereTransparent = false;
		
		selectview2.mouseEnabled = true;
		selectview2.mouseEnabledWhereTransparent = true;
		
		selectview3.mouseEnabled = false;
		selectview3.mouseEnabledWhereTransparent = false;
		
		
	}
	else if ((u == 3)&&(currentselectmode != u)){
		sv1label.text = "All";
		sv2label.text = "Highest";
		sv3label.text = "Highest";
		filterList1.visible = false;
		filterList2.visible = false;
		filterList3.visible = true;
		
		selectview1.alpha = 0;
		selectview2.alpha = 0;
		selectview3.alpha = 1;
		
		fadein.targets = [filterimage3];
		
		selectview1.mouseEnabled = false;
		selectview1.mouseEnabledWhereTransparent = false;
		
		selectview2.mouseEnabled = false;
		selectview2.mouseEnabledWhereTransparent = false;
		
		selectview3.mouseEnabled = true;
		selectview3.mouseEnabledWhereTransparent = true;
		
		
	}

	
	
	if (currentselectmode != u){
		reverse = false;
		fadeout.play();
		fadein.play();
		currentselectmode = u;
		populatelist(currentselectmode);
		
	}
	
	
}
public function goFilterScreen(u:uint,f:uint = 0):void {
	if (clickingsvi == false){
		if (dropDownContainer.visible){
			//close dropdown menu
			var fadeout:Fade = new Fade();
			fadeout.alphaFrom = 1;
			fadeout.alphaTo = 0;
			fadeout.duration = 500;
			fadeout.target = dropDownContainer;
			fadeout.play();
			fadeout.addEventListener(EffectEvent.EFFECT_END, afterdrophide);
		}
		else{
			//show dropdown menu
			if (f == 0){
				var fadein:Fade = new Fade();
				fadein.alphaFrom = 0;
				fadein.alphaTo = 1;
				fadein.duration = 500;
				dropDownContainer.visible = true;
				fadein.target = dropDownContainer;
				fadein.play();
			}
		
		}	
	}
	else {
		clickingsvi = false;
	}
	
}

public function filter1Click():void {
	try{
		sv1label.text = filterList1.selectedItem.name;
		goFilterScreen(1);
		if (sv1label.text == "All"){
			currentselectmode = -1;
			filterClick(1);
			afterGetMenuCont();
		}
		else {
		
			listData.filterFunction = catFilter;
			listData.refresh();
			menuList.dataProvider = listData;
			//add filter here
			currentselectmode = 1
			populatelist(33);
		}
		
	}
	catch(e:Error){
		
	}	
}
private function allFilter(item:Object):Boolean{
	return true;
}
private function catFilter(item:Object):Boolean{
	if (sv1label.text.toLowerCase() == "all"){
		return true;
	}
	else {
		if((item.categoryname.toString().toLowerCase().indexOf(	sv1label.text.toLowerCase()) != -1)){
			return true;
		}	
	}
	return false;
}
public function filter2Click():void {
	if (filterList2.selectedItem.name == "Highest"){
		
		currentselectmode = 2;
		reverse = false;
	}
	else if (filterList2.selectedItem.name == "Lowest"){
		
		currentselectmode = 2;
		reverse = true;
	}
	populatelist(2);
	sv2label.text = filterList2.selectedItem.name;
	goFilterScreen(2);
	
}
public function filter3Click():void {
	
	if (filterList3.selectedItem.name == "Highest"){
		
		currentselectmode = 3;
		reverse = false;
	}
	else if (filterList3.selectedItem.name == "Lowest"){
		
		currentselectmode = 3;
		reverse = true;
	}
	populatelist(3);
	sv3label.text = filterList3.selectedItem.name;
	goFilterScreen(3);
	
}
public var clickingsvi:Boolean = false;
public function svilabelclick():void {
	clickingsvi = true;
	if (dropDownContainer.visible){
		//close dropdown menu
		var fadeout:Fade = new Fade();
		fadeout.alphaFrom = 1;
		fadeout.alphaTo = 0;
		fadeout.duration = 500;
		fadeout.target = dropDownContainer;
		fadeout.play();
		fadeout.addEventListener(EffectEvent.EFFECT_END, afterdrophide);
	}
}
public function afterdrophide(ev:EffectEvent):void {
	dropDownContainer.visible = false;
}