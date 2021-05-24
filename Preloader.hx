import flixel.system.FlxAssets;
import flixel.system.FlxBasePreloader;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;

class Preloader extends FlxBasePreloader
{
	var _buffer:Sprite;
	var _bmpBar:Bitmap;
	var _text:TextField;

	override function create()
	{
		_buffer = new Sprite();
		_buffer.scaleX = _buffer.scaleY = 4;
		addChild(_buffer);

		_width = Std.int(Lib.current.stage.stageWidth / _buffer.scaleX);
		_height = Std.int(Lib.current.stage.stageHeight / _buffer.scaleY);
		trace('Width: $_width - Height: $_height');

		_bmpBar = new Bitmap(new BitmapData(1, 7, false, 0x5f6aff));
		_bmpBar.x = 4;
		_bmpBar.y = _height - 11;
		_buffer.addChild(_bmpBar);

		_text = new TextField();
		_text.defaultTextFormat = new TextFormat(FlxAssets.FONT_DEFAULT, 8, 0x5f6aff);
		_text.embedFonts = true;
		_text.selectable = false;
		_text.multiline = false;
		_text.x = 2;
		_text.y = _bmpBar.y - 11;
		_text.width = 200;
		_buffer.addChild(_text);

		super.create();
	}

	override function destroy()
	{
		if (_buffer != null)
			removeChild(_buffer);
		_bmpBar = null;
		_text = null;
	}

	override public function update(Percent:Float)
	{
		_bmpBar.scaleX = Percent * (_width - 8);
		_text.text = 'ColorLess! ${Std.int(Percent * 100)}%';
	}
}
