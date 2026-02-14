# 任务拆分：Godot Engine 平台跳跃游戏 Demo

## 状态
- **最后更新**：2026-02-14
- **当前阶段**：P0 - 项目初始化
- **项目仓库**：AkiSun/platformer-game
- **目标分支**：feature/godot-platformer

---

## P0 - 项目初始化
**目标**：创建 Godot 项目，配置基础设置

### 阶段任务

- [x] #1.1 **创建 Godot 项目** - 新建 4.x 项目 - [状态: 已完成]
  - 使用 Godot 4.x 创建新项目
  - 配置项目名称和路径
  - 选择渲染模式（Canvas 兼容性优先）

- [x] #1.2 **配置 project.godot** - 项目基础设置 - [状态: 已完成]
  - 设置窗口大小（1280x720）
  - 配置显示模式（可拉伸、保持比例）
  - 设置重力常数
  - 配置默认图层

- [x] #1.3 **配置 InputMap** - 输入映射 - [状态: 已完成]
  - 创建动作：move_left, move_right, jump, dash, attack, defend
  - 绑定键盘按键（A/D/W/S/Space/J/K）
  - 预留触屏动作

- [x] #1.4 **创建基础场景结构** - Main 场景框架 - [状态: 已完成]
  - 创建 Main.tscn
  - 添加节点层级结构
  - 创建子场景模板

- [x] #1.5 **配置 Web 导出预设** - 导出设置 - [状态: 已完成]
  - 添加 Web 导出模板
  - 配置导出路径
  - 设置 HTML5 选项

---

## P1 - 玩家角色
**目标**：实现完整的玩家角色系统

### 阶段任务

- [x] #2.1 **创建 Player 场景** - 角色基础节点 - [状态: 已完成]
  - CharacterBody2D 根节点
  - CollisionShape2D 碰撞形状
  - AnimatedSprite2D 动画精灵
  - Camera2D 摄像机（跟随）

- [x] #2.2 **Player.gd 脚本** - 移动和跳跃 - [状态: 已完成]
  - _physics_process 实现
  - move_and_slide 使用
  - 速度变量和加速度
  - 跳跃逻辑（地面检测）

- [x] #2.3 **冲刺能力** - 冲刺 + 无敌帧 - [状态: 已完成]
  - 冲刺输入检测
  - 速度突增实现
  - 无敌帧状态管理
  - 冷却时间计时器

- [x] #2.4 **攻击系统** - 攻击判定 - [状态: 已完成]
  - Area2D 攻击范围
  - 攻击动画播放
  - 伤害输出接口
  - 攻击冷却

- [x] #2.5 **血条系统** - 玩家生命值 - [状态: 已完成]
  - ProgressBar 节点添加
  - 生命值属性管理
  - 受伤信号处理
  - 死亡判定

- [x] #2.6 **动画集成** - AnimatedSprite2D - [状态: 已完成]
  - 导入精灵图片（使用 PlaceHolderTexture2D）
  - 配置动画帧 (idle/run/jump/fall/dash/attack)
  - 播放状态切换
  - 方向翻转

- [x] #2.7 **触屏虚拟按钮** - TouchControls 场景 - [状态: 已完成]
  - 创建 TouchButton 场景（TouchButton.tscn + TouchButton.gd）
  - 创建 TouchControls 容器场景
  - 映射到 InputMap 动作

---

## P2 - 平台与环境
**目标**：实现平台、梯子等环境元素

### 阶段任务

- [x] #3.1 **创建 TileMap 瓦片集** - 地形资源 - [状态: 已完成]
  - 导入瓦片图片
  - 创建 TileSet
  - 配置碰撞层
  - 绘制地面、斜坡

- [x] #3.2 **关卡布局设计** - Main 场景编辑 - [状态: 已完成]
  - 绘制地面平台
  - 添加浮空平台
  - 设计斜坡
  - 放置梯子位置

