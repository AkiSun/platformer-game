extends GutTest

# TestEnemy.gd - 敌人角色单元测试
# 测试 Enemy.gd 的核心功能

var enemy: CharacterBody2D = null
var enemy_script: Script = null

func before_each():
	# 加载敌人场景
	var enemy_scene = load("res://Enemy.tscn")
	enemy = enemy_scene.instantiate()
	add_child(enemy)
	
	# 等待ready
	await enemy.ready
	
	enemy_script = enemy.get_script()

func after_each():
	if is_instance_valid(enemy):
		enemy.queue_free()

func test_enemy_initialization():
	"""测试敌人初始化"""
	assert_not_null(enemy, "Enemy should be instantiated")
	assert_eq(enemy.name, "Enemy", "Enemy node should be named 'Enemy'")
	
	# 检查必需节点
	assert_not_null(enemy.get_node_or_null("AnimatedSprite2D"), "Enemy should have AnimatedSprite2D")
	assert_not_null(enemy.get_node_or_null("CollisionShape2D"), "Enemy should have CollisionShape2D")
	assert_not_null(enemy.get_node_or_null("HealthBar"), "Enemy should have HealthBar")
	assert_not_null(enemy.get_node_or_null("SightArea"), "Enemy should have SightArea")

func test_enemy_default_values():
	"""测试敌人默认值"""
	assert_eq(enemy.speed, 100.0, "Default speed should be 100.0")
	assert_eq(enemy.chase_speed, 150.0, "Default chase_speed should be 150.0")
	assert_eq(enemy.max_health, 50.0, "Default max_health should be 50.0")
	assert_eq(enemy.current_health, enemy.max_health, "Current health should equal max health")
	assert_eq(enemy.chase_range, 300.0, "Default chase_range should be 300.0")
	assert_eq(enemy.attack_range, 30.0, "Default attack_range should be 30.0")

func test_enemy_states():
	"""测试敌人状态"""
	assert_true(has_enum_value(enemy.EnemyState, "IDLE"), "EnemyState should have IDLE")
	assert_true(has_enum_value(enemy.EnemyState, "PATROL"), "EnemyState should have PATROL")
	assert_true(has_enum_value(enemy.EnemyState, "CHASE"), "EnemyState should have CHASE")
	assert_true(has_enum_value(enemy.EnemyState, "ATTACK"), "EnemyState should have ATTACK")
	assert_true(has_enum_value(enemy.EnemyState, "HURT"), "EnemyState should have HURT")
	assert_true(has_enum_value(enemy.EnemyState, "DEAD"), "EnemyState should have DEAD")

func has_enum_value(enum_val, enum_name: String) -> bool:
	for key in enemy.EnemyState.keys():
		if key == enum_name:
			return true
	return false

func test_enemy_initial_state():
	"""测试敌人初始状态"""
	assert_eq(enemy.current_state, enemy.EnemyState.IDLE, "Enemy should start in IDLE state")
	assert_true(enemy.facing_right, "Enemy should face right initially")
	assert_false(enemy.is_invincible, "Enemy should not be invincible initially")

func test_enemy_patrol_setup():
	"""测试敌人巡逻设置"""
	var start_pos = enemy.start_position
	assert_eq(start_pos, enemy.global_position, "Start position should be initial position")
	assert_true(enemy.patrol_distance > 0, "Patrol distance should be positive")

func test_enemy_take_damage():
	"""测试敌人受伤"""
	var initial_health = enemy.current_health
	
	# 正常受伤
	enemy.take_damage(10)
	assert_eq(enemy.current_health, initial_health - 10, "Health should decrease by damage amount")
	
	# 无敌时不受伤害
	enemy.is_invincible = true
	var health_before_invincible = enemy.current_health
	enemy.take_damage(10)
	assert_eq(enemy.current_health, health_before_invincible, "Invincible enemy should not take damage")

func test_enemy_health_bar():
	"""测试敌人血条更新"""
	var health_bar = enemy.get_node("HealthBar")
	assert_not_null(health_bar, "HealthBar should exist")
	
	enemy.current_health = 25
	enemy._update_health_bar()
	assert_eq(health_bar.value, 25, "Health bar should update to current health")

func test_enemy_facing_direction():
	"""测试敌人朝向"""
	enemy.velocity.x = -50
	enemy._update_facing()
	assert_false(enemy.facing_right, "Enemy should face left when moving left")
	
	enemy.velocity.x = 50
	enemy._update_facing()
	assert_true(enemy.facing_right, "Enemy should face right when moving right")

func test_enemy_state_transitions():
	"""测试敌人状态转换"""
	# 从 PATROL 转换到 CHASE
	enemy._change_state(enemy.EnemyState.PATROL)
	assert_eq(enemy.current_state, enemy.EnemyState.PATROL, "Should be in PATROL state")
	
	enemy._change_state(enemy.EnemyState.CHASE)
	assert_eq(enemy.current_state, enemy.EnemyState.CHASE, "Should transition to CHASE state")

func test_enemy_sprite_flip():
	"""测试敌人精灵翻转"""
	var sprite = enemy.get_node("AnimatedSprite2D")
	assert_not_null(sprite, "Sprite should exist")
	
	enemy.facing_right = true
	enemy._update_facing()
	assert_false(sprite.flip_h, "Sprite should not be flipped when facing right")
	
	enemy.facing_right = false
	enemy._update_facing()
	assert_true(sprite.flip_h, "Sprite should be flipped when facing left")
