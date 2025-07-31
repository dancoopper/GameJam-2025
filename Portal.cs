using Godot;
using System;

public partial class Portal : Node3D
{
	[Export] public Node3D DestinationPortal;

	private MeshInstance3D _portalSurface;
	private SubViewport _subViewport;
	private Camera3D _portalCamera;

	public override void _Ready()
	{
		_portalSurface = GetNode<MeshInstance3D>("MeshInstance3D");
		_subViewport = GetNode<SubViewport>("SubViewport");
		_portalCamera = _subViewport.GetNode<Camera3D>("Camera3D");

		Vector2 screenSize = GetViewport().GetVisibleRect().Size;
		_subViewport.Size = new Vector2I((int)screenSize.X, (int)screenSize.Y);

		var material = _portalSurface.GetActiveMaterial(0) as ShaderMaterial;
		if (material != null) 
			material.SetShaderParameter("portal_view", _subViewport.GetTexture());
	}

	public override void _Process(double delta)
	{
		var playerCam = GetViewport().GetCamera3D();
		if (playerCam == null || DestinationPortal == null || _portalCamera == null)
			return;

		// Convert player's transform into local space of this portal
		var localTransform = GlobalTransform.AffineInverse() * playerCam.GlobalTransform;

		// Apply that local transform to destination portal
		var transformed = DestinationPortal.GlobalTransform * localTransform;

		_portalCamera.GlobalTransform = transformed;
	}
}
