package;

import flixel.FlxGame;
import flixel.FlxState;
import misc.FPSMem;
import misc.Input;
import openfl.display.Sprite;

class Main extends Sprite
{
	var _width:Int = 240;
	var _height:Int = 156;
	var _initialState:Class<FlxState> = SavanLogo;

	public function new()
	{
		super();
		addChild(new FlxGame(_width, _height, _initialState, true));
		Input.init();

		#if debug
		addChild(new FPSMem(5, 5, 0xFFFFFF));
		#end
	}
}
