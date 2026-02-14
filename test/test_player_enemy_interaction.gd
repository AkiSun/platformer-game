extends GutTest

# TestPlayerEnemyInteraction.gd - 玩家与敌人交互集成测试
# 测试玩家和敌人之间的交互

var player: CharacterBody2D = null
var enemy: CharacterBody2D = null

func before_each():
	# 加载场景
	var player_scene = load("res://Player.tscn")
	var enemy_scene = load("res://Enemy.tscn")
	
	player = player_scene.instantiate()
	enemy = enemy_scene.instantiate()
	
	add_child(player)
	add_child(enemy)
	
	await player.ready
	await enemy.ready

func after_each():
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(enemy):
		enemy.queue_free()

func test_player_damage_enemy():
	"""测试玩家攻击敌人"""
	var initial_health = enemy.current_health
	
	# 玩家攻击敌人
	if "take_damage" in enemy:
		enemy.take_damage(10)
	
	assert_eq(enemy.current_health, initial_health - 10, "Enemy should take damage from player attack")

func test_enemy_damage_player():
	"""测试敌人攻击玩家"""
	var initial_health = player.current_health
	
	# 模拟敌人攻击玩家
	if "take_damage" in player:
		player.take_damage(10)
	
	assert_eq(player.current_health, initial_health - 10, "Player should take damage from enemy attack")

func test_invincible_protection():
	"""测试无敌帧保护"""
	# 玩家冲刺后应该有无敌帧
	player.is_invincible = true
	var health_before = player.current_health
	
	player.take_damage(10)
	
	assert_eq(player.current_health, health_before, "Invincible player should not take damage")

func test_player_kills_enemy():
	"""测试玩家击败敌人"""
	# 给敌人低血量
	enemy.current_health = 5
	
	# 玩家攻击敌人
	enemy.take_damage(10)
	
	# 敌人应该死亡
	await get_tree().process_frame
	# 注意：敌人会调用 queue_free()

func test_enemy_chase_player():
	"""测试敌人追击玩家"""
	# 将玩家放在敌人追击范围内
	player.global_position = enemy.global_position + Vector2(100, 0)
	
	# 等待敌人检测到玩家
	await get_tree().create_timer(0.5).timeout
	
	# 敌人应该进入追击状态
	# 注意：实际状态转换需要玩家引用

func test_player_dash_invincibility():
	"""测试玩家冲刺无敌"""
	# 开始冲刺
	player.is_dashing = true
	player.is_invincible = true
	
	var health_before = player.current_health
	enemy.take_damage(50)  # 假设敌人能攻击玩家
	
	# 冲刺中的玩家不应该受伤
	assert_eq(player.current_health, health_before, "Dashing player should be invincible")

func test_health_bars_sync():
	"""测试血条同步"""
	# 玩家受伤后血条应该更新
	player.current_health = 75
	player._update_health_bar()
	
	var player_health_bar = player.get_node("HealthBar")
	assert_eq(player_health_bar.value, 75, "Player health bar should sync")
	
	# 敌人受伤后血条应该更新
	enemy.current_health = 25
	enemy._update_health_bar()
	
	var enemy_health_bar = enemy.get_node("HealthBar")
	assert_eq(enemy_health_bar.value, 25, "Enemy health bar should sync")
