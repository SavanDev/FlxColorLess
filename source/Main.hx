package;

import flixel.FlxGame;
import flixel.FlxState;
import openfl.display.Sprite;

class Main extends Sprite
{
	var _width:Int = MapData.TILE_WIDTH * MapData.MAP_WIDTH;
	var _height:Int = MapData.TILE_HEIGHT * (MapData.MAP_HEIGHT + 2);
	var _initialState:Class<FlxState> = PlayState;

	public function new()
	{
		super();
		addChild(new FlxGame(_width, _height, _initialState));
	}
}
