extends KinematicBody2D

signal is_dead
signal is_hurt(new_life)

const PlayerHurtSound = preload("res://player/player_hurt_sound.tscn")

export var ACCELERATION : int = 500
export var MAX_SPEED    : int =  80
export var ROLL_SPEED   : int = 120
export var FRICTION     : int = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state       : int     = MOVE
var velocity    : Vector2 = Vector2.ZERO
var roll_vector : Vector2 = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer : AnimationPlayer = $AnimationPlayer
onready var animationTree   : AnimationTree   = $AnimationTree
onready var animationState  : AnimationNodeStateMachinePlayback = animationTree.get("parameters/playback")
onready var hurtbox = $Hurtbox
onready var SwordHitbox     : Area2D = $HitboxPivot/SwordHitbox
onready var blinkAnimationPlayer = $BlinkAnimationPlayer

func _ready() -> void:
	randomize()
	stats.connect("no_health", self, "die")
	animationTree.active = true
	SwordHitbox.knockback_vector = roll_vector

	stats.set_health(4)


func _physics_process(delta : float) -> void:
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)

func move_state(delta : float) -> void:
	var input_vector : Vector2 = Vector2.ZERO

	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		SwordHitbox.knockback_vector = roll_vector
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position",  input_vector)
		animationTree.set("parameters/Attack/blend_position",  input_vector)
		animationTree.set("parameters/Roll/blend_position",  input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, (FRICTION * delta))

	move()

	if Input.is_action_just_pressed("roll"):
		state = ROLL

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state(_delta : float) -> void:
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	if not hurtbox.invincible:
		hurtbox.invincible = true
	move()

func roll_animation_finished() -> void:
	hurtbox.invincible = false
	state = MOVE

func attack_state(_delta : float) -> void:
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished() -> void:
	state = MOVE

func move() -> void:
	velocity = move_and_slide(velocity)

func die() -> void:
	queue_free()
	emit_signal("is_dead")

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	emit_signal("is_hurt", stats.health)
	hurtbox.start_invincibility(0.6)
	hurtbox.create_hit_effect()
	var playerHurtSound = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSound)

func _on_Hurtbox_invincibility_started():
	if not state == ROLL:
		blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")
