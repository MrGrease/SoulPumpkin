extends Node3D

var body : CharacterBody3D = null
var movementVector : Vector3
var velocity : Vector3
var gravity = 60
var speed = 20
var acceleration = 5
var jumpStrength = 30

var aboutToJump = false
func setBody(_body:CharacterBody3D):
	body = _body

func _physics_process(delta):
	var currentMovementVector= movementVector
	currentMovementVector = currentMovementVector.rotated(Vector3.UP, body.rotation.y)
	velocity += acceleration * currentMovementVector - velocity + gravity * Vector3.DOWN * delta
	
	if body.is_on_floor() and aboutToJump:
		velocity.y = jumpStrength
		aboutToJump=false
		body.velocity=velocity
	if(body):
		body.velocity=velocity
		body.move_and_slide()
	else:
		print("no body exists!")

func jump():
	aboutToJump=true

func setMovementVector(_movementVector: Vector3):
	movementVector = _movementVector.normalized()