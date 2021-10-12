using Godot;
using System;

public class EnemySpawner : Node2D
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";


    // Called when the node enters the scene tree for the first time.

    PackedScene enemyScene;

    public override void _Ready()
    {
        enemyScene = (PackedScene)GD.Load("res://Enemy.tscn");
        spawnpoints_ = GetNode<Node2D>("SpawnPoints").GetChildren();
        this.Connect("timeout", this,"onTimerTimeout");
        Enemy enemy = enemyScene.Instance<Enemy>();
            
           // enemy.Position = new Vector2(50,50);
    }

    Godot.Collections.Array spawnpoints_;
    Vector2 spawnPosition = new Vector2();

    void reselectSpawnPoint()
    {
        spawnpoints_.Shuffle();
        Position2D node = (Position2D) spawnpoints_[0];
        spawnPosition = node.GlobalPosition;
    }

    void spawnEnemy()
    {
        reselectSpawnPoint(); 

        Enemy enemy = enemyScene.Instance<Enemy>();
        GetTree().CurrentScene.AddChild(enemy);
        enemy.GlobalPosition = new Vector2(spawnPosition.x+(float)GD.RandRange(-200,450), spawnPosition.y+(float)GD.RandRange(-30,30));
        //enemy.Position = new Vector2(50, 50.8141f);
    }

    void onTimerTimeout()
    {
        spawnEnemy();
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }
}
