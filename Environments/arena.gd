extends Node3D

@export var door:Node3D = null
@export var enemyCount = 0

var killedEnemies = 0

func reportEnemyKilled():
	killedEnemies=killedEnemies+1
	if(killedEnemies>=enemyCount):
		door.lower()
