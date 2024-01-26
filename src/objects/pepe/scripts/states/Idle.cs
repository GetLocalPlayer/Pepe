using Godot;


namespace PepeStates
{
    public class Idle : State
    {
        protected string _animState = "Idle";
        protected string _animTreeParam = "parameters/Idle/blend_position";
        protected string _turnLeftAction = "TurnLeft";
        protected string _turnRightAction = "TurnRight";
        protected float _tweenTime = 0.3f;
        private Tween _tween;


        public override void Enter(Node context)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");

            animTree.Set(_animTreeParam, 0f);
            _tween = animTree.CreateTween();
            var value = 0f + (Input.IsActionPressed(_turnLeftAction) ? - 1f : (Input.IsActionPressed(_turnRightAction) ? 1f : 0f));
            _tween.TweenProperty(animTree, _animTreeParam, value, _tweenTime);

            var playback = (AnimationNodeStateMachinePlayback)animTree.Get("parameters/playback");
            playback.Travel(_animState);
            var body = context as CharacterBody3D;
            body.UpDirection = Vector3.Up;
            body.Velocity = Vector3.Up * (-(context as Pepe).Gravity);
        }


        public override void Update(Node context, double delta)
        {
            var body = context as CharacterBody3D;
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var rotation = animTree.GetRootMotionRotation() / (float)delta;
            body.RotateY(rotation.Normalized().GetEuler(EulerOrder.Yxz).Y);
            var pepe = context as Pepe;
            pepe.Stamina += (float)delta * pepe.StaminaRestorationRate;
        }


        public override void Exit(Node context)
        {
            _tween?.Kill();
        }


        public override void HandleInput(Node context, InputEvent @event)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            _tween?.Kill();
            _tween = animTree.CreateTween();
            var value = 0f + (Input.IsActionPressed(_turnLeftAction) ? - 1f : (Input.IsActionPressed(_turnRightAction) ? 1f : 0f));
            _tween.TweenProperty(animTree, _animTreeParam, value, _tweenTime);
        }
    }

}