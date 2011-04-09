/**
 * ...
 * @author Franco Ponticelli
 */

package thx.color;

using Ints;
import Floats;
using thx.math.Equations;
using StringTools;

class Rgb
{
	public var blue(default, null) : Int;
	public var green(default, null) : Int;
	public var red(default, null) : Int;

	/**
	 *
	 * @param red	an Int value between 0 and 255
	 * @param green	an Int value between 0 and 255
	 * @param blue	an Int value between 0 and 255
	 * @param alpha	an Int value between 0 and 255
	 */
	public function new(r : Int, g : Int, b : Int)
	{
		red   = r.clamp(0, 255);
		green = g.clamp(0, 255);
		blue  = b.clamp(0, 255);
	}
	
	public function int()
	{
		return ( ( red & 0xFF ) << 16 ) | ( ( green & 0xFF ) << 8 ) | ( ( blue & 0xFF ) << 0 );
	}
	
	public function hex(?prefix = "")
	{
		return prefix + red.hex(2) + green.hex(2) + blue.hex(2);
	}
	
	inline public function toCss() return hex('#')
		
	public function toRgbString()
	{
		return "rgb(" + red + "," + green + "," + blue + ")";
	}
	
	public function toString()
	{
		return toRgbString();
	}
	
	public static function fromFloats(r : Float, g : Float, b : Float)
	{
		return new Rgb(
			r.interpolate(0, 255),
			g.interpolate(0, 255),
			b.interpolate(0, 255));
	}
	
	public static function fromInt( v: Int ): Rgb
	{
		return new Rgb((v >> 16) & 0xFF, (v >> 8) & 0xFF, (v >> 0 ) & 0xFF);
	}
	
	public static function equals(a : Rgb, b : Rgb)
	{
		return a.red == b.red && a.green == b.green && a.blue == b.blue;
	}
	
	public static function darker(color : Rgb, t : Float, ?interpolator : Float -> Float) : Rgb
	{
		return new Rgb(
			(t * color.red).interpolate(0, 255, interpolator),
			(t * color.green).interpolate(0, 255, interpolator),
			(t * color.blue).interpolate(0, 255, interpolator)
		);
	}
	
	public static function interpolate(a : Rgb, b : Rgb, t : Float, ?interpolator : Float -> Float)
	{
		return new Rgb(
			t.interpolate(a.red, b.red, interpolator),
			t.interpolate(a.green, b.green, interpolator),
			t.interpolate(a.blue, b.blue, interpolator)
		);
	}
	
	public static function interpolatef(a : Rgb, b : Rgb, ?interpolator : Float -> Float)
	{
		var r = Ints.interpolatef(a.red, b.red),
			g = Ints.interpolatef(a.green, b.green),
			b = Ints.interpolatef(a.blue, b.blue);
		return function(t) return new Rgb(r(t), g(t), b(t));
	}
	
	public static function contrast(c : Rgb)
	{
		var nc = Hsl.toHsl(c);
		if (nc.lightness < .5)
			return new Hsl(nc.hue, nc.saturation, nc.lightness + 0.5);
		else
			return new Hsl(nc.hue, nc.saturation, nc.lightness - 0.5);
	}
	
	public static function contrastBW(c : Rgb)
	{
		var nc = Hsl.toHsl(c);
		if (nc.lightness < .5)
			return new Hsl(nc.hue, nc.saturation, 1.0);
		else
			return new Hsl(nc.hue, nc.saturation, 0);
	}
}