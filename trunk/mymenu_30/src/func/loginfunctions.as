import flash.data.SQLConnection;
import flash.data.SQLStatement;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filesystem.File;
import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.effects.Move;
import mx.events.DragEvent;
import mx.events.EffectEvent;
import mx.events.FlexEvent;
import mx.rpc.events.ResultEvent;
import spark.effects.Fade;
import spark.effects.Scale;
import spark.events.ViewNavigatorEvent;
import spark.filters.GlowFilter;
import spark.managers.PersistenceManager;
import spark.transitions.FlipViewTransition;
import spark.transitions.FlipViewTransitionMode;
import spark.transitions.ViewTransitionDirection;
import views.SpecialsAll;
import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
import pl.mateuszmackowiak.nativeANE.NativeDialogListEvent;
import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
import pl.mateuszmackowiak.nativeANE.dialogs.NativeListDialog;
import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextField;
import pl.mateuszmackowiak.nativeANE.dialogs.NativeTextInputDialog;
import pl.mateuszmackowiak.nativeANE.notification.NativeNotifiction;
import pl.mateuszmackowiak.nativeANE.progress.NativeProgress;
import pl.mateuszmackowiak.nativeANE.properties.SystemProperties;
import pl.mateuszmackowiak.nativeANE.toast.Toast;
[Bindable]
public var currentBalance:String = "$0.00";	
public var profileShown:Boolean = false;
public var chosenMenuOption:uint = 1;
public var profWaiting:Boolean = false;
protected var sqlConnection:SQLConnection;
public var profDraging:Boolean = false;
import spark.core.ContentCache;
import func.GoViralExample;

static public const s_imageCache:ContentCache = new ContentCache();
[Bindable]
public var busy:Boolean = true;
private const FACEBOOK_APP_ID:String = "277005535795275";
//App origin URL
private const FACEBOOK_APP_ORIGIN:String = "http://mymenuapp.ca/facebook";
//Permissions Array
private const PERMISSIONS:Array = ["email","user_birthday","user_location","basic_info",'read_stream', 'publish_stream'];

private var accessToken:String = "";
[Bindable]
public var facebookid:String = "";
public var sentfacebookrequest:Boolean = false;

public function create():void
{	busy = true;
	showloading();
	var stmt:SQLStatement = new SQLStatement();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255)," +
		"active varchar(255))";
	stmt.execute();
	getLocalUsers();
}	
import com.milkmangames.nativeextensions.*;
import com.milkmangames.nativeextensions.events.*;
public function facebookLogin(event:MouseEvent):void
{	
	if(GoViral.isSupported())
	{
		GoViral.create();
	}
	else {
		trace("GoViral only works on mobile!");
		return;
	}
	
	if(GoViral.goViral.isFacebookSupported())
	{
		// replace 000000 with your facebook app id!
		GoViral.goViral.initFacebook(FACEBOOK_APP_ID,"");
		GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_RESPONSE,onFacebookResponse);
		GoViral.goViral.addEventListener(GVFacebookEvent.FB_REQUEST_FAILED,onRequestFailed);
		if(!GoViral.goViral.isFacebookAuthenticated())
		{
			GoViral.goViral.authenticateWithFacebook("basic_info");
		}
		else {
			NativeNotifiction.notifi("Logged into facebook");
		}
	}
	
}
public function onFacebookResponse(e:GVFacebookEvent):void
{
	// the graphPath property is 'me' for a profile request.
	if(e.graphPath=="me")
	{
		var myProfile:GVFacebookFriend=e.friends[0];
		NativeNotifiction.notifi("my name is:"+myProfile.name);
		trace("my name is:"+myProfile.name);
		trace("my gender is:"+myProfile.gender);
		trace("My bio is:"+myProfile.bio);
	}
}
public function onRequestFailed(e:GVFacebookEvent):void
{
	trace("something wenet wrong with the request:"+e.errorMessage);
}
public function loginClick(event:MouseEvent):void
{	
	this.currentState = 'login';
	logWarning.visible = false;
}
public function guestSignIn(event:MouseEvent):void {
	authorizeLogin("guest@guest.com","guest");
}


public function createNewClick(event:MouseEvent):void {
	this.currentState = 'create';
	newlogWarning.visible = false;
}
public function backToLoginOptions():void {
	this.currentState = 'welcome';
	try{
		logWarning.visible = false;
	}
	catch(e:Error){
		
	}
	try{
		newlogWarning.visible = false;
	}
	catch(e:Error){
		
	}
}
public function authorizeLogin(username:String,userpassword:String):void{	
	busy = true;
	userid = username;
	passid = userpassword;
	checkLogin.send();
}
public function afterCheckLogin(ev:ResultEvent):void {
	busy = false;
	if (ev.result[0].res.message == "ok"){
		AddNewLocalUser(ev.result[0].res.email,
			ev.result[0].res.name,
			ev.result[0].res.country);
	}
	else {
		//bad login
		logWarning.text = ev.result[0].res.message;
		logWarning.visible = true;
	}
}
protected function getLocalUsers():void
{
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, country, active FROM localuser";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	
	if (resData.length != 0){
		//good login
		var foundactive:Boolean = false;
		for (var i:uint = 0; i < resData.length; i++){
			if (resData[i].active == "yes"){
				foundactive = true;
				
				try{
					logWarning.visible = false;
				}
				catch(e:Error){
					
				}
				
				try{
					newlogWarning.visible = false;
				}
				catch(e:Error){
					
				}
				try{
					var saveManager:PersistenceManager = new PersistenceManager();
					saveManager.setProperty("useremail", resData[i].email);
					navigator.pushView(Home);	
				}
				catch(e:Error){
					
				}
				
				//this.parentDocument.refresh(resData[i].email);	
			}
			
		}			
	}
	else {
	}
	busy = false;
	hideloading();
}

