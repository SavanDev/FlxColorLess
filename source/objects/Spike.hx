package objects;

import flixel.FlxSprite;

class Spike extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(Paths.getImage("spikes"));
	}
}
