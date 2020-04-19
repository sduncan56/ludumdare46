package;

import flixel.FlxObject;
import flixel.math.FlxPoint;
import openfl.geom.Point;
import flixel.FlxSprite;

class ChainSegment extends FlxSprite
{
    public var Broken(default, null):Bool = false;
    public var Withdrawing(default, default):Bool = false;
   // public var AboveChain(default, default):ChainSegment;
    private var _belowChain:ChainSegment;
    private var _harpoon:Harpoon;
    public function new(x:Float, y:Float, vel:FlxPoint, ?belowChain:ChainSegment, ?harpoon:Harpoon)
    {
        super(x, y);

        _belowChain = belowChain;
        _harpoon = harpoon;

        loadGraphic("assets/images/chainspritesheet.png", true, 11, 16);

        animation.add("idle", [0], 1);
        animation.add("break", [0,1,2,3], 10, false);
        animation.add("drift", [0,4,5,6], 10, false);

        animation.finishCallback = animFinished;

        animation.play("idle");

        velocity = vel;
    }

    public function breakChain(vel:FlxPoint)
    {
        velocity = new FlxPoint(vel.x, vel.y);
        Broken = true;
        animation.play("break");

        if (_belowChain != null)
        {
            _belowChain.animation.play("drift");
            //_belowChain.chainBrokeAbove();
        }
    }

    public function chainBrokeAbove()
    {
        kill();
        if (_belowChain != null)
            _belowChain.chainBrokeAbove();

        if (_harpoon != null)
        {
            _harpoon.chainDestroyed();

        }


        //allowCollisions = FlxObject.NONE;
       // velocity = new FlxPoint(10, 30);

        //animation.play("drift");
        

    }

    public function animFinished(anim_name:String)
    {
        switch(anim_name)
        {
            case "break":
                kill();
            case "drift":

                if (_belowChain != null)
                {
                    _belowChain.chainBrokeAbove();
                    kill();
                }
                if (_harpoon != null && !_harpoon.InWhale)
                {
                    // _harpoon.chainDestroyed();
                    // _harpoon.destroy();
                }
                if (Broken)
                    kill();

        }

    }

}