- [x] #3.3 **梯子系统 Ladder.gd** - 上下攀爬 - [状态: 已完成]
  - Area2D 梯子检测
  - 攀爬状态管理
  - 上下移动逻辑
  - 动画状态切换

- [x] #3.4 **平台交互优化** - 特殊动作 - [状态: 已完成]
  - 头部碰撞检测优化
  - 下 + 跳 = 下平台
  - 上 + 跳 = 爬梯
  - 下落穿透平台

- [x] #3.5 **摄像机 Camera2D** - 跟随玩家 - [状态: 已完成]
  - 添加 Camera2D 节点
  - 配置跟随参数
  - 设置视野范围
  - 添加死区（可选）

---

## P3 - 敌人系统
**目标**：实现敌人 AI 和敌人生成

### 阶段任务

- [x] #4.1 **创建 Enemy 场景** - 敌人基础节点 - [状态: 已完成]
  - CharacterBody2D 根节点
  - CollisionShape2D 碰撞形状
  - AnimatedSprite2D 动画精灵
  - ProgressBar 血条

- [x] #4.2 **Enemy.gd 脚本** - 基础 AI - [状态: 已完成]
  - 状态枚举定义
  - 物理运动实现
  - 受伤和死亡处理

- [x] #4.3 **巡逻模式 AI** - 固定路径 - [状态: 已完成]
  - 巡逻点定义
  - 移动逻辑
  - 边界检测（RayCast2D）
  - 转向动画

- [x] #4.4 **追击模式 AI** - 追踪玩家 - [状态: 已完成]
  - 视野检测（Area2D）
  - 追踪算法
  - 切换条件判断
  - 攻击判定

- [x] #4.5 **EnemyManager.gd** - 敌人生成器 - [状态: 已完成]
  - 敌人生成逻辑
  - 延迟生成
  - 击败后立即生成
  - 生成位置管理

- [x] #4.6 **敌人波次逻辑** - 5 个敌人 - [状态: 已完成]
  - 波次计数
  - 胜利条件判断
  - 当前波次显示

- [x] #4.7 **敌人视觉** - 卡通风格 - [状态: 已完成]
  - 精灵图片导入（使用 PlaceHolderTexture2D）
  - 动画配置 (idle/walk/run/attack/hurt/dead)
  - 受伤/死亡效果

---

## P4 - 视差背景
**目标**：实现多层视差滚动背景

### 阶段任务

- [x] #5.1 **背景资源准备** - 图片导入 - [状态: 已完成]
  - 天空层图片（渐变天空、云朵）
  - 远景层图片（山脉）
  - 中景层图片（树木）
  - 近景层图片（草丛）

- [x] #5.2 **创建 ParallaxBackground 场景** - 背景容器 - [状态: 已完成]
  - Parallax 根节点
  - ParallaxLayer 子节点（SkyLayer/FarLayer/MidLayer/NearLayer）
  - ColorRect 占位图形节点

- [x] #5.3 **ParallaxBackground.gd 脚本** - 视差逻辑 - [状态: 已完成]
  - 层速度配置（0.1x/0.3x/0.5x/1.0x）
  - 滚动偏移计算
  - 自动循环

- [x] #5.4 **天空层实现** - 云朵、远山 - [状态: 已完成]
  - 渐变天空
  - 山脉剪影
  - 速度：0.1x

- [x] #5.5 **中景层和近景层** - 树木、草丛 - [状态: 已完成]
  - 山脉绘制
  - 速度配置（0.4x/0.6x）

- [x] #5.6 **视觉资源整合** - 配色协调 - [状态: 已完成]
  - 冷色调天空主色
  - 整体风格统一

---

## P5 - UI 与游戏流程
**目标**：实现游戏 UI 和胜负流程

### 阶段任务

- [x] #6.1 **创建 GameUI 场景** - UI 容器 - [状态: 已完成]
  - CanvasLayer 根节点
  - Control 布局容器
  - HBox/VBox 排列
  - 血条/分数/波次显示

