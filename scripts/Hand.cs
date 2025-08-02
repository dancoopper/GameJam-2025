using Godot;
using System;

public partial class Hand : Node3D
{
	[Export] public RayCast3D Raycast;

	#nullable enable
	private Pickable? _holdingItem = null;

	public override void _Process(double delta)
	{
		if (Input.IsActionJustPressed("Interact"))
		{
			Interact();
		}
	}

	private void Interact()
	{
		if (_holdingItem == null)
		{
			if (Raycast.IsColliding())
			{
				// body is null if it's not a Pickable
				if (Raycast.GetCollider() is Pickable body)
				{
					body.Pick(this);
					_holdingItem = body;
				}
			}
		}
		else
		{
			_holdingItem.Drop();
			_holdingItem = null;
		}
	}
}
