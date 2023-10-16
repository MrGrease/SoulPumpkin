extends Node3D

@onready var weapons = self.get_children(false)
@onready var anim_player = $AnimationPlayer
@onready var alert_area_hearing = $AlertAreaHearing
@onready var alert_area_los = $AlertAreaLos
var cur_slot = 0
var cur_weapon = null
var bodies_to_exclude : Array = []
var isDay : bool = true

signal ammo_changed

func _ready():
	pass

func init(_bodies_to_exclude : Array):
	bodies_to_exclude = _bodies_to_exclude
	for weapon in weapons:
		if weapon.has_method("init"):
			weapon.init(bodies_to_exclude)
	switch_to_weapon_slot(0)
	
	for weapon in weapons:
		weapon.connect("fired",emit_ammo_changed_signal)
		#weapon.connect("fired",alert_nearby_enemies)
	
	var sun = get_tree().get_nodes_in_group("Sun")[0] #not a great thing to do according to some docs but its ok if its just once on init
	if(sun.currentState==0):#day
		isDay=true
	else:
		isDay=false

func attack(attack_input_just_pressed:bool,attack_input_held:bool):
	if cur_weapon && cur_weapon.has_method("attack"):
		cur_weapon.attack(attack_input_just_pressed,attack_input_held,isDay)

func get_inventory_size():
	return weapons.size()

func is_index_unlocked(slot_ind:int):
	return weapons[slot_ind].unlocked

func switch_to_next_weapon():
	cur_slot = (cur_slot + 1) % weapons.get_child_count()
	if !is_index_unlocked(cur_slot):
		switch_to_next_weapon()
	else:
		switch_to_weapon_slot(cur_slot)

func switch_to_last_weapon():
	cur_slot = posmod((cur_slot - 1),get_inventory_size())
	if !is_index_unlocked(cur_slot):
		switch_to_last_weapon()
	else:
		switch_to_weapon_slot(cur_slot)

func switch_to_weapon_slot(slot_ind:int):
	if slot_ind < 0 or slot_ind >=get_inventory_size():
		return
	if !is_index_unlocked(cur_slot):
		return
	disable_all_weapons()
	cur_weapon = weapons[slot_ind]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active()
	else:
		cur_weapon.show()
	emit_ammo_changed_signal()

func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_inactive"):
			weapon.set_inactive()
		else:
			weapon.hide()

func update_animation(velocity:Vector3,grounded:bool):
	if cur_weapon.has_method("is_idle") and !cur_weapon.is_idle():
		anim_player.play("idle",1)
	if !grounded or velocity.length() < 15.0:
		anim_player.play("idle",1)
	anim_player.play("moving",1)

func _on_character_mover_movement_info(velocity,grounded):
	update_animation(velocity,grounded)

func alert_nearby_enemies():
	var nearby_enemies = alert_area_los.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert()
	nearby_enemies = alert_area_hearing.get_overlapping_bodies()
	for nearby_enemy in nearby_enemies:
		if nearby_enemy.has_method("alert"):
			nearby_enemy.alert(false)

func get_ammo_pickup(weapon_id,ammo):
	for weapon in weapons:
		if ("inventory_id" in weapon and weapon.inventory_id == weapon_id):
			weapon.ammo += ammo
			emit_ammo_changed_signal()

func emit_ammo_changed_signal():
	emit_signal("ammo_changed",cur_weapon.ammo)
	print(cur_weapon.ammo)

func setDayTime():
	isDay=true

func setNightTime():
	isDay=false
