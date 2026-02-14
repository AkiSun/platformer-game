extends Node

# EnemyManager.gd - 敌人生成管理器
# 处理敌人波次、生成和击败追踪

## 敌人预制体
@export var enemy_scene: PackedScene

## 波次配置
@export var enemies_per_wave: int = 5
@export var spawn_delay: float = 5.0  # 初始生成延迟
@export var respawn_delay: float = 2.0  # 击败后重生延迟

## 状态
var current_wave: int = 1
var enemies_remaining: int = 0
var enemies_active: int = 0
var is_spawning: bool = false
var spawn_points: Array[Vector2] = []

## 节点引用
var enemy_container: Node2D = null
var player: Node2D = null

func _ready() -> void:
	add_to_group("enemy_manager")
	_setup_references()
	
	# 设置初始生成延迟
	await get_tree().create_timer(spawn_delay).timeout
	_spawn_wave()

func _setup_references() -> void:
	# 获取敌人生成容器
	var main = get_tree().get_first_node_in_group("main")
	if main:
		enemy_container = main.find_child("EnemyContainer", true, false)
	
	# 获取玩家
	player = get_tree().get_first_node_in_group("player")
	if not player:
		# 尝试从 Main 场景获取
		if main:
			var player_container = main.find_child("PlayerContainer", true, false)
			if player_container:
				var players = player_container.get_children()
				if players.size() > 0:
					player = players[0]
	
	# 设置生成点
	_setup_spawn_points()

func _setup_spawn_points() -> void:
	# 在场景中定义几个生成点
	spawn_points = [
		Vector2(400, 500),
		Vector2(600, 500),
		Vector2(800, 500),
		Vector2(1000, 500),
		Vector2(1200, 500)
	]

func _spawn_wave() -> void:
	if not enemy_scene:
		printerr("EnemyManager: enemy_scene not set!")
		return
	
	print("Spawning wave ", current_wave)
	
	enemies_remaining = enemies_per_wave
	enemies_active = 0
	
	for i in range(enemies_per_wave):
		if i < spawn_points.size():
			_spawn_enemy(spawn_points[i])
			# 每个敌人之间稍微间隔一下
			await get_tree().create_timer(0.3).timeout

func _spawn_enemy(position: Vector2) -> void:
	if not enemy_container:
		return
	
	var enemy = enemy_scene.instantiate()
	enemy.global_position = position
	enemy_container.add_child(enemy)
	
	enemies_active += 1
	print("Enemy spawned at ", position)

func on_enemy_defeated(position: Vector2) -> void:
	enemies_remaining -= 1
	enemies_active -= 1
	
	print("Enemy defeated! Remaining: ", enemies_remaining)
	
	# 检查是否波次完成
	if enemies_remaining <= 0:
		_on_wave_complete()

func _on_wave_complete() -> void:
	current_wave += 1
	print("Wave ", current_wave - 1, " complete!")
	
	# 通知游戏胜利（当前只做简单实现）
	var main = get_tree().get_first_node_in_group("main")
	if main and "change_state" in main:
		main.change_state(main.GameState.VICTORY)

# 公开接口
func get_enemies_remaining() -> int:
	return enemies_remaining

func get_current_wave() -> int:
	return current_wave

func force_spawn_wave() -> void:
	_spawn_wave()
