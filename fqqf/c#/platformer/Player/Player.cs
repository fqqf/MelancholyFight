using Godot;
using System;

public class Player : KinematicBody2D
{
    [Export] int ACCELERATION = 512; 
    [Export] int MAX_SPEED = 64;
    [Export] float FRICTION = 0.25f;

    Vector2 motion = Vector2.Zero;

    public override void _PhysicsProcess(float delta)
    {
        Vector2 inputVector = Vector2.Zero;
        inputVector.x = Input.GetActionStrength("ui_right") - Input.GetActionStrength("ui_left");
        inputVector.y = Input.GetActionStrength("ui_down") - Input.GetActionStrength("ui_up");

        if (inputVector != Vector2.Zero)
        {
            motion += inputVector * ACCELERATION * delta; 
            motion = motion.Clamped(MAX_SPEED);
        } else
        {
            motion = motion.LinearInterpolate(Vector2.Zero, FRICTION);
        }

        motion = MoveAndSlide(motion);
    }
}
