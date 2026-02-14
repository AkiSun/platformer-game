extends CharacterBody2D

# Enemy.gd - 敌人角色脚本

## 状态枚举
enum EnemyState {
	IDLE,
	PATROL,
	CHASE,
	ATTACK,
	HURT,
	DEAD
}

## 移动参数
@export var speed: float = 100.0
@export var chase_speed: float = 150.0

## 生命值
@export var max_health: float = 50.0
var current_health: float = max_health

## 状态
var current_state: EnemyState = EnemyState.IDLE
var facing_right: bool = true
var is_invincible: bool = false
var player: Node2D = null

## 巡逻参数
@export var patrol_distance: float = 200.0
var start_position: Vector2
var patrol_target: Vector2
var patrol_direction: float = 1.0

## 追击参数
@export var chase_range: float = 300.0  # 追击范围
@export var attack_range: float = 30.0  # 攻击范围
var is_chasing: bool = false

## 节点引用
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar
@onready var sight_area: Area2D = $SightArea
@onready var raycast_left: RayCast2D = $RayCastLeft
@onready var raycast_right: RayCast2D = $RayCastRight

func _ready() -> void:
	start_position = global_position
	patrol_target = start_position + Vector2(patrol_distance, 0)
	_change_state(EnemyState.PATROL)
	
	# 尝试获取玩家引用
	_get_player_reference()
	
	# 更新血条
	_update_health_bar()

func _get_player_reference() -> void:
	# 从父节点查找玩家
	var main = get_tree().get_first_node_in_group("main")
	if main:
		var player_container = main.find_child("PlayerContainer", true, false)
		if player_container:
			var players = player_container.get_children()
			if players.size() > 0:
				player = players[0]
	
	# 也尝试通过名称查找
	if not player:
		player = get_tree().get_first_node_in_group("player")

func _physics_process(delta: float) -> void:
	# 保持玩家引用
	if not player:
		_get_player_reference()
	
	match current_state:
		EnemyState.PATROL:
			_patrol(delta)
			_check_for_player()
		EnemyState.CHASE:
			_chase(delta)
		EnemyState.ATTACK:
			_attack(delta)
		EnemyState.HURT:
			_hurt(delta)
		EnemyState.DEAD:
			pass
	
	move_and_slide()
	_update_facing()
	_update_animation()

func _change_state(new_state: EnemyState) -> void:
	if current_state == new_state:
		return
	
	current_state = new_state
	print("Enemy state: ", EnemyState.keys()[new_state])

func _patrol(delta: float) -> void:
	# 简单的左右巡逻
	var move_dir := patrol_direction
	
	# 检测边界转向
	if raycast_left and raycast_left.is_colliding():
		patrol_direction = 1.0
	elif raycast_right and raycast_right.is_colliding():
		patrol_direction = -1.0
	
	# 到达巡逻点后折返
	var dist_to_start := global_position.distance_to(start_position)
	var dist_to_target := global_position.distance_to(patrol_target)
	
	if dist_to_start > patrol_distance:
		patrol_direction = -1.0
	elif dist_to_target < 10:
		patrol_direction = 1.0
	
	velocity.x = move_dir * speed

func _check_for_player() -> void:
	if not player:
		return
	
	var dist_to_player := global_position.distance_to(player.global_position)
	
	if dist_to_player <= chase_range:
		is_chasing = true
		_change_state(EnemyState.CHASE)

func _chase(delta: float) -> void:
	if not player:
		_change_state(EnemyState.PATROL)
		return
	
	var direction := (player.global_position - global_position).normalized()
	velocity.x = direction.x * chase_speed
	
	# 检查是否在攻击范围内
	var dist_to_player := global_position.distance_to(player.global_position)
	if dist_to_player <= attack_range:
		_change_state(EnemyState.ATTACK)
	# 超出追击范围则返回巡逻
	elif dist_to_player > chase_range * 1.5:
		is_chasing = false
		_change_state(EnemyState.PATROL)

func _attack(delta: float) -> void:
	velocity.x = 0
	
	# 攻击逻辑
	if player and "take_damage" in player:
		player.take_damage(10)
	
	# 短暂攻击后继续追击
	await get_tree().create_timer(0.5).timeout
	if current_state == EnemyState.ATTACK:
		_change_state(EnemyState.CHASE)

func _hurt(delta: float) -> void:
	velocity.x = 0

func _update_facing() -> void:
	if velocity.x > 0:
		facing_right = true
	elif velocity.x < 0:
		facing_right = false
	
	if sprite:
		sprite.flip_h = not facing_right

func _update_animation() -> void:
	if not sprite:
		return
	
	var anim_name := "idle"
	
	match current_state:
		EnemyState.PATROL:
			if abs(velocity.x) > 0:
				anim_name = "walk"
		EnemyState.CHASE:
			anim_name = "run"
		EnemyState.ATTACK:
			anim_name = "attack"
		EnemyState.HURT:
			anim_name = "hurt"
		EnemyState.DEAD:
			anim_name = "dead"
	
	# 尝试播放动画，如果不存在则跳过
	if sprite.frames and sprite.frames.has_animation(anim_name):
		if sprite.animation != anim_name:
			sprite.play(anim_name)
	else:
		# 没有动画时设置颜色表示状态
		match current_state:
			EnemyState.HURT:
				sprite.modulate = Color(1, 0.3, 0.3)
			EnemyState.DEAD:
				sprite.modulate = Color(0.5, 0.5, 0.5)
			_:
				sprite.modulate = Color.WHITE

func take_damage(amount: float) -> void:
	if is_invincible:
		return
	
	current_health -= amount
	_change_state(EnemyState.HURT)
	is_invincible = true
	
	_update_health_bar()
	
	# 受伤硬直
	await get_tree().create_timer(0.2).timeout
	is_invincible = false
	
	if current_health <= 0:
		die()
	elif is_chasing:
		_change_state(EnemyState.CHASE)
	else:
		_change_state(EnemyState.PATROL)

func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health

func die() -> void:
	_change_state(EnemyState.DEAD)
	print("Enemy defeated!")
	
	# 通知敌人生成器
	get_tree().call_group("enemy_manager", "on_enemy_defeated", global_position)
	
	queue_free()
