using Godot;
using System;

public class Main : Node2D
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        PackedScene enemyScene = (PackedScene)GD.Load("res://Enemy.tscn");

        for (int i = 0; i < 100; i++)
        {
            Enemy enemy = enemyScene.Instance<Enemy>();
            float f = (float) GD.RandRange(0,2000) + 340;
            enemy.Position = new Vector2(f,(float)GD.RandRange(0,250));
            AddChild(enemy);
        }

    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    //  public override void _Process(float delta)
    //  {
    //      
    //  }
}
