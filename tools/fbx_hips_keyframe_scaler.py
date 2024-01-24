import bpy


"""
Moximo saves models with the armature scaled by 0.01 by who knows
what reason. This scale must be applied to the armature otherwise
the model is gonna be way too big. But after scaling is applying
the animation gets screwed up, but, hopefully, only in case of
location of one single "Hips" bone tha can be downscaled by 100
to math the new applied scale. This script does it automatically,
thanks to Joe_Kerr
https://forum.babylonjs.com/t/if-mixamo-transformations-and-bone-alignements-messed-up/29038
"""


for a in bpy.data.actions:
    for fc in a.fcurves:
        if "location" not in fc.data_path:
            continue       
        if "Hips" in fc.data_path:
            for kf in fc.keyframe_points:
                kf.co[1] = kf.co[1]/100  #BEWARE: read below
        else:
            a.fcurves.remove(fc)
            
ob = bpy.context.object
for pb in ob.pose.bones:
    pb.location = (0,0,0)
    
bpy.ops.object.transform_apply(scale = True)