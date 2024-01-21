using Godot;
using System;


public partial class ConstrainedCamera : Area3D
{
    [Export] string _targetNodeName = "Player";
    [Export] float _cameraDistance = 3;
    [Export] bool _makeCameraCurrent = false;

    Node3D target;
    Camera3D camera;


    public override void _Ready()
    {
        camera = GetNode<Camera3D>("Camera3D");

        BodyEntered += (Node3D body) =>
        {
            if (body.Name == _targetNodeName)
            {
                target = body.HasNode("CameraTarget") ? body.GetNode<Node3D>("CameraTarget") : body;
                if (_makeCameraCurrent) MakeCameraCurrent();
            }
        };

        BodyExited += (Node3D body) =>
        {
            if (body == target || body.GetNodeOrNull<Node3D>("CameraTarget") == target)
                target = null;
        };
    }


    public override void _Process(double delta)
    {
        if (target != null) UpdateCamera(delta);
    }


    protected void UpdateCamera(double delta)
    {
        var tarPos = target.GlobalPosition;
        var camPos = camera.GlobalPosition;

        var diff = camPos - tarPos;
        var a = Math.Abs(diff.Y);
        var c = _cameraDistance;
        var b = c - a;
        
        var offsetXZ = new Vector3(diff.X, 0, diff.Z).Normalized() * b;
        
        var newPos = tarPos + offsetXZ + new Vector3(0, diff.Y, 0);
        GD.Print(newPos);
        
        camera.GlobalPosition = newPos;

        camera.GlobalTransform = camera.GlobalTransform.LookingAt(tarPos);
    }


    public void MakeCameraCurrent()
    {
        camera.MakeCurrent();
    }
}
