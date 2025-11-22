extends Node2D
## 特效系统测试场景 - 使用列表选择特效

# 常量定义
const DEFAULT_WATER_SPLASH_SIZE = 3.0
const DEFAULT_DUST_CLOUD_SIZE = 3.0
const DEFAULT_POISON_CLOUD_SIZE = 2.0
const DEFAULT_MAGIC_AURA_RADIUS = 60.0
const DEFAULT_LEAVES_WIDTH = 300.0
const DEFAULT_RAIN_AREA_WIDTH = 400.0
const DEFAULT_SUMMON_CIRCLE_RADIUS = 60.0
const DEFAULT_WATERFALL_MIST_WIDTH = 80.0
const DEFAULT_ASH_AREA_SIZE = Vector2(60, 20)
const DEFAULT_PARTICLE_COUNT = 20

# UI 节点引用
@onready var effect_list: ItemList = $UI/Panel/VBox/ScrollContainer/EffectList
@onready var clear_button: Button = $UI/Panel/VBox/ButtonContainer/ClearButton
@onready var shader_list: ItemList = $UI/ShaderPanel/VBox2/ScrollContainer2/ShaderList
@onready var apply_shader_button: Button = $UI/ShaderPanel/VBox2/ShaderButtonContainer/ApplyShaderButton
@onready var remove_shader_button: Button = $UI/ShaderPanel/VBox2/ShaderButtonContainer/RemoveShaderButton
@onready var shader_test_sprite: Sprite2D = $ShaderTestSprite

# 特效配置数据
var effects_data = []
var current_effect_index = 0

# Shader配置数据
var shaders_data = []
var current_shader_index = -1
var shader_animation_time = 0.0  # 用于shader动画

# 用于跟踪所有生成的特效节点
var spawned_effects = []

func _enter_tree() -> void:
    # Add demo translations when demo scene is ran
    var translation = load("res://addons/vfx_library/demo/vfx_demo.en.translation")
    TranslationServer.add_translation(translation)        
    var translation_zh = load("res://addons/vfx_library/demo/vfx_demo.zh.translation")
    TranslationServer.add_translation(translation_zh)

func _ready():
    print("=== " + tr("VFX_TEST_SCENE") + " ===")

    # 检查 Autoload 是否配置
    check_autoloads()
    
    # 初始化特效列表
    setup_effects_list()
    
    # 初始化shader列表
    setup_shaders_list()
    
    # 连接信号
    if effect_list:
        effect_list.item_selected.connect(_on_effect_selected)
    if clear_button:
        clear_button.pressed.connect(_on_clear_button_pressed)
    if shader_list:
        shader_list.item_selected.connect(_on_shader_selected)
    if apply_shader_button:
        apply_shader_button.pressed.connect(_on_apply_shader_pressed)
    if remove_shader_button:
        remove_shader_button.pressed.connect(_on_remove_shader_pressed)


