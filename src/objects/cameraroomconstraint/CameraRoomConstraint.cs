using Godot;
using System;
using System.Runtime.CompilerServices;


/* A node that is used as a room with a camera attached
to its ceiling. The camera will be following the target
at the given distance INSIDE the room, the camera
cannot leave the room. If the target is outside the room
the camera tries to find the clossest to the target
position on the ceiling for which Plane class is used.

The name of the target must be specified in "Target
Node Name" property in the inspector. The target
can have "CameraTarget" node whose position will
be used to LookAt.

Area3D is used to detect collision with the target
and make its camera current.*/

public partial class CameraRoomConstraint : Area3D
{
    [Export] bool _makeCameraCurrentOnEnter = true;
    [Export] string _targetNodeName = "Player";
    [Export] float _cameraDistance = 3;
    [Export] float _cameraTweenTime = 1f;
    /* Relative coords to colision shape. */
    Plane _ceiling;
    Node3D _target;
    Camera3D _camera;


    public override void _Ready()
    {
        var shape = GetNode<CollisionShape3D>("CollisionShape3D");

        if (shape.Shape == null)
            throw new Exception($"{Name} - no collision shape found!");
        if (!(shape.Shape is BoxShape3D))
            throw new Exception($"{Name} - collision shape must be 'BoxShape3D'!");

        var box = shape.Shape as BoxShape3D;
        box.Changed += UpdateCeiling;

        UpdateCeiling();

        _camera = GetNode<Camera3D>("Camera3D");
        _camera.GlobalPosition = shape.ToGlobal( Vector3.Zero with { Y = box.Size.Y/2 } );

        BodyEntered += OnBodyEntered;

        _ceiling = new Plane(shape.Basis.Y, box.Size.Y/2);
    }


    void UpdateCeiling()
    {
        var shape = GetNode<CollisionShape3D>("CollisionShape3D");
        var box = shape.Shape as BoxShape3D;
        _ceiling = new Plane(shape.Basis.Y, box.Size.Y/2);
    }


    void OnBodyEntered(Node3D body)
    {
        if (body.Name == _targetNodeName)
        {
            _target = body.HasNode("CameraTarget") ?  body.GetNode<Node3D>("CameraTarget") : body;
            if (_makeCameraCurrentOnEnter)
                _camera.MakeCurrent();
        }
    }


    public override void _Process(double delta)
    {
        if (GetViewport().GetCamera3D() == _camera && _target != null)
            UpdateCamera(delta);
    }


    void UpdateCamera(double delta)
    {
        var shape = GetNode<CollisionShape3D>("CollisionShape3D");

        var camPos = shape.ToLocal(_camera.GlobalPosition);
        var tarPos = shape.ToLocal(_target.GlobalPosition);
        var proj = _ceiling.Project(tarPos);
        
        var dist = Math.Sqrt(_cameraDistance * _cameraDistance + _ceiling.D * _ceiling.D);
        var newCamPos = proj.MoveToward(camPos, (float)dist);
        var newCamPosGlobal = shape.ToGlobal(newCamPos);
        
        var newTransform = _camera.GlobalTransform
            .Translated(newCamPosGlobal - _camera.GlobalPosition)
            .LookingAt(_target.GlobalPosition);
        
        _camera.GlobalTransform = _camera.GlobalTransform.InterpolateWith(newTransform, (float)delta / _cameraTweenTime);
    }
}
