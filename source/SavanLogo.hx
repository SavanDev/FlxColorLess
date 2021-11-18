import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import misc.Paths;
import states.MenuState;

class SavanLogo extends BaseState
{
	override public function create()
	{
		super.create();
		FlxG.camera.pixelPerfectRender = Game.PIXEL_PERFECT;
		FlxG.camera.zoom = 2;

		var logo = new FlxSprite();
		logo.loadGraphic(Paths.getImage("SDPixel"));
		logo.screenCenter();
		logo.y -= 5;
		add(logo);

		var logoText = new FlxText(0, 0, "SavanDev");
		logoText.screenCenter();
		logoText.y += 20;
		add(logoText);

		#if desktop
		FlxG.mouse.visible = false;
		FlxG.mouse.enabled = false;
		#end

		new FlxTimer().start(3, (_) -> FlxG.switchState(new MenuState()));
	}
}