func setup_effects_list():
    """设置特效列表"""
    effects_data = [
        # 基础环境特效
        {"name": "EFFECT_TORCH_FIRE", "type": "env", "func": "create_torch"},
        {"name": "EFFECT_WATER_SPLASH", "type": "env", "func": "create_water_splash"},
        {"name": "EFFECT_DUST_CLOUD", "type": "env", "func": "create_dust_cloud"},
        {"name": "EFFECT_SPARKS", "type": "env", "func": "create_sparks"},
        {"name": "EFFECT_STEAM", "type": "env", "func": "create_steam"},
        {"name": "EFFECT_FIREFLIES", "type": "env", "func": "create_fireflies"},
        {"name": "EFFECT_MAGIC_AURA", "type": "env", "func": "create_magic_aura"},
        {"name": "EFFECT_POISON_CLOUD", "type": "env", "func": "create_poison_cloud"},
        {"name": "EFFECT_FALLING_LEAVES", "type": "env", "func": "create_falling_leaves"},
        {"name": "EFFECT_WOOD_DEBRIS", "type": "env_oneshot", "func": "create_wood_debris"},

        # 战斗粒子（不同颜色）
        {"name": "EFFECT_FIRE_PARTICLE", "type": "combat", "element": "fire"},
        {"name": "EFFECT_ICE_PARTICLE", "type": "combat", "element": "ice"},
        {"name": "EFFECT_POISON_PARTICLE", "type": "combat", "element": "poison"},
        {"name": "EFFECT_LIGHTNING_PARTICLE", "type": "combat", "element": "lightning"},
        {"name": "EFFECT_SHADOW_PARTICLE", "type": "combat", "element": "shadow"},

        # 新增战斗特效
        {"name": "EFFECT_BLOOD_SPLASH", "type": "vfx", "func": "spawn_blood_splash"},
        {"name": "EFFECT_ENERGY_BURST", "type": "vfx", "func": "spawn_energy_burst"},
        {"name": "EFFECT_HEAL", "type": "vfx", "func": "spawn_heal_effect"},
        {"name": "EFFECT_SHIELD_BREAK", "type": "vfx", "func": "spawn_shield_break"},
        {"name": "EFFECT_COMBO_RING", "type": "vfx", "func": "spawn_combo_ring"},
        {"name": "EFFECT_JUMP_DUST", "type": "vfx", "func": "spawn_jump_dust"},
        {"name": "EFFECT_DASH_TRAIL", "type": "vfx_continuous", "func": "create_dash_trail"},
        {"name": "EFFECT_WALL_SPARK", "type": "vfx_continuous", "func": "create_wall_slide_spark"},

        # 法术/技能特效
        {"name": "EFFECT_PORTAL", "type": "env_continuous", "func": "create_portal"},
        {"name": "EFFECT_LIGHTNING", "type": "env_oneshot", "func": "spawn_lightning_chain"},
        {"name": "EFFECT_ICE_FROST", "type": "env_oneshot", "func": "spawn_ice_frost"},
        {"name": "EFFECT_FIREBALL", "type": "env_continuous", "func": "create_fireball_trail"},
        {"name": "EFFECT_SUMMON", "type": "env_continuous", "func": "create_summon_circle"},

        # 环境特效
        {"name": "EFFECT_RAIN", "type": "env_continuous", "func": "create_rain"},
        {"name": "EFFECT_SNOW", "type": "env_continuous", "func": "create_snow"},
        {"name": "EFFECT_WATERFALL", "type": "env_continuous", "func": "create_waterfall_mist"},
        {"name": "EFFECT_CAMPFIRE", "type": "env_continuous", "func": "create_campfire_smoke"},
        {"name": "EFFECT_CANDLE", "type": "env_continuous", "func": "create_candle_flame"},
        {"name": "EFFECT_ASH", "type": "env_continuous", "func": "create_ash_particles"},
    ]
    
    # 填充列表
    if effect_list:
        for i in range(effects_data.size()):
            effect_list.add_item(tr(effects_data[i]["name"]))

        print("✓ " + tr("EFFECTS_LOADED") % effects_data.size())


func _on_effect_selected(index: int):
    """选择特效时调用"""
    current_effect_index = index
    print(tr("EFFECT_SELECTED") % tr(effects_data[index]["name"]))


func _on_clear_button_pressed():
    """清除所有生成的特效"""
    print(tr("CLEARING_EFFECTS"))
    var cleared_count = 0
    
    for effect_node in spawned_effects:
        if is_instance_valid(effect_node):
            effect_node.queue_free()
            cleared_count += 1
    
    spawned_effects.clear()
    print("✓ " + tr("EFFECTS_CLEARED") % cleared_count)


