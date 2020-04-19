package;

import dragonBones.events.EventObject;
import dragonBones.flixel.FlixelEvent;
import flixel.FlxBasic;
import flixel.FlxObject;
import dragonBones.flixel.FlixelArmatureDisplay;
import dragonBones.flixel.FlixelArmatureCollider;
import openfl.Assets;
import dragonBones.objects.DragonBonesData;
import dragonBones.flixel.FlixelFactory;
import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxGroup;


class PlayState extends FlxState
{
	var _player:Player;
	var _whale:Whale;
	var _aliens:FlxGroup = new FlxGroup();
	var _harpoons:FlxGroup = new FlxGroup();
	override public function create():Void
	{
		_player = new Player();
		add(_player);

		_whale = new Whale();
		add(_whale);

		var testAlien:Alien = new Alien(300, 0);
		_aliens.add(testAlien);
		add(_aliens);

		_harpoons.add(testAlien.fireHarpoon());


		FlxG.camera.follow(_player, TOPDOWN, 1);

		super.create();
	}


	override public function update(elapsed:Float):Void
	{
		FlxG.overlap(_whale, _harpoons, whaleShot);

		super.update(elapsed);
	}

	public function whaleShot(whale:Whale, harpoon:Harpoon)
	{
		if (!harpoon.InWhale && FlxG.pixelPerfectOverlap(whale, harpoon))
		{
			harpoon.hitWhale();			

			FlxG.camera.shake(0.05, 0.05);
		}
	}
}
