extends CharacterBody2D

# Player.gd - 玩家角色脚本
# 平台跳跃游戏的主角

## 移动参数
@export var speed: float = 300.0
@export var jump_force: float = -450.0
@export var gravity: float = 980.0

## 冲刺参数
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0

## 生命值
@export var max_health: float = 100.0
var current_health: float = max_health

## 状态
var is_on_ground: bool = false
var is_dashing: bool = false
var can_dash: bool = true
var is_invincible: bool = false
var facing_right: bool = true

## 冲刺计时器
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var invincible_timer: float = 0.0

## 攻击参数
var is_attacking: bool = false
var attack_cooldown: float = 0.0

## 节点引用
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collider: CollisionShape2D = $CollisionShape2D
@onready var health_bar: ProgressBar = $HealthBar

func _ready() -> void:
	print("Player initialized")
	_update_health_bar()

func _physics_process(delta: float) -> void:
	# 应用重力
	if not is_on_ground:
		velocity.y += gravity * delta
	
	# 处理移动
	_handle_movement()
	
	# 处理跳跃
	_handle_jump()
	
	# 处理冲刺
	_handle_dash(delta)
	
	# 处理攻击
	_handle_attack(delta)
	
	# 处理无敌帧
	_handle_invincibility(delta)
	
	# 更新地面状态
	is_on_ground = is_on_floor()
	
	# 应用移动
	move_and_slide()
	
	# 更新朝向
	_update_facing()
	
	# 更新动画
	_update_animation()

func _handle_movement() -> void:
	var direction := 0.0
	
	if Input.is_action_pressed("move_left"):
		direction = -1.0
	elif Input.is_action_pressed("move_right"):
		direction = 1.0
	
	if is_dashing:
		# 冲刺时保持方向
		velocity.x = dash_speed * (1 if facing_right else -1)
	else:
		velocity.x = direction * speed

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_ground:
		velocity.y = jump_force
		is_on_ground = false

func _handle_dash(delta: float) -> void:
	# 冲刺冷却
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			can_dash = true
	
	# 冲刺中
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			is_dashing = false
			velocity.x = 0
	
	# 开始冲刺
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		is_dashing = true
		can_dash = false
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		is_invincible = true
		invincible_timer = 0.3  # 冲刺时有短暂无敌

func _handle_attack(delta: float) -> void:
	if attack_cooldown > 0:
		attack_cooldown -= delta
	
	if Input.is_action_just_pressed("attack") and attack_cooldown <= 0:
		perform_attack()

func _handle_invincibility(delta: float) -> void:
	if invincible_timer > 0:
		invincible_timer -= delta
		if invincible_timer <= 0:
			is_invincible = false

func perform_attack() -> void:
	is_attacking = true
	attack_cooldown = 0.5
	print("Player attacks!")
	# 攻击逻辑会在添加攻击区域后实现
	await get_tree().create_timer(0.2).timeout
	is_attacking = false

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
	
	if is_dashing:
		anim_name = "dash"
	elif velocity.x != 0 and is_on_ground:
		anim_name = "run"
	elif velocity.y < 0:
		anim_name = "jump"
	elif velocity.y > 0 and not is_on_ground:
		anim_name = "fall"
	elif is_attacking:
		anim_name = "attack"
	
	if sprite.animation != anim_name:
		sprite.play(anim_name)

func take_damage(amount: float) -> void:
	if is_invincible:
		return
	
	current_health -= amount
	_update_health_bar()
	
	if current_health <= 0:
		die()

func _update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_health

func die() -> void:
	print("Player died!")
	queue_free()
