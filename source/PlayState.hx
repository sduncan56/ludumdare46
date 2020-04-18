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
	override public function create():Void
	{
		_player = new Player();
		add(_player);

		var _factory:FlixelFactory = new FlixelFactory();
		
		var whaleData:DragonBonesData = _factory.parseDragonBonesData
		(
			haxe.Json.parse(Assets.getText("assets/images/Stip_ske.json"))
		);

		_factory.parseTextureAtlasData(
			haxe.Json.parse(Assets.getText("assets/images/Stip_tex.json")),
			Assets.getBitmapData("assets/images/Stip_tex.png")
		);

		var armatureGroup = _factory.buildArmatureDisplay(
			new FlixelArmatureCollider(250, 250, 27, 25, 13, 8), whaleData.armatureNames[0]);

			armatureGroup.forEach(_setAnimationProps);
			armatureGroup.forEach(_playAnimation);

		add(cast armatureGroup);


		FlxG.camera.follow(_player, TOPDOWN, 1);

		super.create();
	}

	private function _setAnimationProps(display:FlixelArmatureDisplay):Void
		{
			display.antialiasing = true;
			display.x = 100;
			display.y = 100;
			display.scaleX = 0.50;
			display.scaleY = 0.50;
		}
	private function _playAnimation(display:FlixelArmatureDisplay):Void
		{
			//display.animation.play(display.animation.animationNames[0]);
			
		}
	
	  private function _animationHandler(event:FlixelEvent): Void 
		{
			var eventObject:EventObject = event.eventObject;
		}


	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
