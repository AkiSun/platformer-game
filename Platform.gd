#ifndef PLATFORM_GD
#define PLATFORM_GD

extends StaticBody2D

# Platform.gd - 平台节点脚本
# 支持普通平台和单向平台

@export var is_one_way: bool = false  # 是否为单向平台（可从下方穿过）
@export var is_ladder: bool = false   # 是否为梯子

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect = $ColorRect

func _ready() -> void:
	_setup_collision()
	_setup_visual()

func _setup_collision() -> void:
	if collision_shape:
		if is_one_way:
			# 单向平台设置
			collision_shape.one_way_collision = true
			collision_shape.one_way_collision_margin = 2.0

func _setup_visual() -> void:
	if visual:
		if is_ladder:
			visual.color = Color(0.6, 0.4, 0.2)  # 棕色 - 梯子
		elif is_one_way:
			visual.color = Color(0.3, 0.6, 0.3)    # 绿色 - 平台
		else:
			visual.color = Color(0.4, 0.3, 0.25)   # 棕色 - 地面

# 设置平台大小
func set_size(width: float, height: float) -> void:
	if visual:
		visual.size = Vector2(width, height)
	if collision_shape:
		collision_shape.shape = RectangleShape2D.new()
		collision_shape.shape.size = Vector2(width, height)

#endif
