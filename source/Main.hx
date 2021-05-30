package;

import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.Sprite;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;

class Main extends Sprite
{
	var _width:Int = 832;
	var _height:Int = 676;
	var _initialState:Class<FlxState> = PlayState;

	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, _initialState));
		FlxG.game.setFilters([new ShaderFilter(new FlxShader())]);
		FlxG.game.stage.quality = StageQuality.LOW;
		FlxG.resizeWindow(_width, _height);
		// FlxG.fullscreen = true;
	}
}
