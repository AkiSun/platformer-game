extends Area2D

# Ladder.gd - 梯子系统
# 允许玩家攀爬的梯子区域

## 梯子参数
@export var climb_speed: float = 150.0
@export var ladder_top_y: float = 0.0  # 梯子顶部Y坐标

## 状态
var is_player_in_ladder: bool = false
var player: CharacterBody2D = null

## 节点引用
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	# 连接信号
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	print("Ladder initialized at ", global_position)

func _physics_process(delta: float) -> void:
	if is_player_in_ladder and player:
		_handle_climbing(delta)

func _handle_climbing(delta: float) -> void:
	if not player or not "velocity" in player:
		return
	
	var climb_direction := 0.0
	
	if Input.is_action_pressed("move_up"):
		climb_direction = -1.0
	elif Input.is_action_pressed("move_down"):
		climb_direction = 1.0
	
	# 如果在梯子上且按下上下键，进入攀爬状态
	if climb_direction != 0.0:
		player.velocity.y = climb_direction * climb_speed
		player.velocity.x = 0  # 禁用水平移动
		
		# 设置攀爬状态
		if "is_climbing" in player:
			player.is_climbing = true
		
		# 更新动画
		if "sprite" in player and player.sprite:
			if player.sprite.animation != "climb":
				player.sprite.play("climb")
	else:
		# 没有输入时，轻微向下重力（让玩家保持在梯子上）
		player.velocity.y = min(player.velocity.y + 200 * delta, 50)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name.begins_with("Player"):
		is_player_in_ladder = true
		player = body
		print("Player entered ladder")
		
		# 停止当前水平移动
		if "velocity" in player:
			player.velocity.x = 0
		
		# 可以添加进入梯子的动画效果

func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D and body.name.begins_with("Player"):
		is_player_in_ladder = false
		
		# 退出攀爬状态
		if player and "is_climbing" in player:
			player.is_climbing = false
		
		player = null
		print("Player exited ladder")

func _on_ladder_top_entered() -> void:
	"""玩家到达梯子顶部"""
	print("Player reached ladder top")
	if player:
		# 可以添加从梯子顶部跳下的逻辑
		pass

func _on_ladder_bottom_entered() -> void:
	"""玩家到达梯子底部"""
	print("Player reached ladder bottom")
	if player:
		# 可以添加从梯子底部跳下的逻辑
		pass
