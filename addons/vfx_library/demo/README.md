# Demo Scene Guide

The VFX Library includes an interactive demo scene that showcases all available effects and provides a testing environment for developers.

## 🎮 Running the Demo

### Quick Start
1. Open `addons/vfx_library/demo/vfx_demo.tscn` in Godot
2. Press **F6** (Play Scene) or click the scene play button
3. Use the keyboard shortcuts below to test effects

### Alternative Access
- Set as main scene: Project Settings → Run → Main Scene → `res://addons/vfx_library/demo/vfx_demo.tscn`
- Run from project.godot if already configured

## ⌨️ Keyboard Controls

### Environmental Effects
- **Q** - Torch fire effect
- **W** - Fireflies swarm
- **E** - Falling leaves
- **R** - Steam/smoke effect
- **T** - Electric sparks

### Weather & Atmosphere
- **F** - Rain drops
- **G** - Snow flakes  
- **H** - Ash particles
- **J** - Waterfall mist
- **K** - Campfire smoke
- **L** - Candle flame

### Elemental Combat Effects
- **Z** - Fire particles (orange/red)
- **X** - Ice particles (blue/white)
- **C** - Poison particles (green)
- **V** - Lightning particles (yellow/blue)
- **B** - Shadow particles (dark purple)

### Combat & Movement
- **1** - Blood splash
- **2** - Energy burst
- **3** - Heal particles
- **4** - Shield break
- **5** - Combo ring
- **6** - Jump dust
- **7** - Magic aura
- **8** - Portal vortex
- **9** - Summon circle

### Screen Effects
- **SPACE** - Screen shake
- **ENTER** - Freeze frame
- **SHIFT** - Critical hit combo
- **CTRL** - Kill effect combo

### Utility
- **ESC** - Exit demo
- **TAB** - Toggle UI info panel

## 🧪 Testing Features

### Effect Spawning
- All effects spawn at mouse cursor position
- Mouse movement updates spawn location in real-time
- Effects automatically clean up after their duration

### Visual Feedback
- Real-time FPS counter
- Active effect counter
- Memory usage indicator
- Effect description tooltips

### Performance Testing
- Stress test mode (hold multiple keys)
- Frame rate monitoring
- Particle count limiting
- Memory leak detection

## 📊 Demo Scene Structure

```
vfx_demo.tscn
├── UI/                     # User interface
│   ├── FPSLabel           # Performance counter
│   ├── InstructionsPanel  # Controls guide
│   └── EffectInfo         # Current effect display
├── Camera2D               # Scene camera
├── Background             # Visual backdrop
└── EffectContainer        # Spawn area for effects
```

### Scene Components

**VFXDemo (Main Script)**
- Handles all keyboard input
- Manages effect spawning
- Tracks performance metrics
- Provides UI updates

**UI Elements**
- **FPS Counter**: Real-time performance monitoring
- **Instructions Panel**: Keyboard shortcut reference
- **Effect Info**: Details about the last spawned effect

**Effect Container**
- Isolated area for effect spawning
- Automatic cleanup of expired effects
- Z-index management for layering

## 🎯 Use Cases

### For Developers

**Integration Testing**
```gdscript
# Test VFX integration in your game
func test_combat_effects():
    VFX.spawn_blood_splash(enemy.global_position)
    VFX.screen_shake(10.0, 0.2)
    VFX.freeze_frame(0.1)
```

**Performance Validation**
- Test effect combinations that might occur in gameplay
- Validate frame rate with multiple simultaneous effects
- Check memory usage patterns

**Visual Design**
- Preview effects with your game's art style
- Test color combinations and intensities
- Evaluate effect timing and duration

### For Artists

**Effect Customization**
1. Use demo to identify effects to modify
2. Open corresponding `.tscn` files in `addons/vfx_library/effects/`
3. Adjust particle properties visually
4. Test changes using the demo scene

**Color Palette Integration**
- Test how effects look with your game's colors
- Modify effect colors in the scene files
- Use the demo to compare original vs. customized effects

### For Game Designers

**Gameplay Integration**
- Experience effects in context
- Evaluate impact timing and screen shake
- Test effect combinations for different game scenarios

**Balancing Feedback**
- Assess if effects are too subtle or overwhelming
- Test readability during intense action sequences
- Validate effect duration for game pacing

## 🔧 Customizing the Demo

### Adding New Effects

To add your custom effects to the demo:

1. **Add Effect Reference**
```gdscript
# In vfx_demo.gd
const CUSTOM_EFFECT_SCENE = preload("res://path/to/your_effect.tscn")
```

2. **Add Keyboard Binding**
```gdscript
# In _input() function
if event.is_action_pressed("your_key"):
    spawn_custom_effect()
```

3. **Create Spawn Function**
```gdscript
func spawn_custom_effect():
    var effect = CUSTOM_EFFECT_SCENE.instantiate()
    effect_container.add_child(effect)
    effect.global_position = get_global_mouse_position()
    effect.emitting = true
```

### Modifying UI

**FPS Counter Position**
```gdscript
# Move FPS counter
$UI/FPSLabel.position = Vector2(new_x, new_y)
```

**Adding Effect Descriptions**
```gdscript
# In effect spawn functions
update_effect_info("Effect Name", "Description of what this effect does")
```

### Performance Monitoring

**Custom Metrics**
```gdscript
# Add in _process()
func _process(delta):
    # Update custom counters
    particle_count = count_active_particles()
    memory_usage = OS.get_static_memory_usage_by_type()
```

## 📝 Demo Script Reference

### Key Functions

**`spawn_effect_at_mouse(effect_scene: PackedScene)`**
- Spawns any effect at current mouse position
- Handles automatic cleanup
- Updates performance counters

**`update_effect_info(name: String, description: String)`**
- Updates UI with effect information
- Shows effect duration and properties

**`cleanup_expired_effects()`**
- Removes finished particle systems
- Prevents memory accumulation
- Called automatically

### Input Handling

```gdscript
func _input(event):
    if event is InputEventKey and event.pressed:
        match event.keycode:
            KEY_Q: spawn_torch()
            KEY_W: spawn_fireflies()
            # ... etc
```

### Performance Monitoring

```gdscript
func _process(delta):
    fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
    effect_count_label.text = "Effects: " + str(count_active_effects())
```

## 🎨 Visual Customization

### Background
- Modify `Background` node for different test environments
- Add platforms or terrain for context
- Change lighting to test effect visibility

### Camera
- Adjust zoom level for different scales
- Add camera movement for dynamic testing
- Test effects with camera shake enabled

### UI Theme
- Customize colors to match your game
- Adjust font sizes for different resolutions
- Add your game's logo or branding

## 🚀 Performance Tips

### Optimization Testing
1. **Stress Test**: Hold multiple effect keys simultaneously
2. **Mobile Test**: Reduce particle counts and test on mobile
3. **Memory Test**: Run effects for extended periods

### Frame Rate Targets
- **Desktop**: 60 FPS with 5-10 simultaneous effects
- **Mobile**: 30-60 FPS with 3-5 simultaneous effects  
- **Web**: 30-45 FPS with 2-3 simultaneous effects

### Optimization Guidelines
- Limit particle counts (50-200 per effect)
- Use auto-cleanup for one-shot effects
- Pool frequently used effects
- Monitor memory usage patterns

---

The demo scene is your playground for exploring the VFX Library's capabilities. Use it to understand each effect, test performance, and integrate effects into your game with confidence! 🎮✨