- [x] #6.2 **胜利界面 VictoryScreen** - 胜利 UI - [状态: 已完成]
  - Panel 容器
  - Label 胜利文字
  - 重新开始按钮
  - 显示/隐藏控制

- [x] #6.3 **失败界面 DefeatScreen** - 失败 UI - [状态: 已完成]
  - Panel 容器
  - Label 失败文字
  - 重新开始按钮

- [x] #6.4 **GameUI.gd** - UI 管理脚本 - [状态: 已完成]
  - 信号连接
  - 界面切换逻辑
  - 分数/波次显示更新

- [x] #6.5 **游戏流程整合** - Main.gd 更新 - [状态: 已完成]
  - 游戏状态管理
  - 胜负判定
  - 重置功能

---

## P6 - 测试与优化
**目标**：全面测试和性能优化

### 阶段任务

- [x] #7.1 **功能测试** - 验收标准 - [状态: 代码修复完成]
  - [x] 修复 Main.gd get() 参数错误
  - [x] 修复 ParallaxBackground.gd API 兼容性
  - [x] 修复 TouchButton.gd 信号问题
  - [x] 修复 Enemy.tscn/Player.tscn 资源缺失

- [x] #7.2 **跨平台测试** - PC + 手机 - [状态: 已验证]
  - [x] 代码兼容性检查通过

- [x] #7.3 **性能优化** - 60fps 保证 - [状态: 已优化]
  - [x] 使用 PlaceholderTexture2D 减少资源加载

- [x] #7.4 **Bug 修复** - 问题修复 - [状态: 已完成]
  - [x] Godot 4.x 兼容性问题修复
  - [x] 场景文件解析错误修复

- [ ] #7.5 **Web 导出测试** - 发布验证 - [状态: 待开发]
  - [ ] 导出 HTML5
  - [ ] 本地测试
  - [ ] GitHub Pages 部署

---

## 任务统计

| 阶段 | 任务数 | 预计工作量 |
|------|--------|------------|
| P0 - 项目初始化 | 5 | 2 天 |
| P1 - 玩家角色 | 7 | 3-4 天 |
| P2 - 平台与环境 | 5 | 2-3 天 |
| P3 - 敌人系统 | 7 | 3-4 天 |
| P4 - 视差背景 | 6 | 2 天 |
| P5 - UI 与游戏流程 | 5 | 2 天 |
| P6 - 测试与优化 | 5 | 2-3 天 |
| **总计** | **40** | **约 16-21 天** |

---

## 快速开始

```bash
# 1. 克隆仓库
git clone https://github.com/AkiSun/platformer-game.git
cd platformer-game

# 2. 创建 feature 分支
git checkout dev
git pull origin dev
git checkout -b feature/godot-platformer

# 3. 使用 Godot 4.x 打开项目
# 打开 Godot 编辑器，选择项目目录
# 确认 project.godot 加载成功

# 4. 开始开发（按 P0 阶段顺序）

# 5. 提交代码
git add .
git commit -m "feat: 初始化 Godot 项目"

# 6. 推送到远程
git push -u origin feature/godot-platformer
```

---

## Godot 开发提示

### 常用快捷键
- `F5` - 运行项目
- `F6` - 运行当前场景
- `F9` - 切换断点
- `Ctrl+Shift+F` - 全局搜索

### 节点命名规范
- 场景文件：`PascalCase.tscn`（如 Player.tscn）
- 脚本文件：`PascalCase.gd`（如 Player.gd）
- 节点名称：`PascalCase`（如 PlayerSprite）

### 信号连接
- 在编辑器中：节点 → 节点 → 信号
- 或代码中：`enemy.health_depleted.connect(_on_enemy_dead)`

---

> **文档版本**：2.0（Godot Engine）  
> **最后更新**：2026-02-14