func spawn_current_effect(pos: Vector2):
    """在指定位置生成当前选中的特效"""
    if current_effect_index >= effects_data.size():
        return
    
    var effect = effects_data[current_effect_index]
    print(tr("SPAWNING_EFFECT") % [tr(effect["name"]), pos])
    
    match effect["type"]:
        "env":
            spawn_env_effect(effect, pos)
        "env_oneshot":
            spawn_env_oneshot(effect, pos)
        "combat":
            spawn_combat_particle(effect, pos)
        "vfx":
            spawn_vfx_effect(effect, pos)
        "vfx_continuous":
            spawn_vfx_continuous(effect, pos)  # 异步函数，但这里不需要等待完成
        "env_continuous":
            spawn_env_continuous(effect, pos)  # 异步函数，但这里不需要等待完成


func spawn_env_effect(effect: Dictionary, pos: Vector2):
    """生成环境特效（持续）"""
    if not has_node("/root/EnvVFX"):
        push_error(tr("AUTOLOAD_ENVVFX_FAILED"))
        return
    
    var env_vfx = get_node("/root/EnvVFX")
    var func_name = effect["func"]
    
    if env_vfx.has_method(func_name):
        # 根据不同的函数调用方式
        if func_name == "create_water_splash":
            # create_water_splash 是异步的，会自动清理
            # 使用更大的 size 参数让粒子更明显
            env_vfx.call(func_name, pos, DEFAULT_WATER_SPLASH_SIZE)
        elif func_name == "create_dust_cloud":
            # create_dust_cloud 是异步的，会自动清理
            # 使用更大的 size 参数让粒子更明显
            env_vfx.call(func_name, pos, DEFAULT_DUST_CLOUD_SIZE)
        elif func_name == "create_poison_cloud":
            # create_poison_cloud 返回粒子节点，可以手动管理
            var particle = env_vfx.call(func_name, pos, DEFAULT_POISON_CLOUD_SIZE)
            if particle:
                spawned_effects.append(particle)
        else:
            # 需要 holder 的持续特效
            var holder = Node2D.new()
            add_child(holder)
            holder.global_position = pos
            spawned_effects.append(holder)
            
            if func_name == "create_magic_aura":
                # 增大半径让光环更明显
                env_vfx.call(func_name, holder, Color(0.5, 0.3, 1.0), DEFAULT_MAGIC_AURA_RADIUS)
            elif func_name == "create_falling_leaves":
                env_vfx.call(func_name, holder, DEFAULT_LEAVES_WIDTH)
            elif func_name == "create_sparks":
                # 火花需要手动触发发射
                var sparks = env_vfx.call(func_name, holder, Vector2.ZERO, false)
                if sparks:
                    sparks.emitting = true
            else:
                env_vfx.call(func_name, holder, Vector2.ZERO)
    else:
        push_error(tr("METHOD_NOT_FOUND") % func_name)


func spawn_env_oneshot(effect: Dictionary, pos: Vector2):
    """生成环境一次性特效"""
    if not has_node("/root/EnvVFX"):
        push_error(tr("AUTOLOAD_ENVVFX_FAILED"))
        return
    
    var env_vfx = get_node("/root/EnvVFX")
    var func_name = effect["func"]
    
    if env_vfx.has_method(func_name):
        # 调用函数（可能是异步的，但我们不等待）
        # 直接调用，让协程在后台运行
        if func_name == "create_wood_debris":
            env_vfx.call(func_name, pos, Vector2.UP)
        else:
            env_vfx.call(func_name, pos)
        # 注意：这些函数会自动清理，不需要手动管理
    else:
        push_error(tr("METHOD_NOT_FOUND") % func_name)


func spawn_combat_particle(effect: Dictionary, pos: Vector2):
    """生成战斗粒子（不同颜色）"""
    if not has_node("/root/VFX"):
        push_error(tr("AUTOLOAD_VFX_FAILED"))
        return
    
    var vfx = get_node("/root/VFX")
    var element = effect.get("element", "fire")
    
    # 将元素名称转换为颜色
    var color_map = {
        "fire": Color(0.784, 0.238, 0.0, 1.0),
        "ice": Color(0.5, 0.8, 1.0),
        "poison": Color(0.3, 1.0, 0.3),
        "lightning": Color(1.0, 1.0, 0.3),
        "shadow": Color(0.7, 0.3, 1.0)
    }
    
    var particle_color = color_map.get(element, Color.RED)
    
    if vfx.has_method("spawn_particles"):
        # spawn_particles 是异步的，会自动清理
        vfx.spawn_particles(pos, particle_color, DEFAULT_PARTICLE_COUNT)
    else:
        push_error(tr("METHOD_NOT_FOUND") % "spawn_particles")


