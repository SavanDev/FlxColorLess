package objects;

import flixel.FlxSprite;
import misc.Paths;

class Strawberry extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(Paths.getImage("strawberry"));
	}
}
