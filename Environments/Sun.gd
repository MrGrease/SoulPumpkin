extends DirectionalLight3D

enum ETime {DAY,NIGHT}

@onready var animations :AnimationPlayer = $DayNightAnimationPlayer
@onready var currentState = ETime.DAY


func flip():
	if(currentState == ETime.DAY):
		goToNight()
	else:
		goToDay()

func goToDay():
	animations.play("GoToDayTime")
	currentState=ETime.DAY

func goToNight():
	animations.play("GoToNightTime")
	currentState=ETime.NIGHT
