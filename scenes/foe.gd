extends Node2D

@export var max_hp: int = 37
@export var current_hp: int = 21

@onready var _animated_sprite = $AnimatedSprite2D
@onready var health_bar = $HealthBar
@onready var hp_label = $HealthBar/HP_Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_health_bar()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	_animated_sprite.play("default")

func take_damage(damage: int):
	if current_hp < 1:
		return
	current_hp -= damage
	current_hp = clamp(current_hp, 0, max_hp)
	update_health_bar()

func update_health_bar():
	
	if health_bar:
		health_bar.value = current_hp
	if hp_label:
		hp_label.text = str(current_hp) + " / " + str(max_hp)

	if current_hp <= 0:
		die()

func die():
	queue_free()
	print("Victory!")
