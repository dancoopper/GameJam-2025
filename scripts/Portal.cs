using Godot;
using System;

public partial class Portal : Node3D
{
	[Export] public Portal DestinationPortal;
	private MeshInstance3D _portalSurface;
	private SubViewport _subViewport;
	private Camera3D _portalCamera;

	private bool _isTeleportEnabled = true;

	public override void _Ready()
	{
		_portalSurface = GetNode<MeshInstance3D>("MeshInstance3D");
		_subViewport = GetNode<SubViewport>("SubViewport");
		_portalCamera = _subViewport.GetNode<Camera3D>("Camera3D");

		Vector2 screenSize = GetViewport().GetVisibleRect().Size;
		_subViewport.Size = new Vector2I((int)screenSize.X, (int)screenSize.Y);

		var material = _portalSurface.GetActiveMaterial(0) as ShaderMaterial;
		if (material != null) {
			material.SetShaderParameter("portal_view", _subViewport.GetTexture());
		}
	}

	public override void _Process(double delta)
	{
		var playerCam = GetViewport().GetCamera3D();
		if (playerCam == null || DestinationPortal == null || _portalCamera == null)
			return;
			
		_portalCamera.Rotation = Rotation;

		var localTransform = GlobalTransform.AffineInverse() * playerCam.GlobalTransform;
		var transformed = DestinationPortal.GlobalTransform * localTransform;
		_portalCamera.GlobalTransform = transformed;
	}
	
	public void OnBodyEntered(Node3D body) {
		if (_isTeleportEnabled) {
			_isTeleportEnabled = false;
			
			var offset = body.Position - Position;
			var newPosition = DestinationPortal.Position + offset;
			
			DestinationPortal.OnTeleportedTo();
			body.Position = newPosition;
		}
	}
	
	public void OnTeleportedTo() {
		_isTeleportEnabled = false;
	}

	public void OnBodyExited(Node3D body) {
		_isTeleportEnabled = true;
	}
}
