extends DirectionalLight3D

enum ETime {DAY=0,NIGHT=1}

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
	get_tree().call_group("daynighteffected", "setDayTime")
	get_tree().call_group("hideOnDay", "hide")

func goToNight():
	animations.play("GoToNightTime")
	currentState=ETime.NIGHT
	get_tree().call_group("daynighteffected", "setNightTime")
	get_tree().call_group("hideOnDay", "show")
