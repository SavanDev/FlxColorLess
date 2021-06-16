import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.util.FlxColor;
import misc.FadeBoy;

// Based on FlxTransitionableState
class BaseState extends FlxState
{
	public static var skipNextTransIn:Bool = false;
	public static var skipNextTransOut:Bool = false;
	public static var fadeColor:FlxColor = FlxColor.BLACK;

	var _exiting:Bool = false;
	var transOutFinished:Bool = false;

	override public function create():Void
	{
		super.create();
		if (!skipNextTransIn)
			transIn();
		else
			skipNextTransIn = false;
	}

	override public function switchTo(nextState:FlxState):Bool
	{
		if (skipNextTransOut)
		{
			skipNextTransOut = false;
			return true;
		}

		if (!_exiting)
			transOut(nextState);
		return transOutFinished;
	}

	function transIn()
	{
		openSubState(new FadeSubState(FadeType.IN));
	}

	function transOut(nextState:FlxState)
	{
		openSubState(new FadeSubState(FadeType.OUT, () ->
		{
			transOutFinished = true;
			FlxG.switchState(nextState);
		}));
	}
}

enum FadeType
{
	IN;
	OUT;
}

class FadeSubState extends FlxSubState
{
	var fadeType:FadeType;
	var callbackOut:Void->Void;

	public function new(fadeType:FadeType, ?callback:Void->Void)
	{
		super();
		this.fadeType = fadeType;
		if (callback != null)
			callbackOut = callback;
	}

	override public function create()
	{
		super.create();
		var fade = new FadeBoy(false, BaseState.fadeColor);
		add(fade);

		if (fadeType == FadeType.IN)
		{
			fade.setCallbackIn(() -> close());
			fade.fadeIn();
		}
		else
		{
			fade.setCallbackOut(callbackOut);
			fade.fadeOut();
		}
	}
}