func spawn_vfx_effect(effect: Dictionary, pos: Vector2):
    """生成 VFX 特效（一次性）"""
    if not has_node("/root/VFX"):
        push_error(tr("AUTOLOAD_VFX_FAILED"))
        return
    
    var vfx = get_node("/root/VFX")
    var func_name = effect["func"]
    
    if vfx.has_method(func_name):
        # 调用函数（可能是异步的，但我们不等待）
        # 直接调用，让协程在后台运行
        if func_name == "spawn_energy_burst":
            vfx.call(func_name, pos, Color.CYAN)
        else:
            vfx.call(func_name, pos)
        # 注意：这些函数会自动清理，不需要手动管理
    else:
        push_error(tr("METHOD_NOT_FOUND") % func_name)


func spawn_vfx_continuous(effect: Dictionary, pos: Vector2):
    """生成 VFX 持续特效"""
    if not has_node("/root/VFX"):
        push_error(tr("AUTOLOAD_VFX_FAILED"))
        return
    
    var vfx = get_node("/root/VFX")
    var func_name = effect["func"]
    
    if vfx.has_method(func_name):
        # 创建一个容器节点
        var holder = Node2D.new()
        add_child(holder)
        holder.global_position = pos
        spawned_effects.append(holder)
        
        var _result = vfx.call(func_name, holder, Vector2.ZERO)
    else:
        push_error(tr("METHOD_NOT_FOUND") % func_name)


func spawn_env_continuous(effect: Dictionary, pos: Vector2):
    """生成环境持续特效"""
    if not has_node("/root/EnvVFX"):
        push_error(tr("AUTOLOAD_ENVVFX_FAILED"))
        return
    
    var env_vfx = get_node("/root/EnvVFX")
    var func_name = effect["func"]
    
    if env_vfx.has_method(func_name):
        # 创建一个临时容器节点
        var holder = Node2D.new()
        add_child(holder)
        holder.global_position = pos
        spawned_effects.append(holder)
        
        # 根据不同的函数调用方式
        if func_name in ["create_rain", "create_snow"]:
            var _result = env_vfx.call(func_name, holder, DEFAULT_RAIN_AREA_WIDTH)
        elif func_name == "create_summon_circle":
            var _result = env_vfx.call(func_name, holder, Vector2.ZERO, DEFAULT_SUMMON_CIRCLE_RADIUS)
        elif func_name == "create_waterfall_mist":
            var _result = env_vfx.call(func_name, holder, Vector2.ZERO, DEFAULT_WATERFALL_MIST_WIDTH)
        elif func_name == "create_ash_particles":
            var _result = env_vfx.call(func_name, holder, DEFAULT_ASH_AREA_SIZE)
        else:
            var _result = env_vfx.call(func_name, holder, Vector2.ZERO)
    else:
        push_error(tr("METHOD_NOT_FOUND") % func_name)


func check_autoloads():
    """检查必要的 Autoload 是否配置"""
    print("\n--- " + tr("CHECK_AUTOLOADS") + " ---")

    if has_node("/root/EnvVFX"):
        print("✓ " + tr("AUTOLOAD_ENVVFX_LOADED"))
    else:
        push_error("✗ " + tr("AUTOLOAD_ENVVFX_ERROR"))

    if has_node("/root/VFX"):
        print("✓ " + tr("AUTOLOAD_VFX_LOADED"))
    else:
        push_error("✗ " + tr("AUTOLOAD_VFX_ERROR"))

    print("-------------------------\n")


# ===== Shader 相关函数 =====

