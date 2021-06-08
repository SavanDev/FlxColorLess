package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxShader;
import misc.Input;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;
import openfl.system.Capabilities;

class Main extends Sprite
{
	var _width:Int = 832;
	var _height:Int = 676;
	var _initialState:Class<FlxState> = SavanLogo;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, _initialState, true));
		Input.init();
		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.resizeWindow(_width, _height);

		// Center window on screen
		var screenWidth = Capabilities.screenResolutionX;
		var screenHeight = Capabilities.screenResolutionY;
		trace('Width: $screenWidth - Height: $screenHeight');

		Lib.application.window.x = Std.int((screenWidth / 2) - (_width / 2));
		Lib.application.window.y = Std.int((screenHeight / 2) - (_height / 2));

		// FlxG.fullscreen = true;
	}
}
