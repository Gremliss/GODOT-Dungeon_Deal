class_name Battle
extends Node2D

const MAX_PLAYED_CARDS := 4
var total_value := 0
var played_cards_array := []
var discard_pile := []
var deck := []

var player_max_hp: int = 55
var player_current_hp: int = 44

@onready var foe = $Foe
@onready var hand = $BattleUI/Hand
@onready var played_hand = $BattleUI/PlayedCards
@onready var discarded_cards = $BattleUI/DiscardBackground/CenterContainer/ScrollContainer/DiscardedCards
@onready var discard_background = $BattleUI/DiscardBackground
@onready var deck_background = $BattleUI/DeckBackground
@onready var deck_cards = $BattleUI/DeckBackground/CenterContainer/ScrollContainer/DeckCards
@onready var player_health_bar = $BattleUI/PlayerHealthBar
@onready var player_hp_label = $BattleUI/PlayerHealthBar/HP_Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	discard_background.visible = false
	deck_background.visible = false
	
	for i in range(40):
		var new_card = preload("res://scenes/card_ui.tscn").instantiate() as CardUI
		new_card.card_text = "Card " + str(i+1)
		
		# Random card color
		var colors = ["RED", "BLUE", "GREEN", "YELLOW"]
		new_card.card_color = colors[randi() % colors.size()]
		new_card.neighbor_bonus_color = colors[randi() % colors.size()]
		
		deck.append(new_card)
		deck_cards.add_child(new_card)
		
	update_health_bar()
	draw_cards(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass

func draw_cards(amount: int):
	if deck.size() < amount:
		print("Empty deck! Shuffling discard")
		for card in discard_pile:
			discarded_cards.remove_child(card)
			deck_cards.add_child(card)
			deck.append(card)
		discard_pile.clear()
		deck.shuffle()
		
	deck.shuffle()
	var drawn_cards = deck.slice(0, amount)
	deck = deck.slice(amount, deck.size())
	
	for card in drawn_cards:
		deck_cards.remove_child(card)
		hand.add_child(card)
		card.card_click.connect(_change_card_place)

func _change_card_place(card: CardUI):
	if card.get_parent() == hand:
		if played_cards_array.size() < MAX_PLAYED_CARDS:
			hand.remove_child(card)
			played_hand.add_child(card)
			played_cards_array.append(card)
	else:
		played_hand.remove_child(card)
		hand.add_child(card)
		played_cards_array.erase(card)


func _on_button_pressed() -> void:
	player_take_damage(1)
	total_value = 0
	for i in range(played_cards_array.size()):
		calculate_value(i)
		
	if $Foe:
		foe.take_damage(total_value + 10)
		
	# Move to discard pile
	discard_pile.append_array(played_cards_array)
	
	for card in played_hand.get_children().duplicate():
		played_hand.remove_child(card)
		discarded_cards.add_child(card)
		
	played_cards_array.clear()
	
	for card in hand.get_children().duplicate():
		hand.remove_child(card)
		discarded_cards.add_child(card)
		discard_pile.append(card)
		
	draw_cards(5)

func calculate_value(index: int):
	var card = played_cards_array[index]
	var left_neighbor = played_cards_array[index - 1] if index > 0 else null
	var right_neighbor = played_cards_array[index + 1] if index < played_cards_array.size() - 1 else null

	if left_neighbor and left_neighbor.card_color == card.neighbor_bonus_color:
		total_value += 1
	if right_neighbor and right_neighbor.card_color == card.neighbor_bonus_color:
		total_value += 1

func _on_show_discard_pressed() -> void:
	discard_background.visible = !discard_background.visible


func _on_show_deck_pressed() -> void:
	deck_background.visible = !deck_background.visible

func update_health_bar():
	if player_health_bar:
		player_health_bar.value = player_current_hp
	if player_hp_label:
		player_hp_label.text = str(player_current_hp) + " / " + str(player_max_hp)

	if player_current_hp <= 0:
		player_die()

func player_die():
	print("You Loose")
	
func player_take_damage(damage: int):
	if player_current_hp < 1:
		return
	player_current_hp -= damage
	player_current_hp = clamp(player_current_hp, 0, player_max_hp)
	update_health_bar()
