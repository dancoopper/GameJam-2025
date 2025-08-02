using Godot;
using System;

public partial class SubViewportSize : SubViewport
{
	public override void _Ready() {
		Size = GetWindow().Size;
	}
}
