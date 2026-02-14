extends CanvasLayer
class_name GameUI

# GameUI.gd - 游戏界面管理
# 管理所有游戏界面（血条、分数、胜负界面等）

## 信号
signal restart_requested

## 节点引用
@onready var health_container: HBoxContainer = $HealthContainer
@onready var health_bar: ProgressBar = $HealthContainer/HealthBar
@onready var score_label: Label = $ScoreContainer/ScoreLabel
@onready var wave_label: Label = $WaveContainer/WaveLabel
@onready var victory_screen: Control = $VictoryScreen
@onready var defeat_screen: Control = $DefeatScreen

## 游戏状态
var current_health: float = 100.0
var max_health: float = 100.0
var current_score: int = 0
var current_wave: int = 1

func _ready() -> void:
	# 初始隐藏胜负界面
	if victory_screen:
		victory_screen.hide()
	if defeat_screen:
		defeat_screen.hide()
	
	_update_health_bar()
	_update_score_label()
	_update_wave_label()
	print("GameUI initialized")

## 更新血条
func update_health(health: float, max_health_val: float = 100.0) -> void:
	current_health = health
	max_health = max_health_val
	_update_health_bar()

func _update_health_bar() -> void:
	if health_bar:
		health_bar.max_value = max_health
		health_bar.value = current_health

## 更新分数
func update_score(score: int) -> void:
	current_score = score
	_update_score_label()

func _update_score_label() -> void:
	if score_label:
		score_label.text = "Score: %d" % current_score

## 更新波次
func update_wave(wave: int) -> void:
	current_wave = wave
	_update_wave_label()

func _update_wave_label() -> void:
	if wave_label:
		wave_label.text = "Wave: %d" % current_wave

## 显示胜利界面
func show_victory() -> void:
	if victory_screen:
		victory_screen.show()
	print("Victory!")

## 显示失败界面
func show_defeat() -> void:
	if defeat_screen:
		defeat_screen.show()
	print("Defeat!")

## 隐藏胜负界面
func hide_game_over_screens() -> void:
	if victory_screen:
		victory_screen.hide()
	if defeat_screen:
		defeat_screen.hide()

## 请求重新开始
func request_restart() -> void:
	emit_signal("restart_requested")
