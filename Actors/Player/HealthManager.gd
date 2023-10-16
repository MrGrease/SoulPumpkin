extends Node3D

var maxHealth = 100
var currentHealth = 100

signal signalDead
signal signalHurt
signal signalHeal

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

func heal(healing):
	if currentHealth <=0:
		return
	currentHealth += healing
	emit_signal("signalHeal")

