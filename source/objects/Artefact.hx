package objects;

import flixel.FlxSprite;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxGlitchEffect;
import misc.Paths;

class Artefact extends FlxEffectSprite
{
	public function new(x:Float = 0, y:Float = 0)
	{
		var sprite = new FlxSprite().loadGraphic(Paths.getImage("entity", true));
		var glitchEffect = new FlxGlitchEffect(2);
		super(sprite, [glitchEffect]);
		this.setPosition(x, y);
	}
}
