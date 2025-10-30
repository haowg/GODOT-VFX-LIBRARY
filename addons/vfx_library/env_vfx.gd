extends Node
## 环境特效管理器
## 处理环境元素、机关、道具的视觉特效

# 预加载粒子特效场景
const TORCH_FIRE_SCENE = preload("res://addons/vfx_library/effects/torch_fire.tscn")
const FIREFLIES_SCENE = preload("res://addons/vfx_library/effects/fireflies.tscn")
const STEAM_SCENE = preload("res://addons/vfx_library/effects/steam.tscn")
const SPARKS_SCENE = preload("res://addons/vfx_library/effects/sparks.tscn")
const WATER_SPLASH_SCENE = preload("res://addons/vfx_library/effects/water_splash.tscn")
const DUST_CLOUD_SCENE = preload("res://addons/vfx_library/effects/dust_cloud.tscn")
const MAGIC_AURA_SCENE = preload("res://addons/vfx_library/effects/magic_aura.tscn")
const POISON_CLOUD_SCENE = preload("res://addons/vfx_library/effects/poison_cloud.tscn")
const FALLING_LEAVES_SCENE = preload("res://addons/vfx_library/effects/falling_leaves.tscn")
const WOOD_DEBRIS_SCENE = preload("res://addons/vfx_library/effects/wood_debris.tscn")

# 新增法术/技能特效场景
const PORTAL_VORTEX_SCENE = preload("res://addons/vfx_library/effects/portal_vortex.tscn")
const LIGHTNING_CHAIN_SCENE = preload("res://addons/vfx_library/effects/lightning_chain.tscn")
const ICE_FROST_SCENE = preload("res://addons/vfx_library/effects/ice_frost.tscn")
const FIREBALL_TRAIL_SCENE = preload("res://addons/vfx_library/effects/fireball_trail.tscn")
const SUMMON_CIRCLE_SCENE = preload("res://addons/vfx_library/effects/summon_circle.tscn")

# 新增环境特效场景
const RAIN_DROPS_SCENE = preload("res://addons/vfx_library/effects/rain_drops.tscn")
const SNOW_FLAKES_SCENE = preload("res://addons/vfx_library/effects/snow_flakes.tscn")
const WATERFALL_MIST_SCENE = preload("res://addons/vfx_library/effects/waterfall_mist.tscn")
const CAMPFIRE_SMOKE_SCENE = preload("res://addons/vfx_library/effects/campfire_smoke.tscn")
const CANDLE_FLAME_SCENE = preload("res://addons/vfx_library/effects/candle_flame.tscn")
const ASH_PARTICLES_SCENE = preload("res://addons/vfx_library/effects/ash_particles.tscn")


# ===== 辅助函数 =====

## 获取当前场景根节点
func _get_scene_root() -> Node:
    var scene_root = get_tree().current_scene
    if not scene_root:
        push_error("EnvVFX: No current scene found")
        return null
    return scene_root


## 延迟清理节点（安全的异步清理）
func _cleanup_delayed(node: Node, delay: float) -> void:
    await get_tree().create_timer(delay).timeout
    if is_instance_valid(node):
        node.queue_free()


# ===== 基础环境特效 =====

