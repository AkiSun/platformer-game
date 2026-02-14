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

## 巡逻参数
@export var patrol_distance: float = 200.0
var start_position: Vector2
var patrol_target: Vector2

## 节点引用
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	start_position = global_position
	patrol_target = start_position + Vector2(patrol_distance, 0)
	_change_state(EnemyState.PATROL)

func _physics_process(delta: float) -> void:
	match current_state:
		EnemyState.PATROL:
			_patrol(delta)
		EnemyState.CHASE:
			_chase(delta)
		EnemyState.HURT:
			_hurt(delta)
		EnemyState.DEAD:
			pass
	
	move_and_slide()
	_update_facing()
	_update_animation()

func _change_state(new_state: EnemyState) -> void:
	current_state = new_state

func _patrol(delta: float) -> void:
	var direction := (patrol_target - global_position).normalized()
	velocity.x = direction.x * speed
	
	# 到达目标点后切换方向
	if global_position.distance_to(patrol_target) < 10:
		patrol_target = start_position + (patrol_target - start_position) * -1

func _chase(delta: float) -> void:
	# 追逐玩家逻辑会在添加玩家引用后实现
	pass

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
			if velocity.x != 0:
				anim_name = "walk"
		EnemyState.CHASE:
			anim_name = "run"
		EnemyState.HURT:
			anim_name = "hurt"
		EnemyState.DEAD:
			anim_name = "dead"
	
	if sprite.animation != anim_name:
		sprite.play(anim_name)

func take_damage(amount: float) -> void:
	if is_invincible:
		return
	
	current_health -= amount
	_change_state(EnemyState.HURT)
	is_invincible = true
	
	await get_tree().create_timer(0.2).timeout
	is_invincible = false
	
	if current_health <= 0:
		die()
	else:
		_change_state(EnemyState.PATROL)

func die() -> void:
	_change_state(EnemyState.DEAD)
	print("Enemy defeated!")
	queue_free()
