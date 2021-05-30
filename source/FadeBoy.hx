import flixel.FlxSprite;

class FadeBoy extends FlxSprite
{
	public function new()
	{
		super();
		loadGraphic(Paths.getImage("blackFade"), true, 192, 132);
		animation.add("fadeIn", [0, 1, 2, 3, 4], 3, false);
		animation.add("fadeOut", [4, 3, 2, 1, 0], 3, false);
		animation.play("fadeIn");
	}
}