## 火把/火焰效果
func create_torch(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var fire = TORCH_FIRE_SCENE.instantiate()
    parent.add_child(fire)
    fire.position = offset
    fire.z_index = -1  # 在物体后面
    return fire


## 萤火虫环境光效
func create_fireflies(parent: Node2D, area_size: Vector2 = Vector2(200, 100)) -> CPUParticles2D:
    var fireflies = FIREFLIES_SCENE.instantiate()
    parent.add_child(fireflies)
    fireflies.emission_rect_extents = area_size / 2
    return fireflies


## 落叶效果
func create_falling_leaves(parent: Node2D, width: float = 300.0) -> CPUParticles2D:
    var leaves = FALLING_LEAVES_SCENE.instantiate()
    parent.add_child(leaves)
    leaves.position.y = -50  # 从上方开始
    leaves.emission_rect_extents = Vector2(width / 2, 10)
    return leaves


## 蒸汽/烟雾效果（用于温泉、通风口等）
func create_steam(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    if not is_instance_valid(parent):
        push_error("EnvVFX: create_steam called with invalid parent")
        return null

    var steam = STEAM_SCENE.instantiate()
    parent.add_child(steam)
    steam.position = offset
    steam.restart()  # 使用 restart() 确保 one_shot 粒子正确发射
    return steam


## 电火花效果（用于机关、电线、陷阱）
func create_sparks(parent: Node2D, offset: Vector2 = Vector2.ZERO, continuous: bool = false) -> CPUParticles2D:
    var sparks = SPARKS_SCENE.instantiate()
    parent.add_child(sparks)
    sparks.position = offset
    sparks.emitting = continuous
    sparks.one_shot = !continuous
    return sparks


## 木屑飞溅（箱子破碎、木板断裂）
func create_wood_debris(pos: Vector2, direction: Vector2 = Vector2.RIGHT, parent: Node = null) -> void:
    if parent == null:
        parent = _get_scene_root()
        if not parent:
            return

    if not is_instance_valid(parent):
        push_error("EnvVFX: create_wood_debris called with invalid parent")
        return

    var debris = WOOD_DEBRIS_SCENE.instantiate()
    parent.add_child(debris)
    debris.global_position = pos
    debris.direction = direction
    debris.restart()  # 使用 restart() 确保 one_shot 粒子正确发射

    _cleanup_delayed(debris, 2.0)


## 水花飞溅
func create_water_splash(pos: Vector2, size: float = 1.0, parent: Node = null) -> void:
    if parent == null:
        parent = _get_scene_root()
        if not parent:
            return

    if not is_instance_valid(parent):
        push_error("EnvVFX: create_water_splash called with invalid parent")
        return

    var splash = WATER_SPLASH_SCENE.instantiate()
    parent.add_child(splash)
    splash.global_position = pos
    splash.amount = int(25 * size)
    # 降低速度增长系数，避免崩太远
    # 场景基准: 80-150, 使用渐进式增长而非线性
    splash.initial_velocity_min = 80.0 * (1.0 + (size - 1.0) * 0.3)
    splash.initial_velocity_max = 150.0 * (1.0 + (size - 1.0) * 0.3)
    splash.scale_amount_min = size
    splash.scale_amount_max = 2.0 * size
    splash.restart()  # 使用 restart() 确保 one_shot 粒子正确发射

    _cleanup_delayed(splash, 1.0)


## 尘土扬起（角色落地、重物掉落）
func create_dust_cloud(pos: Vector2, size: float = 1.0, parent: Node = null) -> void:
    if parent == null:
        parent = _get_scene_root()
        if not parent:
            return

    if not is_instance_valid(parent):
        push_error("EnvVFX: create_dust_cloud called with invalid parent")
        return

    var dust = DUST_CLOUD_SCENE.instantiate()
    parent.add_child(dust)
    dust.global_position = pos
    dust.amount = int(20 * size)
    dust.initial_velocity_min = 20.0 * size
    dust.initial_velocity_max = 50.0 * size
    dust.scale_amount_min = 0.5 * size
    dust.scale_amount_max = 1.5 * size
    dust.restart()  # 使用 restart() 确保 one_shot 粒子正确发射

    # 自动删除
    await get_tree().create_timer(2.0).timeout
    if dust:
        dust.queue_free()


## 魔法光环（用于传送门、神秘物体）
func create_magic_aura(parent: Node2D, color: Color = Color(0.5, 0.3, 1.0), radius: float = 60.0) -> GPUParticles2D:
    var aura = MAGIC_AURA_SCENE.instantiate()
    parent.add_child(aura)
    
    # 获取 ParticleProcessMaterial 来设置环形半径
    var material = aura.process_material as ParticleProcessMaterial
    if material:
        material.emission_ring_radius = radius
        material.emission_ring_inner_radius = radius - 7.0
        
        # 只有当传入的颜色不是默认紫色时，才自定义颜色
        if not color.is_equal_approx(Color(0.5, 0.3, 1.0)):
            # 创建5点渐变，匹配场景文件的结构
            var gradient = Gradient.new()
            gradient.offsets = PackedFloat32Array([0.0, 0.2, 0.5, 0.8, 1.0])
            gradient.colors = PackedColorArray([
                Color(color.r * 0.6, color.g * 0.3, color.b * 0.8, 0.0),
                Color(color.r, color.g * 0.8, color.b, 0.9),
                Color(color.r, color.g, color.b, 1.0),
                Color(color.r * 1.2, color.g * 1.2, color.b, 0.7),
                Color(1.0, 0.9 + color.g * 0.1, 1.0, 0.0)
            ])
            material.color_ramp = gradient
        # 否则使用场景文件中预设的漂亮渐变

    return aura


## 毒雾效果（毒气陷阱、毒液）
func create_poison_cloud(pos: Vector2, size: float = 1.0, parent: Node = null) -> CPUParticles2D:
    if parent == null:
        parent = get_tree().current_scene

    var poison = POISON_CLOUD_SCENE.instantiate()
    parent.add_child(poison)
    poison.global_position = pos
    poison.amount = int(25 * size)
    poison.emission_sphere_radius = 15.0 * size
    poison.initial_velocity_min = 10.0
    poison.initial_velocity_max = 30.0
    poison.scale_amount_min = 0.8 * size
    poison.scale_amount_max = 1.5 * size
    poison.emitting = true

    return poison


# ===== 新增法术/技能特效 =====

## 传送门漩涡
func create_portal(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var portal = PORTAL_VORTEX_SCENE.instantiate()
    parent.add_child(portal)
    portal.position = offset
    portal.emitting = true
    return portal


## 闪电链
func spawn_lightning_chain(pos: Vector2) -> void:
    var scene_root = _get_scene_root()
    if not scene_root:
        return

    var lightning = LIGHTNING_CHAIN_SCENE.instantiate()
    scene_root.add_child(lightning)
    lightning.global_position = pos

    # 显式重启所有子粒子发射器，确保即使场景文件被编辑器修改也能正常工作
    for child in lightning.get_children():
        if child is CPUParticles2D:
            child.emitting = false  # 先停止
            child.restart()  # 然后重启，这样 one_shot 粒子会正确发射

    _cleanup_delayed(lightning, 0.4)


## 冰霜效果
func spawn_ice_frost(pos: Vector2) -> void:
    var scene_root = _get_scene_root()
    if not scene_root:
        return

    var frost = ICE_FROST_SCENE.instantiate()
    scene_root.add_child(frost)
    frost.global_position = pos
    frost.restart()  # 使用 restart() 而不是设置 emitting，更可靠

    _cleanup_delayed(frost, 1.0)


## 火球拖尾（持续发射）
func create_fireball_trail(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var trail = FIREBALL_TRAIL_SCENE.instantiate()
    parent.add_child(trail)
    trail.position = offset
    trail.emitting = true
    return trail


## 召唤阵
func create_summon_circle(parent: Node2D, offset: Vector2 = Vector2.ZERO, radius: float = 50.0) -> CPUParticles2D:
    var circle = SUMMON_CIRCLE_SCENE.instantiate()
    parent.add_child(circle)
    circle.position = offset
    circle.emission_rect_extents = Vector2(radius, 5.0)
    circle.emitting = true
    return circle


# ===== 新增环境特效 =====

## 雨滴
func create_rain(parent: Node2D, area_width: float = 600.0) -> CPUParticles2D:
    var rain = RAIN_DROPS_SCENE.instantiate()
    parent.add_child(rain)
    rain.emission_rect_extents = Vector2(area_width / 2, 10)
    rain.emitting = true
    return rain


## 雪花
func create_snow(parent: Node2D, area_width: float = 600.0) -> CPUParticles2D:
    var snow = SNOW_FLAKES_SCENE.instantiate()
    parent.add_child(snow)
    snow.emission_rect_extents = Vector2(area_width / 2, 10)
    snow.emitting = true
    return snow


## 瀑布水雾
func create_waterfall_mist(parent: Node2D, offset: Vector2 = Vector2.ZERO, width: float = 80.0) -> CPUParticles2D:
    var mist = WATERFALL_MIST_SCENE.instantiate()
    parent.add_child(mist)
    mist.position = offset
    mist.emission_rect_extents = Vector2(width / 2, 10)
    mist.emitting = true
    return mist


## 篝火烟雾
func create_campfire_smoke(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var smoke = CAMPFIRE_SMOKE_SCENE.instantiate()
    parent.add_child(smoke)
    smoke.position = offset
    smoke.emitting = true
    return smoke


## 蜡烛火焰
func create_candle_flame(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D:
    var candle = CANDLE_FLAME_SCENE.instantiate()
    parent.add_child(candle)
    candle.position = offset
    candle.emitting = true
    return candle


## 灰烬飘散
func create_ash_particles(parent: Node2D, area_size: Vector2 = Vector2(60, 20)) -> CPUParticles2D:
    var ash = ASH_PARTICLES_SCENE.instantiate()
    parent.add_child(ash)
    ash.emission_rect_extents = area_size / 2
    ash.emitting = true
    return ash
