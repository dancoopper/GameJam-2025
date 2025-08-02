using Godot;
using System;
using System.Runtime;

public partial class Pickable : RigidBody3D
{

	#nullable enable
	private Node3D? _target = null;
	private Vector3 _previousPosition;
	private double _delta;

	public override void _PhysicsProcess(double delta)
	{
		if (_target is not null)
		{
			Position = _target.GlobalPosition;
			Rotation = _target.GlobalRotation;
			_previousPosition = Position;
			_delta = delta;
		}
	}

	public virtual void Pick(Node3D target)
	{
		_target = target;
		this.CollisionLayer = 2;
		LinearVelocity = Vector3.Zero;
		AngularVelocity = Vector3.Zero;
	}

	public virtual void Drop()
	{
		this.CollisionLayer = 1;
		LinearVelocity = new Vector3(0, 3, 0);
		//LinearVelocity = (Position - _previousPosition);
		AngularVelocity = Vector3.Zero;
		_target = null;
	}
}
