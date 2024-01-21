using Godot;


namespace PepeStates
{
    public class Jumping : State
    {
        public override void Enter(Node context)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var playback = (AnimationNodeStateMachinePlayback)animTree.Get("parameters/playback");
            playback.Travel("Jumping");
            var body = context as CharacterBody3D;
            body.UpDirection = Vector3.Up;
        }


        public override void Update(Node context, double delta)
        {
            var body = context as CharacterBody3D;
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var motion = animTree.GetRootMotionPosition()/(float)delta;
            body.Velocity = motion;
            body.MoveAndSlide();
        }


        public override void Exit(Node context)
        {
        }
    }
}