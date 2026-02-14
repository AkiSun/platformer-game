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

func _ready() -> void:
	print("Platformer Game initialized!")
	_setup_game()

func _setup_game() -> void:
	# 初始化游戏容器
	if not player_container:
		print("Warning: PlayerContainer not found")
	if not enemy_container:
		print("Warning: EnemyContainer not found")
	if not platforms_container:
		print("Warning: PlatformsContainer not found")

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
	# 游戏逻辑更新
	pass

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
	get_tree().paused = true

func _on_defeat() -> void:
	print("Defeat!")
	get_tree().paused = true

func restart_game() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
