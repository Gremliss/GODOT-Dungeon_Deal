class_name Battle
extends Node2D

const MAX_PLAYED_CARDS := 3
var played_cards := []
var base_value := 1
var total_value := 0
var discard_pile := []

@onready var foe = $Foe
@onready var hand = $BattleUI/Hand
@onready var played_hand = $BattleUI/PlayedCards
@onready var discarded_cards = $BattleUI/DiscardedCards

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for card in $BattleUI/Hand.get_children():
		card.card_click.connect(_change_card_place.bind(card))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func _change_card_place(card: CardUI):
	if card.get_parent() == hand:
		if played_cards.size() < MAX_PLAYED_CARDS:
			card.get_parent().remove_child(card)
			played_hand.add_child(card)
			played_cards.append(card)
	else:
		card.get_parent().remove_child(card)
		hand.add_child(card)
		played_cards.erase(card)


func _on_button_pressed() -> void:
	total_value = 0
	for i in range(played_cards.size()):
		calculate_value(i)
	if $Foe:
		foe.take_damage(total_value)
	discard_pile.append_array(played_cards)
	for card in played_hand.get_children():
		#print(card)
		discarded_cards.add_child(card)
		card.queue_free()
		print(discarded_cards.get_children())
	played_cards.clear()
	

func calculate_value(index: int):
	var card = played_cards[index]
	var left_neighbor = played_cards[index - 1] if index > 0 else null
	var right_neighbor = played_cards[index + 1] if index < played_cards.size() - 1 else null

	# Sprawdzamy tylko bezpośrednich sąsiadów
	if left_neighbor and left_neighbor.card_color == card.neighbor_bonus_color:
		total_value += 1
	if right_neighbor and right_neighbor.card_color == card.neighbor_bonus_color:
		total_value += 1


func _on_show_discard_pressed() -> void:
	pass # Replace with function body.
