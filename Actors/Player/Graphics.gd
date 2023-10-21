extends Node3D

@onready var animationPlayer = $AnimationPlayer
@export var moveAnimationName=""
@export var idleAnimationName=""
@export var attackAnimationName=""
@export var dieAnimationName=""
func playMoveAnimation():
	if(animationPlayer.has_animation(moveAnimationName) and  !animationPlayer.is_playing() or animationPlayer.current_animation !=moveAnimationName):
		animationPlayer.play(moveAnimationName)

func playIdleAnimation():
	if(animationPlayer.has_animation(idleAnimationName) and!animationPlayer.is_playing() or animationPlayer.current_animation != idleAnimationName):
		animationPlayer.play(idleAnimationName)

func playAttackAnimation():
	if(animationPlayer.has_animation(attackAnimationName) and!animationPlayer.is_playing() or animationPlayer.current_animation != attackAnimationName):
		animationPlayer.play(attackAnimationName)

func playDieAnimation():
	if(animationPlayer.has_animation(dieAnimationName) and!animationPlayer.is_playing() or animationPlayer.current_animation != dieAnimationName):
		animationPlayer.play(dieAnimationName)
