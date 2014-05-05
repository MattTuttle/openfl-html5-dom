package flash.media;


import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.InteractiveObject;
import flash.display.Stage;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.media.VideoElement;
import flash.net.NetStream;
import flash.Lib;
import js.html.CanvasElement;
import js.html.MediaElement;
import js.Browser;


class Video extends DisplayObject {


	public var deblocking:Int;
	public var smoothing:Bool;

	private var netStream:NetStream;
	private var renderHandler:Event->Void;
	private var videoElement(default, null):MediaElement;
	private var windowHack:Bool;


	public function new (width:Int = 320, height:Int = 240):Void {

		super ();

		/*
		 * todo: netstream/camera
		 * 			check compat with flash events
		 */

		this.width = width;
		this.height = height;

		this.smoothing = false;
		this.deblocking = 0;

		//this.addEventListener(Event.ADDED_TO_STAGE, added);

	}


	/*private function added(e:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
	}*/


	/*public function attachCamera(camera:flash.net.Camera):Void;
	{
		// (html5 <device/>
		throw "not implemented";
	}*/


	public function attachNetStream (ns:NetStream):Void {

		this.netStream = ns;
		var scope:Video = this;

		if (ns != null) {

			var video = ns.__videoElement;
			trace(__surface);

			video.style.setProperty ("width", width + "px", "");
			video.style.setProperty ("height", height + "px", "");

			video.style.setProperty ("position", "absolute", "");
			video.style.setProperty ("left", "0px", "");
			video.style.setProperty ("top", "0px", "");

			video.addEventListener ("error", ns.__notFound, false);
			video.addEventListener ("waiting", ns.__bufferEmpty, false);
			video.addEventListener ("ended", ns.__bufferStop, false);
			video.addEventListener ("play", ns.__bufferStart, false);

			__surface.appendChild(video);

			video.play ();

		}
	}

	override public function set_width (inValue):Float {

		return __width = inValue;

	}

	override public function get_width ():Float {

		return __width;

	}

	override public function set_height (inValue):Float {

		return __height = inValue;

	}

	override public function get_height ():Float {

		return __height;

	}


	public function clear():Void {

		__surface.removeChild(netStream.__videoElement);

	}

	override public function __getObjectUnderPoint (point:Point):InteractiveObject {

		var local = globalToLocal (point);

		if (local.x >= 0 && local.y >= 0 && local.x <= width && local.y <= height) {

			// NOTE: bad cast, should be InteractiveObject...
			return cast this;

		} else {

			return null;

		}

	}


	override public function __render (inMask:CanvasElement = null, clipRect:Rectangle = null):Void {

		if (_matrixInvalid || _matrixChainInvalid) {

			__validateMatrix ();

		}

		var gfx = __getGraphics ();
		if (gfx != null) {

			Lib.__setSurfaceTransform (gfx.__surface, getSurfaceTransform (gfx));

		}

	}


	override public function toString ():String {

		return "[Video name=" + this.name + " id=" + ___id + "]";

	}

}