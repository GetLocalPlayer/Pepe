using Godot;


namespace PepeStates
{
    public class Idle : State
    {
        protected string _animState = "Idle";


        public override void Enter(Node context)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var playback = (AnimationNodeStateMachinePlayback)animTree.Get("parameters/playback");
            playback.Travel(_animState);
            var body = context as CharacterBody3D;
            body.UpDirection = Vector3.Up;
            body.Velocity = Vector3.Up * (-(context as Pepe).Gravity);
        }


        public override void Update(Node context, double delta)
        {
            var body = context as CharacterBody3D;
            body.MoveAndSlide();
            (context as Pepe).Stamina += (float)delta;
        }


        public override void Exit(Node context)
        {
        }
    }

}