public function AddNewLocalUser(email:String,name:String,country:String):void
{
	busy = true;
	showloading();
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "delete FROM localuser;";
	stmt.execute();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "INSERT into localuser values(:email,:name,:country,:active)";
	stmt.parameters[":email"] = email;
	stmt.parameters[":name"] = name;
	stmt.parameters[":country"] = country;
	stmt.parameters[":active"] = "yes";
	stmt.execute();
	getLocalUsers();
	
}
public function checkAvailability(username:String,userpassword:String):void {	
	busy = true;
	showloading();
	if ((nemail.text != "")
		&&(nemail.text.indexOf("@") != -1)
		&&(nname.text != "")
		&&(nname2.text != "")
		&&(npassword.text != "")
		&&(npassword2.text != "")
		&&(city.text != "")
		&&(npassword.text == npassword2.text)){
		newlogWarning.visible = false;
		oemail = nemail.text;
		opassword = npassword.text;
		oname1 = nname.text;
		oname2 = nname2.text;
		ocity = city.text;
		oprovince = province.selectedItem.name;
		obirthday = String(dt.selectedDate.day);
		obirthmonth = String(dt.selectedDate.month);
		obirthyear = String(dt.selectedDate.fullYear);
		ogender = gender.selectedValue.toString();
		createNewUser.send();
	}
	else {
		newlogWarning.visible = true;
		busy = false;
		hideloading();
	}	
}
public function afterCreateNewUser(ev:ResultEvent):void {
	busy = false;
	hideloading();
	if (ev.result[0].res.message == "ok"){
		AddNewLocalUser(oemail,
			oname1,
			'canada'
		);
	}
	else {
		newlogWarning.visible = true;
		busy = false;
		newlogWarning.text = ev.result[0].res.message;
	}
}
public function tOver(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","underline");
}
public function tOut(ev:MouseEvent):void {
	ev.currentTarget.setStyle("textDecoration","none");
}
public function gOver(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function gDown(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function gOut(ev:MouseEvent):void {
	ev.currentTarget.alpha = 1;
}
public function profDown(ev:MouseEvent):void {
	ev.currentTarget.alpha = 0.5;
}
public function profUp(ev:MouseEvent):void {
	ev.currentTarget.alpha = 1;
}
protected function view1_viewActivateHandler(event:ViewNavigatorEvent):void
{
	
	navigator.visible = true;
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	stmt = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "CREATE TABLE IF NOT EXISTS localuser (" +
		"email varchar(255)," +
		"name varchar(255)," +
		"country varchar(255)," +
		"active varchar(255))";
	stmt.execute();
	
	sqlConnection = new SQLConnection();
	sqlConnection.open(File.applicationStorageDirectory.resolvePath("localuser.db"));
	var stmt:SQLStatement = new SQLStatement();
	stmt.sqlConnection = sqlConnection;
	stmt.text = "SELECT email, name, country, active FROM localuser where active = 'yes'";
	stmt.execute();
	var resData:ArrayCollection = new ArrayCollection(stmt.getResult().data);
	var loadManager:PersistenceManager = new PersistenceManager();
	
	
	if (resData.length != 0){
		navigator.pushView(Home);
		
	}
	else {
		busy = false;
	//	hideloading();
		
	}
	
	
	
	
}
protected function userPasswordInput_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode == 13){
		authorizeLogin(userNameInput.text,userPasswordInput.text);	
	}
}





private function onFacebookInit(result:Object, fail:Object):void
{
	connectwithfacebook(result,fail);
}

private function onLogin(result:Object, fail:Object):void
{
	connectwithfacebook(result,fail);
}



private function connectwithfacebook(result:Object, fail:Object):void {
	
	if((result)&&(sentfacebookrequest == false))
	{
		busy = true;
		showloading();
		sentfacebookrequest = true;
		accessToken = result.accessToken;				
		var tbday:String = result.user.birthday;
		var temail:String = result.user.email;
		var tfirst_name:String = result.user.first_name;
		var tlast_name:String = result.user.last_name;
		var tgender:String = result.user.gender;
		var tlocation:String = result.user.location.name;
		var tcity:String = tlocation.substring(0,tlocation.indexOf(","));
		var tprov:String = tlocation.substring(tlocation.indexOf(",")+2,tlocation.length);
		var tbday1:String = tbday.substring(0,tbday.indexOf("/"));
		tbday = tbday.substring(tbday.indexOf("/")+1,tbday.length);
		var tbday2:String = tbday.substring(0,tbday.indexOf("/"));
		tbday = tbday.substring(tbday.indexOf("/")+1,tbday.length);
		var tbday3:String = tbday;
		tgender = tgender.substr(0,1).toUpperCase();
		oemail = temail;
		opassword = '';
		oname1 = tfirst_name;
		oname2 = tlast_name;
		ocity = tcity;
		oprovince = tprov;
		obirthday = tbday1;
		obirthmonth = tbday2;
		obirthyear = tbday3;
		ogender = tgender;
		facebookid = result.uid;
		facebookconnect.send();
		
	}
}

public function afterFacebookConnect(ev:ResultEvent):void {
	var stop:String = "";
	busy = false;
	hideloading();
	sentfacebookrequest = false;
	if (ev.result[0].res.message == "ok"){
		facebookwarn.text = "";
		AddNewLocalUser(oemail,
			oname1,
			'canada'
		);
	}
	else {
		
		facebookwarn.text = ev.result[0].res.message;
	}
	
}