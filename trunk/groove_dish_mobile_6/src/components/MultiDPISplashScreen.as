package components 
{ 
	import flash.system.Capabilities;
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import spark.preloaders.SplashScreen;
	use namespace mx_internal
	public class MultiDPISplashScreen extends SplashScreen 
	{ 
		/*[Embed(source="/assets/splashlogo_Low.png")] 
		private var SplashImage160:Class; 
		[Embed(source="/assets/splashlogo_Med.png")] 
		private var SplashImage240:Class; 
		[Embed(source="/assets/splashlogo_High.png")] 
		private var SplashImage320:Class; 
		[Embed(source="/assets/splashlogo_Higher.png")] 
		private var SplashImage480:Class;
		[Embed(source="/assets/splashlogo_Highest.png")] 
		private var SplashImage640:Class;
		[Embed(source="/assets/Default-568h@2x.png")] 
		private var iphone5image:Class; */
		[Embed(source="/assets/splash/iphone3.png")] 
		private var iphone3:Class; 
		[Embed(source="/assets/splash/iphone4.png")] 
		private var iphone4:Class; 
		[Embed(source="/assets/splash/iphone5.png")] 
		private var iphone5:Class; 
	/*	[Embed(source="/assets/iphone6.png")] 
		private var iphone6:Class; 
		[Embed(source="/assets/iphone6plus.png")] 
		private var iphone6p:Class; */
		public function MultiDPISplashScreen() 
		{ 
			super(); 
		} 
		override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class 
		{ 
			//var wi:Number = Capabilities.screenResolutionX;
			var hi:Number = Capabilities.screenResolutionY;
			if (hi <= 965){
				return iphone4;
			}
			else if (hi <= 1140){
				return iphone5;
			}
			return iphone5;
			/*if (((wi == 640)&& (hi == 1136))||((wi == 1136)&& (hi == 640))){
			return iphone5image;
			}
			else if (dpi == DPIClassification.DPI_160){
			return SplashImage160;
			}
			else if (dpi == DPIClassification.DPI_160){
			return SplashImage240; 
			}
			else if (dpi == DPIClassification.DPI_160){
			return SplashImage320; 
			}
			else if (dpi == DPIClassification.DPI_160){
			return SplashImage480; 
			}
			else if (dpi == DPIClassification.DPI_160){
			return SplashImage640; 
			}
			return SplashImage320; */
		} 
	} 
}

