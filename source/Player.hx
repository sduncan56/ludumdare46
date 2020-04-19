package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    public function new() {
        super(FlxG.width/2-200, FlxG.height/2-120, "assets/images/ship.png");
    }

    private function move(elapsed:Float)
    {
        if (FlxG.keys.anyPressed([UP, W]))
        {
            angle-=3;
        }
        if (FlxG.keys.anyPressed([DOWN, S]))
        {
            angle += 3;
        }

        if (FlxG.keys.anyPressed([RIGHT, D]))
        {
            velocity.x += 1 * _cosAngle;
            velocity.y += 1 * _sinAngle;

      

        }


            
    }

    override public function update(elapsed:Float):Void
    {
        move(elapsed);
        super.update(elapsed);
    }
}