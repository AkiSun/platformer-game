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

# 节点引用
@onready var player_container: Node = $PlayerContainer
@onready var enemy_container: Node = $EnemyContainer
@onready var platforms_container: Node = $PlatformsContainer
@onready var enemy_manager: Node = $EnemyManager

var player: Node2D = null

func _ready() -> void:
	print("Platformer Game initialized!")
	_setup_game()
	_setup_player_group()

func _setup_game() -> void:
	# 初始化游戏容器
	if not player_container:
		push_warning("PlayerContainer not found")
	if not enemy_container:
		push_warning("EnemyContainer not found")
	if not platforms_container:
		push_warning("PlatformsContainer not found")

func _setup_player_group() -> void:
	# 将玩家添加到 "player" group
	if player_container:
		var players = player_container.get_children()
		for p in players:
			p.add_to_group("player")
			player = p
			print("Player added to group: ", p.name)

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
	print("Victory!")
	# 可以在这里显示胜利 UI

func _on_defeat() -> void:
	print("Defeat!")
	# 可以在这里显示失败 UI

func _on_player_died() -> void:
	print("Player died!")
	change_state(GameState.DEFEAT)

func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
