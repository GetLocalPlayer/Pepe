using Godot;


namespace PepeStates
{
    class WalkingBackwards : Walking
    {
        public override void Enter(Node context)
        {
            var animTree = context.GetNode<AnimationTree>("AnimationTree");
            var playback = (AnimationNodeStateMachinePlayback)animTree.Get("parameters/playback");
            playback.Travel("WalkingBackwards");
        }
    }
}