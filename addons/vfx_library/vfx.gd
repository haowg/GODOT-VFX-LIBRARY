extends Node
## 全局特效管理器
## 提供战斗、UI、移动等各类视觉特效
## 作为 Autoload 单例使用

# ===== 常量定义 =====
const SHAKE_INTERVAL: float = 0.05
const DEFAULT_CLEANUP_DELAY: float = 1.2

# 预加载战斗粒子场景
const COMBAT_PARTICLE_SCENE = preload("res://addons/vfx_library/effects/combat_particle.tscn")
const BLOOD_SPLASH_SCENE = preload("res://addons/vfx_library/effects/blood_splash.tscn")
const ENERGY_BURST_SCENE = preload("res://addons/vfx_library/effects/energy_burst.tscn")
const HEAL_PARTICLES_SCENE = preload("res://addons/vfx_library/effects/heal_particles.tscn")
const SHIELD_BREAK_SCENE = preload("res://addons/vfx_library/effects/shield_break.tscn")
const COMBO_RING_SCENE = preload("res://addons/vfx_library/effects/combo_ring.tscn")
const DASH_TRAIL_SCENE = preload("res://addons/vfx_library/effects/dash_trail.tscn")
const JUMP_DUST_SCENE = preload("res://addons/vfx_library/effects/jump_dust.tscn")
const WALL_SLIDE_SPARK_SCENE = preload("res://addons/vfx_library/effects/wall_slide_spark.tscn")

# ===== Time Scale / Freeze Frame (stacked) =====
# 多处逻辑可能同时触发顿帧。这里用 token 方式叠加：
# - 生效时取所有请求中的最小 time_scale
# - 每个请求结束只撤销自己，避免互相覆盖导致“有时慢放有时没有”
var _time_scale_requests: Dictionary = {} # token -> requested scale
var _time_scale_token_counter: int = 0
var _time_scale_original: float = 1.0
func _ready() -> void:
	# 确保在场景切换时重置time_scale
	if get_tree():
		get_tree().tree_exiting.connect(_cleanup_on_exit)

func _cleanup_on_exit() -> void:
	# 清理所有挂起的time_scale请求
	_time_scale_requests.clear()
	Engine.time_scale = 1.0
func _apply_time_scale_requests() -> void:
	if _time_scale_requests.is_empty():
		Engine.time_scale = _time_scale_original
		return

	var min_req: float = 1.0
	for v in _time_scale_requests.values():
		min_req = minf(min_req, float(v))

	# Never speed up above baseline.
	Engine.time_scale = minf(_time_scale_original, min_req)


# ===== 屏幕特效 =====

## 屏幕震动效果
## 使用更高效的 tween 链式调用，避免循环创建
func screen_shake(intensity: float = 10.0, duration: float = 0.2) -> void:
	var camera = get_viewport().get_camera_2d()
	if not camera:
		push_warning("VFX: No Camera2D found for screen shake")
		return
	
	var original_offset = camera.offset
	var shake_count = max(1, int(duration / SHAKE_INTERVAL))
	var tween = create_tween()
	
	# 使用 tween 链式调用代替循环，性能更好
	tween.set_ease(Tween.EASE_OUT)
	for i in shake_count:
		var shake_offset = Vector2(
			randf_range(-intensity, intensity),
			randf_range(-intensity, intensity)
		)
		tween.tween_property(camera, "offset", original_offset + shake_offset, SHAKE_INTERVAL)
	
	# 平滑恢复原位
	tween.tween_property(camera, "offset", original_offset, SHAKE_INTERVAL)


## 时间冻结（受击暂停）
## 注意：会影响整个游戏的时间流逝
func freeze_frame(duration: float = 0.1, time_scale: float = 0.05) -> void:
	# 安全检查：确保节点在场景树中
	if not is_inside_tree():
		push_warning("VFX: freeze_frame called when not inside tree")
		return
	
	var token := _time_scale_token_counter
	_time_scale_token_counter += 1

	if _time_scale_requests.is_empty():
		_time_scale_original = Engine.time_scale

	_time_scale_requests[token] = clampf(time_scale, 0.0, 1.0)
	_apply_time_scale_requests()

	# 使用物理帧计时器，不受 time_scale 影响
	# 保存timer引用以便清理
	var timer = get_tree().create_timer(duration, true, false, true)
	if not is_instance_valid(timer):
		_time_scale_requests.erase(token)
		_apply_time_scale_requests()
		return
	
	await timer.timeout
	
	# 清理时再次检查节点是否仍在场景树中
	if not is_inside_tree():
		return

	_time_scale_requests.erase(token)
	_apply_time_scale_requests()


## 暴击特效组合
func critical_hit(pos: Vector2) -> void:
	screen_shake(15.0, 0.25)
	freeze_frame(0.12, 0.05)
	spawn_particles(pos, Color(1.0, 0.8, 0.0), 15)


## 击杀特效组合
func kill_effect(pos: Vector2) -> void:
	screen_shake(12.0, 0.2)
	freeze_frame(0.08, 0.1)
	spawn_particles(pos, Color(1.0, 0.3, 0.3), 20)


# ===== 粒子特效 =====

