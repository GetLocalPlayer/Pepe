using Godot;


public class Idle : State
{

    static string GetPath(string propName) =>
        $"parameters/conditions/{propName}";


    public override void Enter(Node context)
    {
        var animTree = context.GetNode<AnimationTree>("AnimationTree");
        animTree.Set(GetPath("Idle"), true);
    }


    public override void Update(Node context, double delta)
    {
    }


    public override void Exit(Node context)
    {
        var animTree = context.GetNode<AnimationTree>("AnimationTree");
        animTree.Set(GetPath("Idle"), false);
    }
}