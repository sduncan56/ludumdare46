package;

import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;

class Player extends FlxSprite
{
    public var Point:FlxPoint = new FlxPoint();
    private var _fireEmitter:FlxEmitter;
    private var _flame:FlxSprite;

    public function new() {
        super(FlxG.width/2-200, FlxG.height/2-150, "assets/images/ship.png");

        velocity.x = 50;
        
        _fireEmitter = new FlxEmitter(x+5, y+width/2, 30);
        _fireEmitter.makeParticles(1,1,FlxColor.RED, 250);


        FlxG.state.add(_fireEmitter);

        _flame = new FlxSprite(x-3, y+11, "assets/images/flame.png");
        _flame.velocity = velocity;
        _flame.visible = false;
        FlxG.state.add(_flame);
    }

    private function accelerate()
    {
        velocity.x += 1 * _cosAngle;
        velocity.y += 1 * _sinAngle;

        _flame.visible = true;

        FlxG.sound.play("assets/sounds/rocket.wav", 0.01, false);
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
            accelerate();

            // if (!_fireEmitter.emitting)
            //     _fireEmitter.start(false, 0.01);


        } else{
            _flame.visible = false;
        }
            
    }

    public function hitWale()
    {
        y -= 5;
        _flame.x = x-3;
        _flame.y = y+11;
        //_flame.y -= 5;

        velocity.x = -velocity.x/2;
        velocity.y = -velocity.y/2;
    }

    override public function update(elapsed:Float):Void
    {
        move(elapsed);
        _fireEmitter.x = x+5;
        _fireEmitter.y = y+width/2-27;
        _fireEmitter.angle.set(-90, 90);
        _fireEmitter.launchAngle.set(-45, 45);
        
        // var ox = origin.x;
        // var oy = origin.y;
        // origin.set(x+5,y+14);
        _flame.origin.set(origin.x+3, origin.y-11);
         _flame.angle = angle;
        // origin.set(ox, oy);

        super.update(elapsed);
        Point.set(x+width/2, y+height);

    }
}