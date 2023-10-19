extends Node3D

func _ready():
	var sun = get_tree().get_nodes_in_group("Sun")[0]
	if(sun.currentState==0):#day
		hide()
	else:
		show()
