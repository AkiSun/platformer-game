extends ParallaxBackground

# ParallaxBackground.gd - 视差背景脚本
# 多层视差滚动背景系统

## 视差层速度
@export var sky_speed: float = 0.1
@export var far_mountain_speed: float = 0.2
@export var mid_mountain_speed: float = 0.4
@export var near_mountain_speed: float = 0.6
@export var foreground_speed: float = 0.8

## 颜色配置
@export var sky_color_top: Color = Color(0.4, 0.6, 0.9)      # 天空顶部
@export var sky_color_bottom: Color = Color(0.8, 0.9, 1.0)   # 天空底部
@export var far_mountain_color: Color = Color(0.5, 0.5, 0.6) # 远山
@export var mid_mountain_color: Color = Color(0.4, 0.5, 0.4) # 中景山
@export var near_mountain_color: Color = Color(0.3, 0.4, 0.3) # 近景山
@export var ground_color: Color = Color(0.2, 0.3, 0.2)       # 地面

## 节点引用
@onready var sky_layer: ParallaxLayer = $SkyLayer
@onready var far_mountain_layer: ParallaxLayer = $FarMountainLayer
@onready var mid_mountain_layer: ParallaxLayer = $MidMountainLayer
@onready var near_mountain_layer: ParallaxLayer = $NearMountainLayer

## 屏幕尺寸
var screen_size: Vector2

func _ready() -> void:
	screen_size = get_viewport_rect().size
	_setup_layers()
	print("ParallaxBackground initialized")

func _setup_layers() -> void:
	# 天空层（渐变）
	_setup_sky_layer()
	
	# 远景山脉
	_setup_mountain_layer(far_mountain_layer, far_mountain_speed, 0.3)
	
	# 中景山脉
	_setup_mountain_layer(mid_mountain_layer, mid_mountain_speed, 0.5)
	
	# 近景山脉
	_setup_mountain_layer(near_mountain_layer, near_mountain_speed, 0.7)
	
	# 地面层（最快）
	_setup_ground_layer()

func _setup_sky_layer() -> void:
	if sky_layer:
		sky_layer.motion_scale = Vector2(sky_speed, sky_speed)
		# 创建渐变天空
		var sky_texture = _create_gradient_texture()
		var sky_sprite = Sprite2D.new()
		sky_sprite.texture = sky_texture
		sky_sprite.scale = Vector2(2, 1)  # 覆盖更宽的区域
		sky_layer.add_child(sky_sprite)

func _setup_mountain_layer(layer: ParallaxLayer, speed: float, height_ratio: float) -> void:
	if layer:
		layer.motion_scale = Vector2(speed, 0)  # 只水平滚动
		
		# 创建山脉纹理
		var mountain_texture = _create_mountain_texture(height_ratio)
		var mountain_sprite = Sprite2D.new()
		mountain_sprite.texture = mountain_texture
		mountain_sprite.position.y = screen_size.y * 0.6
		mountain_sprite.scale = Vector2(2, 1.5)
		layer.add_child(mountain_sprite)

func _setup_ground_layer() -> void:
	# 地面已经在 TileMap 中实现，这里可以添加装饰层
	pass

# 创建渐变纹理
func _create_gradient_texture() -> GradientTexture2D:
	var gradient = Gradient.new()
	gradient.set_color(0, sky_color_top)
	gradient.set_color(1, sky_color_bottom)
	
	var texture = GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = FillMode.FILL_VERTICAL
	texture.fill_from = Vector2(0, 0)
	texture.fill_to = Vector2(0, 1)
	texture.width = 512
	texture.height = 256
	
	return texture

# 创建山脉纹理
func _create_mountain_texture(height_ratio: float) -> ImageTexture:
	var width = 1024
	var height = 256
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	# 山脉颜色
	var mountain_color = far_mountain_color
	if height_ratio > 0.4:
		mountain_color = mid_mountain_color
	if height_ratio > 0.6:
		mountain_color = near_mountain_color
	
	# 绘制三角形山峰
	for x in range(width):
		# 生成随机但平滑的高度变化
		var base_height = height * 0.3
		var noise = sin(x * 0.02) * 30 + sin(x * 0.05) * 15
		var mountain_height = base_height + noise
		
		for y in range(height):
			var pixel_color = Color(0, 0, 0, 0)  # 透明
			
			# 山脉区域
			if y > height - mountain_height:
				# 渐变色调
				var t = float(y - (height - mountain_height)) / mountain_height
				pixel_color = mountain_color.lerp(mountain_color.lightened(0.3), t)
			
			image.set_pixel(x, y, pixel_color)
	
	return ImageTexture.create_from_image(image)

# 可选：添加云朵
func _create_cloud_texture() -> ImageTexture:
	var width = 256
	var height = 128
	var image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	var cloud_color = Color(1, 1, 1, 0.8)
	
	# 简单的椭圆云朵
	for x in range(width):
		for y in range(height):
			var center = Vector2(width / 2, height / 2)
			var dist = Vector2(x, y).distance_to(center)
			var alpha = clamp(1.0 - dist / (width * 0.4), 0, 1)
			
			if alpha > 0:
				var pixel = cloud_color
				pixel.a = alpha
				image.set_pixel(x, y, pixel)
	
	return ImageTexture.create_from_image(image)
