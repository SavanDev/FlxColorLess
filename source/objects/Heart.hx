package objects;

import flixel.FlxSprite;
import misc.Paths;

class Heart extends FlxSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		super(x, y);
		loadGraphic(Paths.getImage("heart"), true, 13, 13);
		animation.add("disappear", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], 20, false);
		animation.finishCallback = (name) ->
		{
			if (name == "disappear")
				exists = false;
		};
	}

	override public function kill()
	{
		alive = false;
		animation.play("disappear");
	}
}
