package com.renaun.caltrain.components 
{ 
	import flash.system.Capabilities;
	import mx.core.DPIClassification;
	import mx.core.mx_internal;
	import spark.preloaders.SplashScreen;
	use namespace mx_internal
	public class MultiDPISplashScreen extends SplashScreen 
	{ 
		[Embed(source="/assets/320/splashlogo_Low.png")] 
		private var SplashImage160:Class; 
		[Embed(source="/assets/320/splashlogo_Med.png")] 
		private var SplashImage240:Class; 
		[Embed(source="/assets/320/splashlogo_High.png")] 
		private var SplashImage320:Class; 
		[Embed(source="/assets/320/Default-568h@2x.png")] 
		private var iphone5image:Class; 
		public function MultiDPISplashScreen() 
		{ 
			super(); 
		} 
		override mx_internal function getImageClass(aspectRatio:String, dpi:Number, resolution:Number):Class 
		{ 
			if ((Capabilities.screenResolutionX == 1136  && Capabilities.screenResolutionY == 640  )||
				(Capabilities.screenResolutionX == 640   && Capabilities.screenResolutionY == 1136 )){
				return iphone5image;
			}
			else if (dpi == DPIClassification.DPI_160)
			{
				if (Capabilities.screenResolutionX < 512 && Capabilities.screenResolutionY < 512
					|| Capabilities.cpuArchitecture == "x86")
					return SplashImage160;
				else
					return SplashImage320;
			}
			else if (dpi == DPIClassification.DPI_240) 
				return SplashImage240; 
			else if (dpi == DPIClassification.DPI_320) 
				return SplashImage320; 
			return null; 
		} 
	} 
}