using Godot;
using System;

public partial class Player : CharacterBody3D
{
	public const float Speed = 5.0f;
	public const float JumpVelocity = 4.5f;
	public const float MouseSensitivity = 0.002f;

	private Node3D _head; // This will be your camera pivot

	public override void _Ready()
	{
		// Capture the mouse
		Input.MouseMode = Input.MouseModeEnum.Captured;

		// Get the head node
		_head = GetNode<Node3D>("Head");
	}

	public override void _Input(InputEvent @event)
	{
		if (Input.IsActionJustPressed("ui_cancel"))
			Input.MouseMode = Input.MouseModeEnum.Visible;

		
		if (@event is InputEventMouseMotion mouseMotion)
		{
			// Horizontal rotation (yaw) on player body
			RotateY(-mouseMotion.Relative.X * MouseSensitivity);

			// Vertical rotation (pitch) on head
			_head.RotateX(-mouseMotion.Relative.Y * MouseSensitivity);

			// Clamp vertical rotation to avoid flipping
			Vector3 headRotation = _head.Rotation;
			headRotation.X = Mathf.Clamp(headRotation.X, Mathf.DegToRad(-90), Mathf.DegToRad(90));
			_head.Rotation = headRotation;
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		Vector3 velocity = Velocity;

		if (!IsOnFloor())
			velocity += GetGravity() * (float)delta;

		if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
			velocity.Y = JumpVelocity;

		Vector2 inputDir = Input.GetVector("ui_left", "ui_right", "ui_down", "ui_up");

		// Move relative to where the player is looking (yaw only)
		Vector3 forward = -Transform.Basis.Z;
		Vector3 right = Transform.Basis.X;

		Vector3 direction = (right * inputDir.X + forward * inputDir.Y).Normalized();
		if (direction != Vector3.Zero)
		{
			velocity.X = direction.X * Speed;
			velocity.Z = direction.Z * Speed;
		}
		else
		{
			velocity.X = Mathf.MoveToward(Velocity.X, 0, Speed);
			velocity.Z = Mathf.MoveToward(Velocity.Z, 0, Speed);
		}

		Velocity = velocity;
		MoveAndSlide();
	}
}
