extends Control

func _on_start_button_pressed():
	get_tree().reload_current_scene()
	get_tree().paused = false


func _on_quit_button_pressed():
	get_tree().quit()
