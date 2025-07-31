using Godot;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.Net;

public partial class Teleportation : Area3D
{
	private Portal portal;
	private List<Teleporter> _teleporters = new List<Teleporter>();

	public override void _Ready()
	{
		portal = GetParent().GetParent() as Portal;
	}

	public override void _PhysicsProcess(double delta)
	{
		foreach (var teleporter in _teleporters)
		{
			Vector3 offsetFromPortal = teleporter.Position - portal.Position;

			int portalSide = Math.Sign(portal
				.Position
				.Normalized()
				.Dot(offsetFromPortal.Normalized())
			);

			int portalOldSide = Math.Sign(portal
				.Position
				.Normalized()
				.Dot(teleporter.PreviousOffsetFromPortal.Normalized())
			);

			teleporter.PreviousOffsetFromPortal = offsetFromPortal;

			if (portalSide != portalOldSide)
			{
				var m = 
			}
		}
	}

	private void OnBodyEntered(Node3D body)
	{
		var teleporter = body.HasNode("Teleporter") ? body.GetNode<Teleporter>("Teleporter") : null;
		if (teleporter != null && !_teleporters.Contains(teleporter))
		{
			teleporter.EnterPortalThreshold();
			teleporter.PreviousOffsetFromPortal = body.Position - portal.Position;
			_teleporters.Add(teleporter);
		}
	}

	private void OnBodyExited(Node3D body)
	{
		var teleporter = body.HasNode("Teleporter") ? body.GetNode<Teleporter>("Teleporter") : null;
		if (teleporter != null && _teleporters.Contains(teleporter))
		{
			teleporter.ExitPortalThreshold();
			_teleporters.Remove(teleporter);
		}
	}
}
