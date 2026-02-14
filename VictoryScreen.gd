extends PanelContainer
class_name VictoryScreen

# VictoryScreen.gd - 胜利界面脚本

signal restart_requested

@onready var restart_button: Button = $VBox/RestartButton

func _ready() -> void:
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)
	print("VictoryScreen initialized")

func _on_restart_pressed() -> void:
	emit_signal("restart_requested")
