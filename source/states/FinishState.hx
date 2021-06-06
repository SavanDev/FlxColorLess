package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.system.System;
import misc.FadeBoy;

class FinishState extends FlxState
{
	override public function create()
	{
		super.create();

		var finishText = new FlxText(0, 0, 150, "Thanks for playing!\n\nThis game was made for\n#MejorandoAndo of May\n\nPress ESCAPE to exit the game");
		finishText.alignment = CENTER;
		finishText.screenCenter();
		add(finishText);

		var fadeBoy = new FadeBoy(FlxColor.WHITE);
		add(fadeBoy);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			System.exit(0);
	}
}
