using System;
using System.Collections;
using System.Collections.Generic;
using Godot;


[Tool]
public partial class Consumable : Item
{
    [Export] EffectType _type;
    [Export] float _value = 0f;


    public new Dictionary<string, Action<Item>> Actions = new(){
        {"Use", Use},
    };


    enum EffectType
    {
        RestoreHealth,
    }


    public override void _Ready()
    {
        base._Ready();
        foreach (var entry in Actions)
            base.Actions.Add(entry.Key, entry.Value);
    }

    public static void Use(Item item)
    {
        var consumable = item as Consumable;
        switch (consumable._type)
        {
            case EffectType.RestoreHealth:
            {
                item.GetTree().CallGroup("Player", "RestoreHealth", consumable._value);
                break;
            }
        }
        
    }
}