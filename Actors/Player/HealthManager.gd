extends Node3D

@export var maxHealth = 100
@export var currentHealth = 100

signal signalDead
signal signalHurt
signal signalHeal
signal healthChanged
func _ready():
	init()

func init():
	currentHealth=maxHealth

func hurt(damage):
	print("taking damange")
	print(damage)
	if currentHealth <=0:
		return
	else:
		currentHealth-=damage
	if currentHealth <=0:
		emit_signal("signalDead")
	emit_signal("signalHurt")
	emit_signal("healthChanged")

func heal(healing):
	if currentHealth <=0:
		return
	currentHealth += healing
	emit_signal("signalHeal")
	emit_signal("healthChanged")

