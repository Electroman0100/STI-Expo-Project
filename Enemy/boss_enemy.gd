extends CharacterBody2D


@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_recovery = 3.5
@export var experience = 1
@export var enemy_damage = 1

var knockback = Vector2.ZERO


@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var snd_hit = $snd_hit
@onready var hitBox = $HitBox
@onready var collision = $CollisionShape2D
@onready var hurtbox = $HurtBox
@onready var hideTimer = $HideTimer
@export var is_boss: bool = false

var death_anim = preload("res://Enemy/explosion.tscn")
var exp_gem = preload("res://Objects/experience_gem.tscn")

var screen_size

func _ready():
	anim.play("walk")
	hitBox.damage = enemy_damage
	screen_size = get_viewport_rect().size
	hurtbox.connect("hurt", Callable(self, "on_hurt_box_hurt"))
	hideTimer.connect("timeout", Callable(self, "on_hide_timer_timeout"))

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_recovery)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = true
	elif direction.x < -0.1:
		sprite.flip_h = false

func death():
	if is_boss:
		_on_boss_defeated()
	else:
		queue_free()



func _on_hurt_box_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle * knockback_amount
	if hp <= 0:
		death()
	else:
		snd_hit.play()
		
func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount:
		collision.call_deferred("set","disabled",true)
		anim.stop()

func _on_boss_defeated():
	var victory_scene = preload("res://VictoryScreen.tscn").instantiate()
	get_tree().get_root().add_child(victory_scene)
	get_tree().paused = true

func _on_hide_timer_timeout():
	var location_dif = global_position - player.global_position
	if abs(location_dif.x) > (screen_size.x/2) * 1.4 || abs(location_dif.y) > (screen_size.y/2) * 1.4:
		visible = false
	else:
		visible = true
