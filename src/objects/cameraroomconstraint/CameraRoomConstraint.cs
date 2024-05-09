using Godot;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;


/* A node that is used as a room with a camera attached
to its ceiling. The camera will be following the target
at the given distance INSIDE the room, the camera
cannot leave the room. If the target is outside the room
the camera tries to find the clossest to the target
position on the ceiling. Ceiling is represented as a
Plane instance with its edges represented as a Curve3D
instance for calculating the closest point to the target
on the edges of the ceiling.

The name of the target must be specified in "Target
Node Name" property in the inspector. The target
can have "CameraTarget" node whose position will
be used in LookAt.

Area3D is used to detect collision with the target
and make its camera current.*/

public partial class CameraRoomConstraint : Area3D
{
    [Export] bool _makeCameraCurrentOnEnter = true;
    [Export] string _targetNodeName = "Player";
    [Export] float _cameraDistance = 3;
    [Export] float _cameraTweenTime = 1f;
    /* Relative coords to colision shape. */
    Plane _ceilingPlane;
    Curve3D _ceilingEdges;
    Node3D _target;
    Camera3D _camera;



    public override void _Ready()
    {
        var shape = GetNodeOrNull<CollisionShape3D>("CollisionShape3D");

        if (shape.Shape == null)
            throw new Exception($"{Name} - no collision shape found!");
        if (!(shape.Shape is BoxShape3D))
            throw new Exception($"{Name} - collision shape must be 'BoxShape3D'!");

        var box = shape.Shape as BoxShape3D;
        box.Changed += UpdateCeiling;

        _camera = GetNode<Camera3D>("Camera3D");
        var ceilingCenterGlobal = shape.ToGlobal( Vector3.Zero with { Y = box.Size.Y/2 } );
        _camera.GlobalPosition = _camera.GlobalPosition with { Y = ceilingCenterGlobal.Y };

        BodyEntered += OnBodyEntered;

        _ceilingPlane = new Plane();
        _ceilingEdges = new Curve3D();
        UpdateCeiling();
    }


    void UpdateCeiling()
    {
        var shape = GetNode<CollisionShape3D>("CollisionShape3D");
        var box = shape.Shape as BoxShape3D;
        var halfSize = box.Size/2;

        _ceilingPlane.D = halfSize.Y;
        _ceilingPlane.Normal = shape.Basis.Y;
        
        _ceilingEdges.ClearPoints();
        _ceilingEdges.BakeInterval = float.MaxValue;
        var p1 = halfSize;
        var p2 = halfSize with { X = -halfSize.X };
        var p3 = halfSize with { X = -halfSize.X, Z = -halfSize.Z };
        var p4 = halfSize with { Z = -halfSize.Z };
        _ceilingEdges.AddPoint(p1);
        _ceilingEdges.AddPoint(p2);
        _ceilingEdges.AddPoint(p3);
        _ceilingEdges.AddPoint(p4);
    }


    void OnBodyEntered(Node3D body)
    {
        if (body.Name == _targetNodeName)
        {
            _target = body.HasNode("CameraTarget") ?  body.GetNode<Node3D>("CameraTarget") : body;
            if (_makeCameraCurrentOnEnter)
                if (!_camera.Current)
                {
                    _camera.MakeCurrent();
                    UpdateCamera(_cameraTweenTime);
                }
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
        var proj = _ceilingPlane.Project(tarPos);
        
        var dist = Math.Sqrt(_cameraDistance * _cameraDistance + _ceilingPlane.D * _ceilingPlane.D);
        var newCamPos = proj.MoveToward(camPos, (float)dist);

        /* Checking if the new camera position is inside 
        the ceiling edges by checking the dot product's
        sign of each edge and the vector to the new camera
        position from the first point of each edge. */
        var points = new List<Vector3>(_ceilingEdges.GetBakedPoints());
        points.Add(points[0]);
        var firstSign = Math.Sign( (points[1] - points[0]).Dot(newCamPos - points[0]) );
        for (int i = 1; i < points.Count - 1; i++)
        {
            var p1 = points[i];
            var p2 = points[i + 1];
            var v1 = p2 - p1;
            var v2 = newCamPos - p1;
            var dot = v1.Dot(v2);
            var sign = Math.Sign(dot);
            if (sign != 0 && sign != firstSign)
            {
                newCamPos = _ceilingEdges.GetClosestPoint(newCamPos);
                break;
            }
        }

        var newTransform = _camera.GlobalTransform
            .Translated(shape.ToGlobal(newCamPos) - _camera.GlobalPosition)
            .LookingAt(_target.GlobalPosition);
        
        _camera.GlobalTransform = _camera.GlobalTransform.InterpolateWith(newTransform, (float)delta / _cameraTweenTime);
    }
}
