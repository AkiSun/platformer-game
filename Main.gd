extends Node2D

# Main.gd - 主场景脚本
# 游戏入口场景，管理游戏状态和主要节点

# 游戏状态枚举
enum GameState {
	PLAYING,
	PAUSED,
	VICTORY,
	DEFEAT
}

var current_state: GameState = GameState.PLAYING

# 游戏参数
var total_waves: int = 5
var enemies_per_wave: int = 5

# 节点引用
@onready var player_container: Node = $PlayerContainer
@onready var enemy_container: Node = $EnemyContainer
@onready var platforms_container: Node = $PlatformsContainer
@onready var enemy_manager: Node = $EnemyManager
@onready var game_ui: CanvasLayer = $GameUI

var player: Node2D = null

func _ready() -> void:
	print("Platformer Game initialized!")
	_setup_game()
	_setup_player_group()
	_connect_ui_signals()

func _setup_game() -> void:
	# 初始化游戏容器
	if not player_container:
		push_warning("PlayerContainer not found")
	if not enemy_container:
		push_warning("EnemyContainer not found")
	if not platforms_container:
		push_warning("PlatformsContainer not found")
	if not game_ui:
		push_warning("GameUI not found")

func _setup_player_group() -> void:
	# 将玩家添加到 "player" group
	if player_container:
		var players = player_container.get_children()
		for p in players:
			p.add_to_group("player")
			player = p
			print("Player added to group: ", p.name)
			# 连接玩家信号
			if "health_depleted" in p:
				p.health_depleted.connect(_on_player_died)

func _connect_ui_signals() -> void:
	# 连接 GameUI 信号
	if game_ui and game_ui.has_signal("restart_requested"):
		game_ui.restart_requested.connect(restart_game)

func _process(delta: float) -> void:
	match current_state:
		GameState.PLAYING:
			_update_game(delta)
		GameState.PAUSED:
			pass
		GameState.VICTORY:
			pass
		GameState.DEFEAT:
			pass

func _update_game(delta: float) -> void:
	# 检查玩家是否还活着
	if player and not is_instance_valid(player):
		_on_player_died()
	
	# 检查是否胜利（所有波次完成且没有敌人）
	if enemy_manager:
		var wave = enemy_manager.get("current_wave", 1)
		var enemies_remaining = enemy_manager.get("enemies", []).size()
		if wave >= total_waves and enemies_remaining == 0:
			_on_victory()

func change_state(new_state: GameState) -> void:
	current_state = new_state
	match new_state:
		GameState.PAUSED:
			get_tree().paused = true
		GameState.VICTORY:
			_on_victory()
		GameState.DEFEAT:
			_on_defeat()
		_:
			get_tree().paused = false

func _on_victory() -> void:
	if current_state == GameState.VICTORY:
		return
	
	current_state = GameState.VICTORY
	print("Victory!")
	
	if game_ui:
		game_ui.show_victory()
	
	get_tree().paused = true

func _on_defeat() -> void:
	if current_state == GameState.DEFEAT:
		return
	
	current_state = GameState.DEFEAT
	print("Defeat!")
	
	if game_ui:
		game_ui.show_defeat()
	
	get_tree().paused = true

func _on_player_died() -> void:
	print("Player died!")
	change_state(GameState.DEFEAT)

func restart_game() -> void:
	get_tree().paused = false
	current_state = GameState.PLAYING
	
	# 重置 UI
	if game_ui:
		game_ui.hide_game_over_screens()
		game_ui.update_health(100.0)
		game_ui.update_score(0)
		game_ui.update_wave(1)
	
	# 重新加载场景
	get_tree().reload_current_scene()

# 供外部调用的方法
func add_score(points: int) -> void:
	if game_ui:
		var current = 0
		if game_ui.has_method("update_score"):
			# 获取当前分数
			current = game_ui.current_score
			game_ui.update_score(current + points)

func update_wave(wave_num: int) -> void:
	if game_ui:
		game_ui.update_wave(wave_num)
