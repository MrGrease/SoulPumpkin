extends Control

@onready var healthLabel = $HealthLabel
@onready var SoulsLabel = $SoulsLabel
@onready var AmmoLabel = $AmmoLabel
@onready var situationLabel = $SituationText
@onready var resetTimer = $ResetTimer
func updateHUDHealth(currentHealth):
	healthLabel.text = "HEALTH: "+str(currentHealth)

func _on_health_manager_signal_dead():
	healthLabel.text = "DEAD"
	showDeadUI()

func updateHudAmmo(currentAmmo):
	AmmoLabel.text = "AMMO: "+str(currentAmmo)

func showDeadUI():
	$RestartLabel.show()

func _on_timer_timeout():
	situationLabel.text = ""

func setTemporarySituationText(text):
	situationLabel.text=text
	resetTimer.start()


func _on_inventory_manager_display_unlock_text(text):
	setTemporarySituationText(text)

func display_game_end_text():
	situationLabel.text="You win! Press R to restart"
