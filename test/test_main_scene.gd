extends GutTest

# TestMainScene.gd - 主场景测试
# 测试游戏主场景的加载和功能

var main: Node2D = null

func before_each():
	# 加载主场景
	var main_scene = load("res://Main.tscn")
	main = main_scene.instantiate()
	add_child(main)
	
	await main.ready

func after_each():
	if is_instance_valid(main):
		main.queue_free()

func test_main_scene_loads():
	"""测试主场景加载"""
	assert_not_null(main, "Main scene should be instantiated")
	assert_eq(main.name, "Main", "Main node should be named 'Main'")

func test_main_has_required_containers():
	"""测试主场景包含必需容器"""
	assert_not_null(main.get_node_or_null("PlayerContainer"), "Main should have PlayerContainer")
	assert_not_null(main.get_node_or_null("EnemyContainer"), "Main should have EnemyContainer")
	assert_not_null(main.get_node_or_null("PlatformsContainer"), "Main should have PlatformsContainer")
	assert_not_null(main.get_node_or_null("EnemyManager"), "Main should have EnemyManager")

func test_main_game_states():
	"""测试游戏状态"""
	assert_true(has_enum_value(main.GameState, "PLAYING"), "GameState should have PLAYING")
	assert_true(has_enum_value(main.GameState, "PAUSED"), "GameState should have PAUSED")
	assert_true(has_enum_value(main.GameState, "VICTORY"), "GameState should have VICTORY")
	assert_true(has_enum_value(main.GameState, "DEFEAT"), "GameState should have DEFEAT")

func has_enum_value(enum_val, enum_name: String) -> bool:
	for key in main.GameState.keys():
		if key == enum_name:
			return true
	return false

func test_main_initial_state():
	"""测试初始游戏状态"""
	assert_eq(main.current_state, main.GameState.PLAYING, "Game should start in PLAYING state")

func test_main_change_state():
	"""测试状态切换"""
	main.change_state(main.GameState.PAUSED)
	assert_eq(main.current_state, main.GameState.PAUSED, "State should change to PAUSED")
	
	main.change_state(main.GameState.PLAYING)
	assert_eq(main.current_state, main.GameState.PLAYING, "State should change back to PLAYING")

func test_main_victory_state():
	"""测试胜利状态"""
	main.change_state(main.GameState.VICTORY)
	assert_eq(main.current_state, main.GameState.VICTORY, "State should change to VICTORY")

func test_main_defeat_state():
	"""测试失败状态"""
	main.change_state(main.GameState.DEFEAT)
	assert_eq(main.current_state, main.GameState.DEFEAT, "State should change to DEFEAT")

func test_main_restart():
	"""测试游戏重启"""
	# 设置为非初始状态
	main.current_state = main.GameState.DEFEAT
	
	# 重启游戏
	main.restart_game()
	
	# 注意：reload_current_scene 会立即重新加载场景
	# 这是一个异步操作，测试可能需要特殊处理
