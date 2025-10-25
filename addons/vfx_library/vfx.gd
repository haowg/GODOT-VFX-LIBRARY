extends Node
## 全局特效管理器 - 简化版
## 直接使用 autoload，不需要实例化

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

# 震屏效果
func screen_shake(intensity: float = 10.0, duration: float = 0.2) -> void:
    var camera = get_viewport().get_camera_2d()
    if not camera:
        return

    var original_offset = camera.offset
    var tween = create_tween()

    # 快速震动
    for i in range(int(duration / 0.05)):
        var shake_offset = Vector2(
            randf_range(-intensity, intensity),
            randf_range(-intensity, intensity)
        )
        tween.tween_property(camera, "offset", original_offset + shake_offset, 0.05)

    # 恢复
    tween.tween_property(camera, "offset", original_offset, 0.05)


# 时间冻结（受击暂停）
func freeze_frame(duration: float = 0.1, time_scale: float = 0.05) -> void:
    Engine.time_scale = time_scale
    await get_tree().create_timer(duration, true, false, true).timeout
    Engine.time_scale = 1.0


# 暴击特效
func critical_hit(pos: Vector2) -> void:
    screen_shake(15.0, 0.25)
    freeze_frame(0.12, 0.05)
    spawn_particles(pos, Color(1, 0.8, 0), 15)


# 击杀特效
func kill_effect(pos: Vector2) -> void:
    screen_shake(12.0, 0.2)
    freeze_frame(0.08, 0.1)
    spawn_particles(pos, Color(1, 0.3, 0.3), 20)


# 生成粒子（使用场景）
func spawn_particles(pos: Vector2, particle_color: Color, count: int = 15) -> void:
    var particles = COMBAT_PARTICLE_SCENE.instantiate()
    get_tree().current_scene.add_child(particles)
    particles.global_position = pos
    
    # 设置粒子数量
    particles.amount = count
    
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
    
    # 自动删除
    await get_tree().create_timer(1.2).timeout
    if is_instance_valid(particles):
        particles.queue_free()


# 闪光效果
func flash_white(node: CanvasItem, duration: float = 0.1) -> void:
    if not node:
        return

    var original_modulate = node.modulate
    node.modulate = Color.WHITE

    var tween = create_tween()
    tween.tween_property(node, "modulate", original_modulate, duration)


# 伤害数字（简单版）
func spawn_damage_number(pos: Vector2, damage: int, is_critical: bool = false) -> void:
    var label = Label.new()
    get_tree().current_scene.add_child(label)
    label.global_position = pos
    label.text = str(damage)
    label.add_theme_font_size_override("font_size", 24 if not is_critical else 32)
    label.add_theme_color_override("font_color", Color.WHITE if not is_critical else Color(1, 0.8, 0))
    label.add_theme_color_override("font_outline_color", Color.BLACK)
    label.add_theme_constant_override("outline_size", 2)
    label.z_index = 100

    # 动画
    var tween = create_tween()
    tween.set_parallel(true)
    tween.tween_property(label, "position:y", label.position.y - 50, 0.5)
    tween.tween_property(label, "modulate:a", 0.0, 0.5).set_delay(0.2)

    await tween.finished
    label.queue_free()


# ===== 新增战斗特效 =====

# 血液飞溅
func spawn_blood_splash(pos: Vector2) -> void:
    var blood = BLOOD_SPLASH_SCENE.instantiate()
    get_tree().current_scene.add_child(blood)
    blood.global_position = pos
    blood.emitting = true
    await get_tree().create_timer(1.0).timeout
    if is_instance_valid(blood):
        blood.queue_free()


# 能量爆发
func spawn_energy_burst(pos: Vector2, color: Color = Color(0.5, 0.8, 1.0)) -> void:
    var energy = ENERGY_BURST_SCENE.instantiate()
    get_tree().current_scene.add_child(energy)
    energy.global_position = pos
    energy.emitting = true
    # 可以动态修改颜色
    var gradient = Gradient.new()
    gradient.offsets = PackedFloat32Array([0, 0.4, 1])
    gradient.colors = PackedColorArray([
        Color.WHITE,
        color,
        Color(color.r * 0.3, color.g * 0.3, color.b * 0.3, 0)
    ])
    energy.color_ramp = gradient
    await get_tree().create_timer(1.0).timeout
    if is_instance_valid(energy):
        energy.queue_free()


# 治疗粒子
func spawn_heal_effect(pos: Vector2) -> void:
    var heal = HEAL_PARTICLES_SCENE.instantiate()
    get_tree().current_scene.add_child(heal)
    heal.global_position = pos
    heal.emitting = true
    await get_tree().create_timer(2.0).timeout
    if is_instance_valid(heal):
        heal.queue_free()


# 护盾破碎
func spawn_shield_break(pos: Vector2) -> void:
    var shield = SHIELD_BREAK_SCENE.instantiate()
    get_tree().current_scene.add_child(shield)
    shield.global_position = pos
    shield.emitting = true
    await get_tree().create_timer(0.8).timeout
    if is_instance_valid(shield):
        shield.queue_free()


# 连击特效
func spawn_combo_ring(pos: Vector2) -> void:
    var combo = COMBO_RING_SCENE.instantiate()
    get_tree().current_scene.add_child(combo)
    combo.global_position = pos
    combo.emitting = true
    await get_tree().create_timer(0.6).timeout
    if is_instance_valid(combo):
        combo.queue_free()


# ===== 移动特效 =====

# 冲刺残影（持续发射）
func create_dash_trail(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var trail = DASH_TRAIL_SCENE.instantiate()
    parent.add_child(trail)
    trail.position = offset
    trail.emitting = true
    return trail


# 跳跃尘土
func spawn_jump_dust(pos: Vector2) -> void:
    var dust = JUMP_DUST_SCENE.instantiate()
    get_tree().current_scene.add_child(dust)
    dust.global_position = pos
    dust.emitting = true
    await get_tree().create_timer(0.5).timeout
    if is_instance_valid(dust):
        dust.queue_free()


# 墙壁滑行火花（持续发射）
func create_wall_slide_spark(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var spark = WALL_SLIDE_SPARK_SCENE.instantiate()
    parent.add_child(spark)
    spark.position = offset
    spark.emitting = true
    return spark
