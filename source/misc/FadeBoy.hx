package misc;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class FadeBoy extends FlxSprite
{
	public var hasFadeIn(get, null):Bool;
	public var hasFadeOut(get, null):Bool;

	public function new(_color:FlxColor = FlxColor.BLACK, fadeIn:Bool = true)
	{
		super();
		loadGraphic(Paths.getImage("blackFade"), true, 192, 132);
		animation.add("fadeIn", [0, 1, 2, 3, 4], 5, false);
		animation.add("fadeOut", [4, 3, 2, 1, 0], 5, false);

		if (fadeIn)
			animation.play("fadeIn");
		else
			animation.frameIndex = 4;
		color = _color;
	}

	public function fadeIn()
	{
		animation.play("fadeIn");
	}

	public function fadeOut()
	{
		animation.play("fadeOut");
	}

	function get_hasFadeIn():Bool
	{
		return animation.finished && animation.name == "fadeIn" ? false : true;
	}

	function get_hasFadeOut():Bool
	{
		return animation.finished && animation.name == "fadeOut" ? false : true;
	}
}