func setup_shaders_list():
    """初始化shader列表"""
    shaders_data = [
        {"name": "SHADER_BURNING", "path": "res://addons/vfx_library/shaders/burning.gdshader"},
        {"name": "SHADER_FROZEN", "path": "res://addons/vfx_library/shaders/frozen.gdshader"},
        {"name": "SHADER_POISON", "path": "res://addons/vfx_library/shaders/poison.gdshader"},
        {"name": "SHADER_PETRIFY", "path": "res://addons/vfx_library/shaders/petrify.gdshader"},
        {"name": "SHADER_INVISIBILITY", "path": "res://addons/vfx_library/shaders/invisibility.gdshader"},
        {"name": "SHADER_DISSOLVE", "path": "res://addons/vfx_library/shaders/dissolve.gdshader"},
        {"name": "SHADER_BLINK", "path": "res://addons/vfx_library/shaders/blink.gdshader"},
        {"name": "SHADER_WATER_SURFACE", "path": "res://addons/vfx_library/shaders/water_surface.gdshader"},
        {"name": "SHADER_FLASH_WHITE", "path": "res://addons/vfx_library/shaders/flash_white.gdshader"},
        {"name": "SHADER_COLOR_CHANGE", "path": "res://addons/vfx_library/shaders/color_change.gdshader"},
        {"name": "SHADER_FOG", "path": "res://addons/vfx_library/shaders/fog.gdshader"},
        {"name": "SHADER_HEAT_DISTORTION", "path": "res://addons/vfx_library/shaders/heat_distortion.gdshader"},
        {"name": "SHADER_RADIAL_BLUR", "path": "res://addons/vfx_library/shaders/radial_blur.gdshader"},
        {"name": "SHADER_GRAYSCALE", "path": "res://addons/vfx_library/shaders/grayscale.gdshader"},
        {"name": "SHADER_CHROMATIC", "path": "res://addons/vfx_library/shaders/chromatic_aberration.gdshader"},
        {"name": "SHADER_VIGNETTE", "path": "res://addons/vfx_library/shaders/vignette.gdshader"},
        {"name": "SHADER_OUTLINE_GLOW", "path": "res://addons/vfx_library/shaders/outline_glow.gdshader"},
    ]

    for shader_data in shaders_data:
        shader_list.add_item(tr(shader_data["name"]))

    print("✓ " + tr("SHADER_LIST_LOADED") % shaders_data.size())


func _on_shader_selected(index: int):
    """当shader被选中"""
    current_shader_index = index
    print(tr("SHADER_SELECTED") % tr(shaders_data[index]["name"]))


