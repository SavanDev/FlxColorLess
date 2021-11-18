package misc;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

// From HaxeFlixel examples xD
class ScanLines extends FlxSpriteGroup
{
	public function new(lines:Bool = true)
	{
		super();
		var crtView = new FlxSprite();
		crtView.loadGraphic(createCRTEffect(lines));
		crtView.x = Game.GAME_X;
		add(crtView);

		var leftRect = new FlxSprite().makeGraphic(Game.GAME_X, Game.getGameHeight(), FlxColor.BLACK);
		add(leftRect);

		var rightRect = new FlxSprite(Game.GAME_X + Game.getGameWidth()).makeGraphic(Game.GAME_X, Game.getGameHeight(), FlxColor.BLACK);
		add(rightRect);

		var downRect = new FlxSprite(0, Game.getGameHeight()).makeGraphic(FlxG.width, Game.GAME_X, FlxColor.BLACK);
		add(downRect);
	}

	function createCRTEffect(lines:Bool):BitmapData
	{
		var bitmapdata = new BitmapData(Game.getGameWidth(), Game.getGameHeight(), true, FlxColor.TRANSPARENT);
		var scanline = new BitmapData(Game.getGameWidth(), 1, true, 0x40000000);

		if (lines)
		{
			for (i in 0...bitmapdata.height)
			{
				if (i % 2 != 0)
					bitmapdata.draw(scanline, new Matrix(1, 0, 0, 1, 0, i));
			}
		}

		// round corners

		var cX:Array<Int> = [5, 3, 2, 2, 1];
		var cY:Array<Int> = [1, 2, 2, 3, 5];
		var w:Int = bitmapdata.width;
		var h:Int = bitmapdata.height;

		for (i in 0...5)
		{
			bitmapdata.fillRect(new Rectangle(0, 0, cX[i], cY[i]), FlxColor.BLACK);
			bitmapdata.fillRect(new Rectangle(w - cX[i], 0, cX[i], cY[i]), FlxColor.BLACK);
			bitmapdata.fillRect(new Rectangle(0, h - cY[i], cX[i], cY[i]), FlxColor.BLACK);
			bitmapdata.fillRect(new Rectangle(w - cX[i], h - cY[i], cX[i], cY[i]), FlxColor.BLACK);
		}

		return bitmapdata;
	}
}