## 生成彩色粒子
## @param pos: 生成位置
## @param particle_color: 粒子颜色
## @param count: 粒子数量
func spawn_particles(pos: Vector2, particle_color: Color, count: int = 15) -> void:
	var particles = COMBAT_PARTICLE_SCENE.instantiate()
	var scene_root = get_tree().current_scene
	if not scene_root:
		push_error("VFX: Cannot spawn particles - no current scene")
		particles.queue_free()
		return
	
	particles.global_position = pos
	scene_root.add_child(particles)
	
	particles.amount = clampi(count, 1, 100)  # 限制粒子数量
	
	# 动态创建颜色渐变
	var gradient = Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
	gradient.colors = PackedColorArray([
		particle_color,
		Color(particle_color.r * 0.8, particle_color.g * 0.6, particle_color.b * 0.4, 0.8),
		Color(particle_color.r * 0.3, particle_color.g * 0.3, particle_color.b * 0.3, 0.0)
	])
	particles.color_ramp = gradient
	
	# 触发发射
	particles.emitting = true
	
	# 自动清理（使用更安全的方式）
	_cleanup_particle_delayed(particles, DEFAULT_CLEANUP_DELAY)


## 延迟清理粒子节点（内部方法）
func _cleanup_particle_delayed(particle: Node, delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	if is_instance_valid(particle) and not particle.is_queued_for_deletion():
		particle.queue_free()


# ===== UI 特效 =====

## 闪白效果（受击反馈）
func flash_white(node: CanvasItem, duration: float = 0.1) -> void:
	if not is_instance_valid(node):
		push_warning("VFX: flash_white called with invalid node")
		return
	
	var original_modulate = node.modulate
	node.modulate = Color.WHITE
	
	var tween = create_tween()
	tween.tween_property(node, "modulate", original_modulate, duration)


## 伤害数字显示
## @param pos: 显示位置
## @param damage: 伤害值
## @param is_critical: 是否暴击
func spawn_damage_number(pos: Vector2, damage: int, is_critical: bool = false) -> void:
	var scene_root = get_tree().current_scene
	if not scene_root:
		push_error("VFX: Cannot spawn damage number - no current scene")
		return
	
	var label = Label.new()
	scene_root.add_child(label)
	label.global_position = pos
	label.text = str(damage)
	label.z_index = 100
	
	# 根据是否暴击设置样式
	var font_size = 32 if is_critical else 24
	var font_color = Color(1.0, 0.8, 0.0) if is_critical else Color.WHITE
	
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 2)
	
	# 动画：上浮 + 淡出
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position:y", label.position.y - 50, 0.5)
	tween.tween_property(label, "modulate:a", 0.0, 0.5).set_delay(0.2)
	
	# 等待动画完成后清理
	await tween.finished
	if is_instance_valid(label):
		label.queue_free()


# ===== 新增战斗特效 =====

# ===== 战斗特效 =====

## 血液飞溅效果
func spawn_blood_splash(pos: Vector2) -> void:
	_spawn_oneshot_effect(BLOOD_SPLASH_SCENE, pos, 1.0)


## 能量爆发效果
## @param color: 爆发颜色，默认为青色
func spawn_energy_burst(pos: Vector2, color: Color = Color(0.5, 0.8, 1.0)) -> void:
	var energy = ENERGY_BURST_SCENE.instantiate()
	var scene_root = get_tree().current_scene
	if not scene_root:
		energy.queue_free()
		return
	
	energy.global_position = pos
	scene_root.add_child(energy)	
	energy.emitting = true
	
	# 动态修改颜色渐变
	var gradient = Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.4, 1.0])
	gradient.colors = PackedColorArray([
		Color.WHITE,
		color,
		Color(color.r * 0.3, color.g * 0.3, color.b * 0.3, 0.0)
	])
	energy.color_ramp = gradient
	
	_cleanup_particle_delayed(energy, 1.0)


## 治疗粒子效果
func spawn_heal_effect(pos: Vector2) -> void:
	_spawn_oneshot_effect(HEAL_PARTICLES_SCENE, pos, 2.0)


## 护盾破碎效果
func spawn_shield_break(pos: Vector2) -> void:
	_spawn_oneshot_effect(SHIELD_BREAK_SCENE, pos, 0.8)


## 连击特效
func spawn_combo_ring(pos: Vector2) -> void:
	_spawn_oneshot_effect(COMBO_RING_SCENE, pos, 0.6)


## 内部方法：生成一次性粒子特效
func _spawn_oneshot_effect(scene: PackedScene, pos: Vector2, lifetime: float) -> void:
	var effect = scene.instantiate()
	var scene_root = get_tree().current_scene
	if not scene_root:
		effect.queue_free()
		return
	
	effect.global_position = pos
	scene_root.add_child(effect)
	effect.emitting = true
	
	_cleanup_particle_delayed(effect, lifetime)


# ===== 移动特效 =====

## 创建冲刺残影（持续发射）
## 需要手动管理生命周期
func create_dash_trail(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
	if not is_instance_valid(parent):
		push_error("VFX: create_dash_trail called with invalid parent")
		return null
	
	var trail = DASH_TRAIL_SCENE.instantiate()
	parent.add_child(trail)
	trail.position = offset
	trail.emitting = true
	return trail


## 跳跃尘土效果
func spawn_jump_dust(pos: Vector2) -> void:
	_spawn_oneshot_effect(JUMP_DUST_SCENE, pos, 0.5)


## 创建墙壁滑行火花（持续发射）
## 需要手动管理生命周期
func create_wall_slide_spark(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
	if not is_instance_valid(parent):
		push_error("VFX: create_wall_slide_spark called with invalid parent")
		return null
	
	var spark = WALL_SLIDE_SPARK_SCENE.instantiate()
	parent.add_child(spark)
	spark.position = offset
	spark.emitting = true
	return spark