func _on_apply_shader_pressed():
    """应用选中的shader到测试精灵"""
    if current_shader_index < 0 or current_shader_index >= shaders_data.size():
        print(tr("SELECT_SHADER"))
        return
    
    # 重置动画时间
    shader_animation_time = 0.0
    
    var shader_data = shaders_data[current_shader_index]
    var shader_path = shader_data["path"]
    
    # 加载shader
    var shader = load(shader_path)
    if not shader:
        push_error(tr("SHADER_LOAD_FAILED") % shader_path)
        return
    
    # 创建ShaderMaterial并应用
    var shader_mat = ShaderMaterial.new()
    shader_mat.shader = shader
    
    # 根据不同shader设置参数
    var shader_name = shader_data["name"]
    if shader_name == "SHADER_BURNING":
        shader_mat.set_shader_parameter("burn_amount", 0.5)
    elif shader_name == "SHADER_FROZEN":
        shader_mat.set_shader_parameter("freeze_amount", 0.7)
    elif shader_name == "SHADER_POISON":
        shader_mat.set_shader_parameter("poison_amount", 0.6)
    elif shader_name == "SHADER_PETRIFY":
        shader_mat.set_shader_parameter("petrify_amount", 0.8)
    elif shader_name == "SHADER_INVISIBILITY":
        shader_mat.set_shader_parameter("invisibility_amount", 0.6)
        shader_mat.set_shader_parameter("distortion_amount", 0.02)
    elif shader_name == "SHADER_DISSOLVE":
        shader_mat.set_shader_parameter("dissolve_amount", 0.5)
        # 创建简单的噪声纹理
        var noise_image = Image.create(256, 256, false, Image.FORMAT_L8)
        for x in range(256):
            for y in range(256):
                var noise_val = randf()
                noise_image.set_pixel(x, y, Color(noise_val, noise_val, noise_val))
        var noise_texture = ImageTexture.create_from_image(noise_image)
        shader_mat.set_shader_parameter("dissolve_texture", noise_texture)
    elif shader_name == "SHADER_BLINK":
        shader_mat.set_shader_parameter("blink_speed", 10.0)
        shader_mat.set_shader_parameter("min_alpha", 0.3)
    elif shader_name == "SHADER_WATER_SURFACE":
        shader_mat.set_shader_parameter("wave_speed", 2.0)
        shader_mat.set_shader_parameter("wave_strength", 0.02)
    elif shader_name == "SHADER_FLASH_WHITE":
        shader_mat.set_shader_parameter("flash_amount", 0.8)
    elif shader_name == "SHADER_COLOR_CHANGE":
        shader_mat.set_shader_parameter("target_color", Color(1.0, 0.3, 0.3))
        shader_mat.set_shader_parameter("mix_amount", 0.7)
    elif shader_name == "SHADER_FOG":
        shader_mat.set_shader_parameter("fog_density", 0.5)
    elif shader_name == "SHADER_HEAT_DISTORTION":
        # 增大扭曲强度，并生成噪声纹理
        shader_mat.set_shader_parameter("distortion_amount", 0.05)
        shader_mat.set_shader_parameter("distortion_speed", 3.0)
        # 生成噪声纹理
        var noise_image = Image.create(128, 128, false, Image.FORMAT_RGB8)
        for x in range(128):
            for y in range(128):
                var noise_r = randf()
                var noise_g = randf()
                noise_image.set_pixel(x, y, Color(noise_r, noise_g, 0.5))
        var noise_texture = ImageTexture.create_from_image(noise_image)
        shader_mat.set_shader_parameter("noise_texture", noise_texture)
    elif shader_name == "SHADER_RADIAL_BLUR":
        # 增大模糊强度
        shader_mat.set_shader_parameter("blur_strength", 0.08)
        shader_mat.set_shader_parameter("blur_center", Vector2(0.5, 0.5))
        shader_mat.set_shader_parameter("samples", 20)
    elif shader_name == "SHADER_GRAYSCALE":
        shader_mat.set_shader_parameter("grayscale_amount", 0.8)
    elif shader_name == "SHADER_CHROMATIC":
        # 增大色差偏移量
        shader_mat.set_shader_parameter("aberration_amount", 0.015)
        shader_mat.set_shader_parameter("aberration_direction", Vector2(1.0, 0.0))
    elif shader_name == "SHADER_VIGNETTE":
        shader_mat.set_shader_parameter("vignette_intensity", 0.5)
    elif shader_name == "SHADER_OUTLINE_GLOW":
        shader_mat.set_shader_parameter("outline_color", Color(0.3, 0.8, 1.0))
        shader_mat.set_shader_parameter("outline_width", 2.0)
    
    shader_test_sprite.material = shader_mat

    print("✓ " + tr("SHADER_APPLIED") % tr(shader_data["name"]))


func _on_remove_shader_pressed():
    """移除测试精灵的shader"""
    shader_test_sprite.material = null
    print("✓ " + tr("SHADER_REMOVED"))


func _input(event: InputEvent):
    """处理输入事件"""
    # 鼠标右键在鼠标位置生成特效
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
            # 将屏幕坐标转换为全局坐标
            var global_pos = get_global_mouse_position()
            spawn_current_effect(global_pos)
    
    # ESC 退出
    elif event.is_action_pressed("ui_cancel"):
        get_tree().quit()


