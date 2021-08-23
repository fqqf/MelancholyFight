using Godot;
using System;

public class ExplosionEffect : Sprite
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        float rand = (float) GD.RandRange(0.1f,0.5f);
        this.Scale = new Vector2(rand, rand);
        this.Modulate = new Color(Modulate.r, Modulate.g, Modulate.b, rand);
    }

//  // Called every frame. 'delta' is the elapsed time since the previous frame.
//  public override void _Process(float delta)
//  {
//      
//  }
}
