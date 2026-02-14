extends CanvasLayer
class_name TouchControls

# TouchControls.gd - 触屏控制系统
# 管理所有虚拟按钮的布局和显示

## 是否启用触屏控制（自动检测）
@export var enable_touch_controls: bool = true

## 按钮大小
@export var button_size: Vector2 = Vector2(80, 80)

## 按钮间距
@export var button_margin: float = 20.0

## 左侧区域偏移
@export var left_area_offset: Vector2 = Vector2(30, 0)

## 右侧区域偏移
@export var right_area_offset: Vector2 = Vector2(-30, 0)

@onready var left_panel: Control = $LeftPanel
@onready var right_panel: Control = $RightPanel
@onready var btn_left: TextureButton = $LeftPanel/BtnLeft
@onready var btn_right: TextureButton = $LeftPanel/BtnRight
@onready var btn_jump: TextureButton = $RightPanel/BtnJump
@onready var btn_attack: TextureButton = $RightPanel/BtnAttack
@onready var btn_dash: TextureButton = $RightPanel/BtnDash

func _ready() -> void:
	# 自动检测是否需要触屏控制
	if enable_touch_controls:
		# 在不支持触屏的设备上隐藏
		if not DisplayServer.is_touchscreen_available():
			visible = false
			set_process(false)
		else:
			_setup_button_positions()

func _setup_button_positions() -> void:
	# 左侧移动按钮
	if btn_left:
		btn_left.action_name = "move_left"
		btn_left.custom_minimum_size = button_size
	
	if btn_right:
		btn_right.action_name = "move_right"
		btn_right.custom_minimum_size = button_size
	
	# 右侧动作按钮
	if btn_jump:
		btn_jump.action_name = "jump"
		btn_jump.custom_minimum_size = button_size
	
	if btn_attack:
		btn_attack.action_name = "attack"
		btn_attack.custom_minimum_size = button_size
	
	if btn_dash:
		btn_dash.action_name = "dash"
		btn_dash.custom_minimum_size = button_size

func _process(_delta: float) -> void:
	# 可选：处理多指触控等高级功能
	pass
