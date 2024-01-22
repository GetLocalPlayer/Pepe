using System;
using Godot;


namespace PepeStates
{
    public class Walking : State 
    {
        const string _turnLeftAction = "TurnLeft";
        const string _turnRightAction = "TurnRight";

        public override void Enter(Node context)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var playback = (AnimationNodeStateMachinePlayback)animTree.Get("parameters/playback");
            playback.Travel("Walking");
        }

        public override void Exit(Node context)
        {
        }

        public override void Update(Node context, double delta)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var motion = animTree.GetRootMotionPosition()/(float)delta;
            var pepe = context as Pepe;
            var rotation = Input.IsActionPressed(_turnLeftAction) ? pepe.TurnSpeed : Input.IsActionPressed(_turnRightAction) ? - pepe.TurnSpeed : 0f;
            var body = context as CharacterBody3D;
            body.RotateY(rotation * (float)delta * (float)Math.PI / 180f);
            var gravity = body.UpDirection * (-pepe.Gravity);
            var forward = body.Transform.Basis.GetRotationQuaternion() * motion;
            body.Velocity = gravity + forward;
            body.MoveAndSlide();
        }
    }

}