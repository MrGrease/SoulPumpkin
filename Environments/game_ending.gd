extends Node3D

func lower():
	get_tree().call_group("HUD","display_game_end_text")
	get_tree().call_group("player","end_game")
