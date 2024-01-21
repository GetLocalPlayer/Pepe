using Godot;


namespace PepeStates
{
    public class Running : Walking
    {
        public override void Enter(Node context)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var playback = (AnimationNodeStateMachinePlayback)animTree.Get("parameters/playback");
            playback.Travel("Running");
        }


        public override void Update(Node context, double delta)
        {
            base.Update(context, delta);
            var pepe = context as Pepe;
            pepe.Stamina -= (float)delta;
        }
    }
}