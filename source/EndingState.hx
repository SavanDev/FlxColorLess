import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import lime.system.System;

class EndingState extends FlxState
{
	override public function create()
	{
		super.create();

		var animEnding = new FlxSprite().loadGraphic(Paths.getImage("AnimEnding"), true, 96, 72);
		animEnding.animation.add("upHead", [0, 1, 2, 3], .5, false);
		animEnding.animation.add("smile", [4, 5, 6], 8, false);
		animEnding.setGraphicSize(96 * 2, 72 * 2);
		animEnding.updateHitbox();
		add(animEnding);

		var screen = new FlxSprite(0, 0, Paths.getImage("screen"));
		screen.alpha = .25;
		add(screen);

		var uiText = new FlxText(5, 132 + 5, FlxG.width - 10);
		uiText.alignment = CENTER;
		add(uiText);

		new FlxTimer().start(2, (_) -> animEnding.animation.play("upHead"));

		animEnding.animation.finishCallback = (name:String) ->
		{
			if (name == "upHead")
				new FlxTimer().start(2, (_) -> animEnding.animation.play("smile"));
			else if (name == "smile")
			{
				new FlxTimer().start(3, (_) -> System.exit(0));
				uiText.text = "Don't give up!";
				animEnding.kill();
			}
		}
	}
}
