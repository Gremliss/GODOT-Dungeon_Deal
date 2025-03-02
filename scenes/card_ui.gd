class_name CardUI
extends Control

#@export var base_value: int = 1
@export var card_text: String = "Random text"
#var total_value: int = 1 
@export_enum("RED", "BLUE", "GREEN", "YELLOW") var neighbor_bonus_color: String = "GREEN"
#var foe: Node = null

@export_enum("RED", "BLUE", "GREEN", "YELLOW") var card_color: String = "GREEN"

func get_card_color() -> Color:
	match card_color:
		"RED":
			return Color("FF8989")
		"BLUE":
			return Color("B7B1F2")
		"GREEN":
			return Color("99BC85")
		"YELLOW":
			return Color("FADA7A")
	return Color.GREEN

var card_ui: CardUI

signal card_click

@onready var color: ColorRect = $Color
@onready var label: Label = $State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = card_text
	color.color = get_card_color()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

#signal reparent_requested(which_card_ui: CardUI)



#func hon_gui_input(event: InputEvent) -> void:
	#if not card_ui.playable or card_ui.disabled:
		#return
		#
	#if event.is_action_pressed("left_mouse"):
		#card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		#transition_requested.emit(self, CardState.State.CLICKED)


func _on_gui_input(event: InputEvent) -> void:
	#print("Victory!")
	if event.is_action_pressed("click"):
		#$Color.color  = Color.WEB_GREEN
		#$State.text = "Clicked"
		card_click.emit()
