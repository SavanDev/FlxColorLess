package misc;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class FadeBoy extends FlxSprite
{
	public var fadeOutFinished(get, null):Bool;

	private var callbackOut:Void->Void;
	private var callbackIn:Void->Void;

	public function new(fadeIn:Bool = true, color:FlxColor = FlxColor.BLACK)
	{
		super();
		loadGraphic(Paths.getImage("blackFade"), true, 192, 132);
		animation.add("fadeIn", [0, 1, 2, 3, 4], 5, false);
		animation.add("fadeOut", [4, 3, 2, 1, 0], 5, false);
		this.color = color;

		if (fadeIn)
			animation.play("fadeIn");
		else
			animation.frameIndex = 4;

		animation.finishCallback = (name:String) ->
		{
			if (name == "fadeOut" && callbackOut != null)
				callbackOut();
			else if (callbackIn != null)
				callbackIn();
		}
	}

	public function fadeIn(?color:FlxColor)
	{
		if (color != null)
			this.color = color;

		animation.play("fadeIn");
	}

	public function fadeOut(?color:FlxColor)
	{
		if (color != null)
			this.color = color;

		animation.play("fadeOut");
	}

	public function setColor(color:FlxColor)
	{
		this.color = color;
	}

	public function setCallbackOut(callback:Void->Void)
	{
		callbackOut = callback;
	}

	public function setCallbackIn(callback:Void->Void)
	{
		callbackIn = callback;
	}

	function get_fadeOutFinished():Bool
	{
		return animation.finished && animation.name == "fadeOut" ? true : false;
	}
}