func _process(delta: float):
    """更新shader动画"""
    if shader_test_sprite.material == null:
        return
    
    shader_animation_time += delta
    
    # 根据当前shader类型更新参数
    if current_shader_index < 0 or current_shader_index >= shaders_data.size():
        return
    
    var shader_name = shaders_data[current_shader_index]["name"]
    var shader_mat = shader_test_sprite.material as ShaderMaterial
    if not shader_mat:
        return
    
    # 为不同shader添加动画
    if shader_name == "SHADER_BURNING":
        var burn = (sin(shader_animation_time * 0.5) + 1.0) * 0.5
        shader_mat.set_shader_parameter("burn_amount", burn)

    elif shader_name == "SHADER_FROZEN":
        var freeze = (sin(shader_animation_time * 0.8) + 1.0) * 0.5
        shader_mat.set_shader_parameter("freeze_amount", freeze)

    elif shader_name == "SHADER_POISON":
        var poison = 0.4 + sin(shader_animation_time * 3.0) * 0.3
        shader_mat.set_shader_parameter("poison_amount", poison)

    elif shader_name == "SHADER_PETRIFY":
        var petrify = (sin(shader_animation_time * 0.6) + 1.0) * 0.5
        shader_mat.set_shader_parameter("petrify_amount", petrify)

    elif shader_name == "SHADER_INVISIBILITY":
        var invis = (sin(shader_animation_time * 1.0) + 1.0) * 0.5
        shader_mat.set_shader_parameter("invisibility_amount", invis)

    elif shader_name == "SHADER_DISSOLVE":
        var dissolve = (sin(shader_animation_time * 0.7) + 1.0) * 0.5
        shader_mat.set_shader_parameter("dissolve_amount", dissolve)

    elif shader_name == "SHADER_FLASH_WHITE":
        var flash = max(0.0, sin(shader_animation_time * 5.0))
        shader_mat.set_shader_parameter("flash_amount", flash)

    elif shader_name == "SHADER_COLOR_CHANGE":
        var hue = shader_animation_time * 0.3
        var color = Color.from_hsv(fmod(hue, 1.0), 0.8, 1.0)
        shader_mat.set_shader_parameter("target_color", color)

    elif shader_name == "SHADER_FOG":
        var fog = 0.3 + sin(shader_animation_time * 1.5) * 0.2
        shader_mat.set_shader_parameter("fog_density", fog)

    elif shader_name == "SHADER_HEAT_DISTORTION":
        var distortion = 0.03 + sin(shader_animation_time * 2.0) * 0.03
        shader_mat.set_shader_parameter("distortion_amount", distortion)

    elif shader_name == "SHADER_RADIAL_BLUR":
        var blur = 0.04 + abs(sin(shader_animation_time * 1.5)) * 0.06
        shader_mat.set_shader_parameter("blur_strength", blur)

    elif shader_name == "SHADER_GRAYSCALE":
        var grayscale = (sin(shader_animation_time * 1.0) + 1.0) * 0.5
        shader_mat.set_shader_parameter("grayscale_amount", grayscale)

    elif shader_name == "SHADER_CHROMATIC":
        var aberration = 0.008 + abs(sin(shader_animation_time * 2.0)) * 0.015
        var angle = shader_animation_time * 0.5
        var direction = Vector2(cos(angle), sin(angle))
        shader_mat.set_shader_parameter("aberration_amount", aberration)
        shader_mat.set_shader_parameter("aberration_direction", direction)

    elif shader_name == "SHADER_VIGNETTE":
        var vignette = 0.3 + sin(shader_animation_time * 1.5) * 0.3
        shader_mat.set_shader_parameter("vignette_intensity", vignette)

    elif shader_name == "SHADER_OUTLINE_GLOW":
        var hue = shader_animation_time * 0.5
        var outline_color = Color.from_hsv(fmod(hue, 1.0), 0.8, 1.0)
        shader_mat.set_shader_parameter("outline_color", outline_color)


# 脚本结束
