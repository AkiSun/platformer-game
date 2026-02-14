extends TextureButton
class_name TouchButton

# TouchButton.gd - 虚拟按钮脚本
# 触屏虚拟按钮，将触摸事件映射到 InputMap 动作

## 按钮要触发的 InputMap 动作名称
@export var action_name: String = ""

## 按钮是否切换状态（按下=按下，松开=松开）
@export var is_toggle_mode: bool = true

## 按钮是否可见（调试用）
@export var debug_visible: bool = true

## 按钮按下时的透明度
@export var pressed_opacity: float = 0.7

var original_opacity: float = 1.0

func _ready() -> void:
	# 设置调试可见性
	modulate.a = 1.0 if debug_visible else 0.5
	
	# 连接信号
	pressed.connect(_on_button_pressed)
	button_up.connect(_on_button_released)
	
	# 确保动作存在
	if action_name and not InputMap.has_action(action_name):
		push_warning("TouchButton: Action '" + action_name + "' not found in InputMap")

func _on_button_pressed() -> void:
	if action_name:
		Input.action_press(action_name)
		modulate.a = pressed_opacity

func _on_button_released() -> void:
	if action_name and is_toggle_mode:
		Input.action_release(action_name)
		modulate.a = original_opacity
