package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.system.System;
import misc.FadeBoy;
import misc.Paths;

class EndingState extends BaseState
{
	var ending:Int;
	var uiText:FlxText;
	var fadeBoy:FadeBoy;
	var endingState:Bool = false;
	var endingState2:Bool = false;

	public function new(_ending:Int = 0)
	{
		super();
		ending = _ending;
	}

	override public function create()
	{
		super.create();
		FlxG.camera.pixelPerfectRender = Game.PIXEL_PERFECT;

		if (ending == 0)
		{
			var animEnding = new FlxSprite().loadGraphic(Paths.getImage("AnimEnding", true), true, 96, 72);
			animEnding.animation.add("upHead", [0, 1, 2, 3], .5, false);
			animEnding.animation.add("smile", [4, 5, 6, 7, 8], 8, false);
			animEnding.animation.add("attack", [9, 10], 8, false);
			animEnding.setGraphicSize(96 * 2, 72 * 2);
			animEnding.updateHitbox();
			add(animEnding);

			new FlxTimer().start(2, (_) -> animEnding.animation.play("upHead"));

			animEnding.animation.finishCallback = (name:String) ->
			{
				if (name == "upHead")
					new FlxTimer().start(2, (_) -> animEnding.animation.play("smile"));
				else if (name == "smile")
					new FlxTimer().start(2, (_) -> animEnding.animation.play("attack"));
				else if (name == "attack")
				{
					uiText.text = "Don't give up!";
					new FlxTimer().start(3, (_) ->
					{
						uiText.color = FlxColor.RED;
						uiText.text = PlayState.POINTS < 6 ? "Maybe... collecting 6 strawberries?" : "Next time... SHOOT HIM!";
						new FlxTimer().start(3, (_) -> System.exit(0));
					});
					animEnding.kill();
				}
			}
		}
		else
		{
			FlxG.sound.play(Paths.getSound("Hit"));
			var animEnding = new FlxSprite().loadGraphic(Paths.getImage("AnimEnding2", true), true, 96, 72);
			animEnding.animation.add("bloodDown", [1, 2, 3, 4], 1, false);
			animEnding.animation.add("bloody", [5, 6, 7, 8, 9, 10], 2, false);
			animEnding.setGraphicSize(96 * 2, 72 * 2);
			animEnding.updateHitbox();
			add(animEnding);

			new FlxTimer().start(2, (_) -> animEnding.animation.play("bloodDown"));
			new FlxTimer().start(5, (_) -> FlxG.camera.shake(.01)); // Poco tiempo para una mejor implementación

			animEnding.animation.finishCallback = (name:String) ->
			{
				if (name == "bloodDown")
				{
					new FlxTimer().start(2, (_) -> animEnding.animation.play("bloody"));
				}
				else if (name == "bloody")
				{
					endingState = true;
					fadeBoy = new FadeBoy(FlxColor.WHITE);
					fadeBoy.fadeOut();
					add(fadeBoy);
				}
			}
		}

		var screen = new FlxSprite(0, 0, Paths.getImage("screen"));
		screen.alpha = .25;
		add(screen);

		uiText = new FlxText(5, 132 + 5, FlxG.width - 10);
		uiText.alignment = CENTER;
		add(uiText);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (fadeBoy != null && endingState && fadeBoy.fadeOutFinished && !endingState2)
		{
			endingState2 = true;
			uiText.text = "You will no longer control me";
			new FlxTimer().start(3, (_) ->
			{
				uiText.text = "Never more";
				BaseState.fadeColor = FlxColor.WHITE;
				new FlxTimer().start(3, (_) -> FlxG.switchState(new FinishState()));
			});
		}
	}
}
