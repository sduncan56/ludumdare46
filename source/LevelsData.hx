package;

class Level
{
    public var Health(default, null):Int;
    public var Time(default, null):Int;
    public var RetractWaitTime(default, null):Int;
    public var NumberOfAliens(default, null):Int;
    public function new(health:Int, time:Int, retractWaitTime:Int, numAliens:Int)
    {
        Health = health;
        Time = time;
        RetractWaitTime = retractWaitTime;
        NumberOfAliens = numAliens;
    }

}

class LevelsData
{
    public var Level1(default, null):Level = new Level(100, 30, 5, 3);
    public var Level2(default, null):Level = new Level(80, 40, 5, 4);
    public var Level3(default, null):Level = new Level(60, 50, 4, 6);
    public var Level4(default, null):Level = new Level(70, 60, 3, 7);

    public var Level5(default, null):Level = new Level(70, 90, 2, 8);
    public var Level6(default, null):Level = new Level(60, 120, 2, 10);
    public var Level7(default, null):Level = new Level(60, 120, 1, 10);




    public var Levels(default, null):Array<Level> = new Array();

    public function new() {
    
        Levels.push(Level1);
        Levels.push(Level2);
        Levels.push(Level3);
        Levels.push(Level4);
        Levels.push(Level5);
        Levels.push(Level6);
        Levels.push(Level7);
    }
        
    
}