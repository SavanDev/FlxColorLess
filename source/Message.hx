import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class Message extends FlxText
{
	static inline var TEXT_TIME:Int = 2;
	static inline var MARGIN:Int = 20;

	public var callback:Void->Void;

	var isRunning:Bool = false;

	public function new()
	{
		super();
		alpha = 0;
		color = FlxColor.CYAN;
	}

	public function showText(msg:String)
	{
		if (!isRunning)
		{
			var xPos = new FlxRandom().int(MARGIN, Game.getGameWidth() - MARGIN);
			var yPos = new FlxRandom().int(MARGIN, Game.getGameHeight() - MARGIN);
			setPosition(xPos, yPos);
			text = msg;
			FlxTween.tween(this, {x: x - 20, alpha: 1}, TEXT_TIME, {
				onComplete: (twn) -> FlxTween.tween(this, {x: x - 20, alpha: 0}, TEXT_TIME, {
					onComplete: (twn) ->
					{
						isRunning = false;
						if (callback != null)
							callback();
					}
				})
			});
			isRunning = true;
		}
	}

	public function showArrayText(msgs:Array<String>)
	{
		showText(msgs[new FlxRandom().int(0, msgs.length - 1)]);
	}
}
