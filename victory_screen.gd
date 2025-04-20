extends CanvasLayer

@onready var btnPlayAgain = $"Play Again"
@onready var lblResult = $lblResult
@onready var sndVictory = $"Victory Sound"

signal click_end()

func _ready():
	lblResult.text = "You Win!"
	sndVictory.play()
	btnPlayAgain.pressed.connect(_on_play_again_pressed)

func _on_play_again_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://TitleScreen/menu.tscn")
	emit_signal("click_end")
