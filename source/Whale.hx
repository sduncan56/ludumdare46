package;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxObject;
import flixel.FlxSprite;

class Whale extends FlxSprite
{
    public var Health(default, null):Int = 100;
    public function new(health:Int)
    {
        Health = health;
        

        super(100, 100, "assets/images/whale.png");
    }

    public function hit(damage:Int, ?point:FlxPoint)
    {
        Health-=damage;

        if (point != null)
        {
            var injury = new FlxSprite(point.x, point.y, "assets/images/blood.png");
            injury.velocity = velocity;
            FlxG.state.add(injury);
        }
    }
}