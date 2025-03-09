class_name CardUI
extends Control

@export var card_text: String
@export_enum("RED", "BLUE", "GREEN", "YELLOW") var neighbor_bonus_color: String
@export_enum("RED", "BLUE", "GREEN", "YELLOW") var card_color: String

signal card_click(card: CardUI)

@onready var color: ColorRect = $Color
@onready var neighbor_color: ColorRect = $Panel/NeighborColor
@onready var label: Label = $CardText

func get_card_color(what_color) -> Color:
	match what_color:
		"RED":
			return Color("FF8989")
		"BLUE":
			return Color("B7B1F2")
		"GREEN":
			return Color("99BC85")
		"YELLOW":
			return Color("FADA7A")
	return Color.WHITE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = card_text
	color.color = get_card_color(card_color)
	neighbor_color.color = get_card_color(neighbor_bonus_color)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		card_click.emit(self)
