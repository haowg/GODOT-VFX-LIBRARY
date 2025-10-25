# API Reference

Complete reference for the Godot VFX Library's public API. All functions are accessible through the global autoloads `VFX` and `EnvVFX`.

## Table of Contents

- [VFX Manager](#vfx-manager) - Combat, UI, and screen effects
- [EnvVFX Manager](#envvfx-manager) - Environmental and atmospheric effects
- [Common Patterns](#common-patterns) - Usage examples and best practices
- [Return Types](#return-types) - Understanding effect node types

---

## VFX Manager

The `VFX` autoload handles combat effects, screen feedback, and UI interactions.

### Screen Effects

#### `screen_shake(intensity: float = 10.0, duration: float = 0.2)`

Creates camera shake effect for impact feedback.

**Parameters:**
- `intensity` (float): Shake strength in pixels (1.0 - 50.0)
- `duration` (float): Shake duration in seconds

**Example:**
```gdscript
# Light shake for button press
VFX.screen_shake(3.0, 0.1)

# Heavy shake for explosion
VFX.screen_shake(20.0, 0.5)
```

#### `freeze_frame(duration: float = 0.1, time_scale: float = 0.05)`

Freezes game time for dramatic impact effects.

**Parameters:**
- `duration` (float): Freeze duration in real-time seconds
- `time_scale` (float): Time multiplier during freeze (0.0 - 1.0)

**Example:**
```gdscript
# Quick impact freeze
VFX.freeze_frame(0.08, 0.1)

# Longer cinematic pause
VFX.freeze_frame(0.2, 0.01)
```

### Combat Effects

#### `spawn_blood_splash(pos: Vector2)`

Creates blood splash effect at specified position.

**Parameters:**
- `pos` (Vector2): World position for the effect

**Duration:** ~1.0 seconds, auto-cleanup

#### `spawn_energy_burst(pos: Vector2, color: Color = Color(0.5, 0.8, 1.0))`

Spawns energy explosion with customizable color.

**Parameters:**
- `pos` (Vector2): World position for the effect
- `color` (Color): Primary energy color (optional)

**Duration:** ~1.0 seconds, auto-cleanup

#### `spawn_heal_effect(pos: Vector2)`

Creates upward-floating healing particles.

**Parameters:**
- `pos` (Vector2): World position for the effect

**Duration:** ~2.0 seconds, auto-cleanup

#### `spawn_shield_break(pos: Vector2)`

Spawns shield destruction fragments.

**Parameters:**
- `pos` (Vector2): World position for the effect

**Duration:** ~0.8 seconds, auto-cleanup

#### `spawn_combo_ring(pos: Vector2)`

Creates expanding combo hit indicator.

**Parameters:**
- `pos` (Vector2): World position for the effect

**Duration:** ~0.6 seconds, auto-cleanup

### Movement Effects

#### `create_dash_trail(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates persistent dash trail that follows the parent.

**Parameters:**
- `parent` (Node): Node to attach the trail to
- `offset` (Vector2): Local offset from parent position

**Returns:** CPUParticles2D - Trail effect node for manual control

**Usage:**
```gdscript
# Start dash
var trail = VFX.create_dash_trail(player, Vector2(0, 5))

# Stop dash  
trail.emitting = false
```

#### `spawn_jump_dust(pos: Vector2)`

Creates dust cloud for jump/landing effects.

**Parameters:**
- `pos` (Vector2): World position for the dust

**Duration:** ~0.5 seconds, auto-cleanup

#### `create_wall_slide_spark(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates sparks that follow wall-sliding character.

**Parameters:**
- `parent` (Node): Node to attach sparks to
- `offset` (Vector2): Local offset from parent position

**Returns:** CPUParticles2D - Spark effect node for manual control

### Combo Effects

#### `critical_hit(pos: Vector2)`

Combination effect for critical hits (shake + freeze + particles).

**Parameters:**
- `pos` (Vector2): World position for the effect

**Includes:**
- Screen shake (15.0 intensity, 0.25s)
- Freeze frame (0.12s duration)
- Orange particle burst

#### `kill_effect(pos: Vector2)`

Combination effect for enemy defeats (shake + freeze + particles).

**Parameters:**
- `pos` (Vector2): World position for the effect

**Includes:**
- Screen shake (12.0 intensity, 0.2s)
- Freeze frame (0.08s duration)  
- Red particle burst

### Utility Functions

#### `spawn_particles(pos: Vector2, particle_color: Color, count: int = 15)`

Generic particle spawner with custom color and count.

**Parameters:**
- `pos` (Vector2): World position for particles
- `particle_color` (Color): Primary particle color
- `count` (int): Number of particles (5-50 recommended)

**Duration:** ~1.2 seconds, auto-cleanup

#### `flash_white(node: CanvasItem, duration: float = 0.1)`

Flashes a node white for damage feedback.

**Parameters:**
- `node` (CanvasItem): Node to flash (Sprite2D, etc.)
- `duration` (float): Flash duration in seconds

#### `spawn_damage_number(pos: Vector2, damage: int, is_critical: bool = false)`

Shows floating damage number with animation.

**Parameters:**
- `pos` (Vector2): World position for the number
- `damage` (int): Damage value to display
- `is_critical` (bool): Use critical hit styling

**Styling:**
- Normal: White text, 24pt font
- Critical: Golden text, 32pt font

---

## EnvVFX Manager

The `EnvVFX` autoload handles environmental effects, atmospheric particles, and spell effects.

### Fire & Light Sources

#### `create_torch(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates persistent torch flame effect.

**Parameters:**
- `parent` (Node2D): Node to attach torch to
- `offset` (Vector2): Local position offset

**Returns:** CPUParticles2D - Fire effect node

#### `create_candle_flame(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates small candle flame effect.

**Parameters:**
- `parent` (Node2D): Node to attach flame to  
- `offset` (Vector2): Local position offset

**Returns:** CPUParticles2D - Flame effect node

#### `create_campfire_smoke(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates rising campfire smoke.

**Parameters:**
- `parent` (Node2D): Node to attach smoke to
- `offset` (Vector2): Local position offset

**Returns:** CPUParticles2D - Smoke effect node

### Atmospheric Effects

#### `create_fireflies(parent: Node2D, area_size: Vector2 = Vector2(200, 100)) -> CPUParticles2D`

Creates ambient firefly swarm in specified area.

**Parameters:**
- `parent` (Node2D): Container node
- `area_size` (Vector2): Emission area dimensions

**Returns:** CPUParticles2D - Firefly effect node

#### `create_falling_leaves(parent: Node2D, width: float = 300.0) -> CPUParticles2D`

Creates falling autumn leaves across specified width.

**Parameters:**
- `parent` (Node2D): Container node
- `width` (float): Emission width in pixels

**Returns:** CPUParticles2D - Leaves effect node

#### `create_ash_particles(parent: Node2D, area_size: Vector2 = Vector2(60, 20)) -> CPUParticles2D`

Creates floating ash particles.

**Parameters:**
- `parent` (Node2D): Container node
- `area_size` (Vector2): Emission area dimensions

**Returns:** CPUParticles2D - Ash effect node

### Weather Effects

#### `create_rain(parent: Node2D, area_width: float = 600.0) -> CPUParticles2D`

Creates rain effect across specified width.

**Parameters:**
- `parent` (Node2D): Container node
- `area_width` (float): Rain area width in pixels

**Returns:** CPUParticles2D - Rain effect node

#### `create_snow(parent: Node2D, area_width: float = 600.0) -> CPUParticles2D`

Creates snow effect across specified width.

**Parameters:**
- `parent` (Node2D): Container node  
- `area_width` (float): Snow area width in pixels

**Returns:** CPUParticles2D - Snow effect node

### Water & Steam Effects

#### `create_water_splash(pos: Vector2, size: float = 1.0, parent: Node = null)`

Creates water splash with scalable intensity.

**Parameters:**
- `pos` (Vector2): World position for splash
- `size` (float): Splash size multiplier (0.5 - 3.0)
- `parent` (Node): Container node (optional, uses current scene if null)

**Duration:** ~1.0 seconds, auto-cleanup

#### `create_waterfall_mist(parent: Node2D, offset: Vector2 = Vector2.ZERO, width: float = 80.0) -> CPUParticles2D`

Creates waterfall mist effect.

**Parameters:**
- `parent` (Node2D): Container node
- `offset` (Vector2): Local position offset
- `width` (float): Mist width in pixels

**Returns:** CPUParticles2D - Mist effect node

#### `create_steam(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates rising steam effect.

**Parameters:**
- `parent` (Node2D): Container node
- `offset` (Vector2): Local position offset

**Returns:** CPUParticles2D - Steam effect node

### Mechanical Effects

#### `create_sparks(parent: Node2D, offset: Vector2 = Vector2.ZERO, continuous: bool = false) -> CPUParticles2D`

Creates electrical sparks for machinery/traps.

**Parameters:**
- `parent` (Node2D): Container node
- `offset` (Vector2): Local position offset
- `continuous` (bool): True for ongoing sparks, false for one-shot

**Returns:** CPUParticles2D - Sparks effect node

#### `create_dust_cloud(pos: Vector2, size: float = 1.0, parent: Node = null)`

Creates dust cloud for impacts/collapses.

**Parameters:**
- `pos` (Vector2): World position for dust
- `size` (float): Dust size multiplier (0.5 - 3.0)
- `parent` (Node): Container node (optional)

**Duration:** ~2.0 seconds, auto-cleanup

#### `create_wood_debris(pos: Vector2, direction: Vector2 = Vector2.RIGHT, parent: Node = null)`

Creates wood fragments for destruction effects.

**Parameters:**
- `pos` (Vector2): World position for debris
- `direction` (Vector2): Primary debris direction
- `parent` (Node): Container node (optional)

**Duration:** ~2.0 seconds, auto-cleanup

### Magic & Spell Effects

#### `create_magic_aura(parent: Node2D, color: Color = Color(0.5, 0.3, 1.0), radius: float = 60.0) -> GPUParticles2D`

Creates magical aura ring around object.

**Parameters:**
- `parent` (Node2D): Container node
- `color` (Color): Primary aura color (optional)
- `radius` (float): Aura ring radius in pixels

**Returns:** GPUParticles2D - Aura effect node

#### `create_portal(parent: Node2D, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates swirling portal vortex effect.

**Parameters:**
- `parent` (Node2D): Container node
- `offset` (Vector2): Local position offset

**Returns:** CPUParticles2D - Portal effect node

#### `spawn_lightning_chain(pos: Vector2)`

Creates multi-segment lightning chain effect.

**Parameters:**
- `pos` (Vector2): World position for lightning origin

**Duration:** ~0.4 seconds, auto-cleanup

#### `spawn_ice_frost(pos: Vector2)`

Creates ice crystal formation effect.

**Parameters:**
- `pos` (Vector2): World position for ice effect

**Duration:** ~1.0 seconds, auto-cleanup

#### `create_fireball_trail(parent: Node, offset: Vector2 = Vector2.ZERO) -> CPUParticles2D`

Creates fire trail that follows projectile.

**Parameters:**
- `parent` (Node): Projectile node to attach to
- `offset` (Vector2): Local position offset

**Returns:** CPUParticles2D - Trail effect node

#### `create_summon_circle(parent: Node2D, offset: Vector2 = Vector2.ZERO, radius: float = 50.0) -> CPUParticles2D`

Creates magical summoning circle.

**Parameters:**
- `parent` (Node2D): Container node
- `offset` (Vector2): Local position offset  
- `radius` (float): Circle radius in pixels

**Returns:** CPUParticles2D - Circle effect node

### Poison & Hazard Effects

#### `create_poison_cloud(pos: Vector2, size: float = 1.0, parent: Node = null) -> CPUParticles2D`

Creates toxic gas cloud.

**Parameters:**
- `pos` (Vector2): World position for cloud
- `size` (float): Cloud size multiplier (0.5 - 3.0)
- `parent` (Node): Container node (optional)

**Returns:** CPUParticles2D - Poison cloud node (persistent)

---

## Common Patterns

### Managing Effect Lifetime

**Automatic Cleanup (One-shot effects):**
```gdscript
# These clean themselves up automatically
VFX.spawn_blood_splash(enemy_pos)
VFX.spawn_energy_burst(spell_pos, Color.BLUE)
EnvVFX.create_water_splash(impact_pos, 2.0)
```

**Manual Control (Persistent effects):**
```gdscript
# Store reference for manual control
var torch = EnvVFX.create_torch(wall, Vector2(0, -20))

# Stop effect when needed
torch.emitting = false
torch.queue_free()
```

### Character Movement Integration

**Dash System:**
```gdscript
extends CharacterBody2D

var dash_trail: CPUParticles2D

func start_dash():
    dash_trail = VFX.create_dash_trail(self, Vector2(0, 5))
    
func stop_dash():
    if dash_trail:
        dash_trail.emitting = false
```

**Wall Slide System:**
```gdscript
extends CharacterBody2D

var wall_sparks: CPUParticles2D

func _physics_process(delta):
    if is_on_wall() and velocity.y > 0:
        if not wall_sparks:
            wall_sparks = VFX.create_wall_slide_spark(self, Vector2(8, 0))
    else:
        if wall_sparks:
            wall_sparks.emitting = false
            wall_sparks = null
```

### Combat Integration

**Damage System:**
```gdscript
func take_damage(amount: int, is_critical: bool = false):
    # Visual feedback
    VFX.flash_white(sprite, 0.1)
    VFX.spawn_blood_splash(global_position)
    
    # Screen feedback
    var shake_intensity = 8.0 + (amount * 0.2)
    VFX.screen_shake(shake_intensity, 0.15)
    
    # Damage number
    VFX.spawn_damage_number(global_position + Vector2(0, -30), amount, is_critical)
    
    # Critical hit combo
    if is_critical:
        VFX.critical_hit(global_position)
```

### Environmental Design

**Atmospheric Scene Setup:**
```gdscript
extends Node2D

func _ready():
    # Background ambience  
    EnvVFX.create_fireflies(self, Vector2(400, 200))
    EnvVFX.create_falling_leaves(self, 500.0)
    
    # Light sources
    EnvVFX.create_torch($TorchHolder, Vector2.ZERO)
    EnvVFX.create_campfire_smoke($Campfire, Vector2(0, -10))
    
    # Weather (conditional)
    if current_weather == "rain":
        EnvVFX.create_rain(self, 800.0)
```

### Performance Optimization

**Effect Limiting:**
```gdscript
# Limit simultaneous blood effects
const MAX_BLOOD_EFFECTS = 5
var active_blood_count = 0

func spawn_blood_safely(pos: Vector2):
    if active_blood_count < MAX_BLOOD_EFFECTS:
        VFX.spawn_blood_splash(pos)
        active_blood_count += 1
        
        # Decrement counter after effect lifetime
        await get_tree().create_timer(1.0).timeout
        active_blood_count -= 1
```

**Mobile Optimization:**
```gdscript
# Reduce particle counts for mobile
func _ready():
    if OS.get_name() in ["Android", "iOS"]:
        # Scale down particle effects
        for effect in get_tree().get_nodes_in_group("particles"):
            effect.amount = max(10, effect.amount / 2)
```

---

## Return Types

### CPUParticles2D
Most environmental effects return this type:
- **Properties:** `emitting`, `amount`, `lifetime`, `color`, etc.
- **Use case:** Continuous or controllable effects
- **Example:** Torch flames, dash trails, rain

### GPUParticles2D  
High-performance effects for complex systems:
- **Properties:** `emitting`, `amount`, `process_material`, etc.
- **Use case:** High particle count effects
- **Example:** Magic auras, energy fields

### void (Auto-cleanup)
One-shot effects that manage themselves:
- **Lifetime:** Predetermined duration
- **Use case:** Impact effects, explosions
- **Example:** Blood splash, energy burst, ice frost

### Node2D Containers
Complex multi-effect systems:
- **Contains:** Multiple particle emitters
- **Use case:** Elaborate spell effects
- **Example:** Lightning chain with multiple segments

---

## Best Practices

1. **Store references** for effects you need to control
2. **Use auto-cleanup effects** for simple impacts
3. **Limit simultaneous effects** for performance
4. **Scale particle counts** based on platform
5. **Test effects** in actual gameplay scenarios
6. **Customize colors** to match your game's palette
7. **Combine effects** for more impactful moments

For more examples, see the [demo scene](addons/vfx_library/demo/vfx_demo.tscn) and [demo guide](addons/vfx_library/demo/README.md).