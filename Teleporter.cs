using Godot;
using System;

public partial class Teleporter : Node
{
	private Node3D _parent;
	public Vector3 PreviousOffsetFromPortal;
	public Transform3D Transform
	{
		get { return _parent.Transform; }
		set { _parent.Transform = value; }
	}

	public Vector3 Position
	{
		get { return _parent.Position; }
		set { _parent.Position = value; }
	}

	public Vector3 Rotation
	{
		get { return _parent.Rotation; }
		set { _parent.Rotation = value; }
	}

	public override void _Ready()
	{
		_parent = GetParent() as Node3D;
	}

	public void Teleport(Vector3 pos, Vector3 rot)
	{
		Position = pos;
		Rotation = rot;
	}

	public void EnterPortalThreshold()
	{

	}

	public void ExitPortalThreshold()
	{

	}
}
