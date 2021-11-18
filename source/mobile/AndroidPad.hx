package mobile;

import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.ui.FlxButton;
import misc.Input;
import misc.Paths;

class AndroidPad extends FlxTypedGroup<FlxButton>
{
	var btnLeft:FlxButton;
	var btnRight:FlxButton;
	var btnJump:FlxButton;
	var btnShot:FlxButton;

	public function new()
	{
		super();

		btnLeft = new FlxButton(12, 120);
		btnLeft.onDown.callback = () -> Input.LEFT = true;
		btnLeft.onOut.callback = () -> Input.LEFT = false;
		btnLeft.loadGraphic(Paths.getImage("mobile_left", true), true, 24, 24);
		add(btnLeft);

		btnRight = new FlxButton(48, 120);
		btnRight.onDown.callback = () -> Input.RIGHT = true;
		btnRight.onOut.callback = () -> Input.RIGHT = false;
		btnRight.loadGraphic(Paths.getImage("mobile_right", true), true, 24, 24);
		add(btnRight);

		btnJump = new FlxButton(204, 120);
		btnJump.onDown.callback = () -> Input.JUMP = true;
		btnJump.onOut.callback = () -> Input.JUMP = false;
		btnJump.loadGraphic(Paths.getImage("mobile_up", true), true, 24, 24);
		add(btnJump);

		btnShot = new FlxButton(80, 16);
		btnShot.onDown.callback = () -> Input.SHOOT = true;
		btnShot.onOut.callback = () -> Input.SHOOT = false;
		btnShot.loadGraphic(Paths.getImage("mobile_shot", true), true, 80, 32);
	}

	public function enableShotButton()
	{
		add(btnShot);
	}

	public function setCamera(_camera:FlxCamera)
	{
		btnLeft.cameras = [_camera];
		btnRight.cameras = [_camera];
		btnJump.cameras = [_camera];
		btnShot.cameras = [_camera];
	}
}
