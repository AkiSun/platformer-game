#ifndef TILEMAP_GD
#define TILEMAP_GD

extends TileMap

# TileMap.gd - 瓦片地图管理
# 处理地形碰撞和特殊瓦片

## 瓦片数据
enum TileType {
	AIR = -1,
	GROUND = 0,
	PLATFORM = 1,
	LADDER = 2,
	HAZARD = 3,
	COIN = 4
}

## 碰撞层
enum CollisionLayer {
	DEFAULT = 1,
	PLATFORM = 2,
	LADDER = 4,
	HAZARD = 8,
	COIN = 16
}

func _ready() -> void:
	print("TileMap initialized")

# 获取指定位置的瓦片类型
func get_tile_type_at(pos: Vector2) -> TileType:
	var tile_pos := local_to_map(pos)
	var tile_id := get_cell_tile_data(0, tile_pos)
	if tile_id:
		return tile_id.get_custom_data("tile_type")
	return TileType.AIR

# 检查是否是地面
func is_ground_at(pos: Vector2) -> bool:
	return get_tile_type_at(pos) == TileType.GROUND

# 检查是否是平台（可穿透）
func is_platform_at(pos: Vector2) -> bool:
	return get_tile_type_at(pos) == TileType.PLATFORM

# 检查是否是梯子
func is_ladder_at(pos: Vector2) -> bool:
	return get_tile_type_at(pos) == TileType.LADDER

# 检查是否是危险区域
func is_hazard_at(pos: Vector2) -> bool:
	return get_tile_type_at(pos) == TileType.HAZARD

#endif
