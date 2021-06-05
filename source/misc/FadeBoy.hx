package misc;

import flixel.FlxSprite;

class FadeBoy extends FlxSprite
{
	public var hasFadeIn(get, null):Bool;
	public var hasFadeOut(get, null):Bool;

	public function new()
	{
		super();
		loadGraphic(Paths.getImage("blackFade"), true, 192, 132);
		animation.add("fadeIn", [0, 1, 2, 3, 4], 5, false);
		animation.add("fadeOut", [4, 3, 2, 1, 0], 5, false);
		animation.play("fadeIn");
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
