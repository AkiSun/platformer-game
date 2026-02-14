extends GutTest

# TestPlayer.gd - 玩家角色单元测试
# 测试 Player.gd 的核心功能

var player: CharacterBody2D = null
var player_script: Script = null

func before_each():
	# 加载玩家场景
	var player_scene = load("res://Player.tscn")
	player = player_scene.instantiate()
	add_child(player)
	
	# 等待ready
	await player.ready
	
	player_script = player.get_script()

func after_each():
	if is_instance_valid(player):
		player.queue_free()

func test_player_initialization():
	"""测试玩家初始化"""
	assert_not_null(player, "Player should be instantiated")
	assert_eq(player.name, "Player", "Player node should be named 'Player'")
	
	# 检查必需节点
	assert_not_null(player.get_node_or_null("AnimatedSprite2D"), "Player should have AnimatedSprite2D")
	assert_not_null(player.get_node_or_null("CollisionShape2D"), "Player should have CollisionShape2D")
	assert_not_null(player.get_node_or_null("HealthBar"), "Player should have HealthBar")
	assert_not_null(player.get_node_or_null("Camera2D"), "Player should have Camera2D")

func test_player_default_values():
	"""测试玩家默认值"""
	assert_eq(player.speed, 300.0, "Default speed should be 300.0")
	assert_eq(player.jump_force, -450.0, "Default jump_force should be -450.0")
	assert_eq(player.gravity, 980.0, "Default gravity should be 980.0")
	assert_eq(player.max_health, 100.0, "Default max_health should be 100.0")
	assert_eq(player.current_health, player.max_health, "Current health should equal max health")

func test_player_state_flags():
	"""测试玩家状态标志"""
	assert_false(player.is_on_ground, "Player should not be on ground initially")
	assert_false(player.is_dashing, "Player should not be dashing initially")
	assert_true(player.can_dash, "Player should be able to dash initially")
	assert_false(player.is_invincible, "Player should not be invincible initially")

func test_player_facing_direction():
	"""测试玩家朝向"""
	assert_true(player.facing_right, "Player should face right initially")
	
	# 模拟向左移动
	player.velocity.x = -100
	player._update_facing()
	assert_false(player.facing_right, "Player should face left when moving left")
	
	# 模拟向右移动
	player.velocity.x = 100
	player._update_facing()
	assert_true(player.facing_right, "Player should face right when moving right")

func test_player_sprite_flip():
	"""测试精灵翻转"""
	var sprite = player.get_node("AnimatedSprite2D")
	assert_not_null(sprite, "Sprite should exist")
	
	player.facing_right = true
	player._update_facing()
	assert_false(sprite.flip_h, "Sprite should not be flipped when facing right")
	
	player.facing_right = false
	player._update_facing()
	assert_true(sprite.flip_h, "Sprite should be flipped when facing left")

func test_player_take_damage():
	"""测试玩家受伤"""
	var initial_health = player.current_health
	
	# 正常受伤
	player.take_damage(10)
	assert_eq(player.current_health, initial_health - 10, "Health should decrease by damage amount")
	
	# 无敌时不受伤害
	player.is_invincible = true
	var health_before_invincible = player.current_health
	player.take_damage(10)
	assert_eq(player.current_health, health_before_invincible, "Invincible player should not take damage")

func test_player_health_bar():
	"""测试血条更新"""
	var health_bar = player.get_node("HealthBar")
	assert_not_null(health_bar, "HealthBar should exist")
	
	player.current_health = 50
	player._update_health_bar()
	assert_eq(health_bar.value, 50, "Health bar should update to current health")

func test_player_die():
	"""测试玩家死亡"""
	assert_true(is_instance_valid(player), "Player should be valid before death")
	
	player.current_health = 0
	player.take_damage(1)
	
	# 死亡后应该被释放
	await get_tree().process_frame
	assert_false(is_instance_valid(player), "Player should be freed after death")
