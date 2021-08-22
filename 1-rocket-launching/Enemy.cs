using Godot;
using System;

public class Enemy : Area2D
{
    Vector2 Velocity;

    PackedScene explosionEffectScene;


    [Export]
    int SPEED = (int)GD.RandRange(20, 60);

    [Export]
    int RotationForce = (int)GD.RandRange(-30, 30);

    public override void _Ready()
    {
        explosionEffectScene = (PackedScene)GD.Load("res://ExplosionEffect.tscn");
        this.Rotation = (int)GD.RandRange(-180, 180);
        this.Connect("area_entered", this, "OnAreaEntered");
    }

    void OnAreaEntered(Area2D area)
    {
        GD.Print("hm");
        QueueFree();
        area.QueueFree();
    }

    //  // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        RotationDegrees += RotationForce * delta;
        Velocity.x = -SPEED;

        Position += Velocity * delta;

        Velocity.x = 0; Velocity.y = 0;
    }
}
