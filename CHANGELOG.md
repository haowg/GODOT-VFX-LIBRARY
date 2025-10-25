# Changelog

All notable changes to the Godot VFX Library will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Preparing for initial open source release
- Complete documentation suite
- Interactive demo scene

## [1.0.0] - 2024-10-25

### Added

#### Particle Effects (35+)
- **Combat Effects**: 
  - `blood_splash.tscn` - Blood splash on impact
  - `combat_particle.tscn` - Generic combat particles
  - `energy_burst.tscn` - Energy explosion effect
  - `heal_particles.tscn` - Healing light particles
  - `shield_break.tscn` - Shield destruction effect
  - `combo_ring.tscn` - Combo hit indicator
  - `sparks.tscn` - Metallic sparks
  - `wood_debris.tscn` - Wood destruction particles

- **Movement Effects**:
  - `dash_trail.tscn` - Character dash afterimage
  - `jump_dust.tscn` - Landing dust clouds
  - `wall_slide_spark.tscn` - Wall sliding sparks

- **Spell/Skill Effects**:
  - `portal_vortex.tscn` - Teleportation portal
  - `lightning_chain.tscn` - Electric chain effect
  - `ice_frost.tscn` - Ice crystal formation
  - `fireball_trail.tscn` - Projectile fire trail
  - `summon_circle.tscn` - Magic summoning circle

- **Environmental Effects**:
  - `torch_fire.tscn` - Torch flame animation
  - `fireflies.tscn` - Ambient firefly swarm
  - `steam.tscn` - Steam vents
  - `water_splash.tscn` - Water impact splash
  - `dust_cloud.tscn` - Environmental dust
  - `magic_aura.tscn` - Magical aura glow
  - `poison_cloud.tscn` - Toxic gas cloud
  - `falling_leaves.tscn` - Autumn leaf fall
  - `rain_drops.tscn` - Weather rain effect
  - `snow_flakes.tscn` - Snow weather
  - `waterfall_mist.tscn` - Waterfall spray
  - `campfire_smoke.tscn` - Campfire smoke
  - `candle_flame.tscn` - Small candle flame
  - `ash_particles.tscn` - Floating ash

#### Shader Effects (17+)
- **Character Status Shaders**:
  - `flash_white.gdshader` - Damage hit flash
  - `blink.gdshader` - Invincibility blinking
  - `dissolve.gdshader` - Fade-out dissolution
  - `frozen.gdshader` - Ice freeze effect
  - `poison.gdshader` - Poison status overlay
  - `burning.gdshader` - Fire damage effect
  - `petrify.gdshader` - Stone transformation

- **Environmental Shaders**:
  - `water_surface.gdshader` - Water ripple animation
  - `heat_distortion.gdshader` - Heat wave distortion
  - `portal_vortex.gdshader` - Portal swirl effect
  - `energy_barrier.gdshader` - Force field barrier
  - `invisibility.gdshader` - Transparency effect

- **Post-Processing Shaders**:
  - `outline_glow.gdshader` - Glowing outline
  - `radial_blur.gdshader` - Radial motion blur
  - `vignette.gdshader` - Screen edge darkening
  - `grayscale.gdshader` - Monochrome filter
  - `chromatic_aberration.gdshader` - Color separation

#### Manager Systems
- **VFX Manager** (`vfx.gd`):
  - Screen shake system with customizable intensity and duration
  - Freeze frame mechanics for impact effects
  - Combat particle spawning functions
  - UI feedback effects (damage numbers, screen flash)
  - Movement effect creators (dash trails, jump dust)
  - Combo and critical hit effects

- **EnvVFX Manager** (`env_vfx.gd`):
  - Environmental particle system management
  - Fire and light source effects
  - Weather system integration
  - Water and steam effects
  - Ambient atmospheric particles
  - Spell and magic effect creators

#### Documentation
- Complete API reference documentation
- Installation and setup guides
- Interactive demo scene with examples
- Contribution guidelines and standards

#### Demo System
- Interactive test scene (`vfx_demo.tscn`)
- Keyboard shortcuts for testing all effects
- Real-time parameter adjustment
- Performance monitoring tools

### Technical Features
- Scene-based particle effects for visual editing
- Direct `Gradient` references for color ramps
- Additive blending for glow effects
- Automatic cleanup for one-shot effects
- Memory-efficient particle management
- Godot 4.5+ compatibility

### Fixed
- Color ramp display issues with proper white base colors
- Memory leaks in particle cleanup systems
- Performance optimization for multiple simultaneous effects
- Shader parameter validation and type safety

### Performance
- Optimized particle counts for 60 FPS on mid-range hardware
- Efficient texture usage with shared resources
- Smart culling for off-screen effects
- Minimal overhead manager systems

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the first public release of the Godot VFX Library. The library has been in development and testing for several months, providing a comprehensive solution for visual effects in Godot 4.

**Key Features:**
- 35+ ready-to-use particle effects
- 17+ customizable shaders
- Two powerful manager systems
- Complete documentation
- Interactive demo scene
- MIT license for commercial use

**Compatibility:**
- Godot Engine 4.5+
- Tested on Windows, macOS, and Linux
- Compatible with Forward+ and Mobile renderers

**Getting Started:**
1. Install via Asset Library or manual download
2. Enable the plugin in Project Settings
3. Run the demo scene to test all effects
4. Check the documentation for API usage

**Community:**
- Report issues on GitHub
- Join discussions for feature requests
- Contribute new effects and improvements
- Share your creations with the community

---

## Development Notes

### Version Numbering
- **Major** (X.0.0): Breaking API changes, major feature additions
- **Minor** (1.X.0): New effects, new features, backward compatible
- **Patch** (1.0.X): Bug fixes, performance improvements, documentation

### Release Schedule
- Major releases: ~6-12 months
- Minor releases: ~2-3 months  
- Patch releases: As needed for critical fixes

### Deprecation Policy
- Deprecated features will be marked and documented
- Minimum 2 minor versions before removal
- Migration guides provided for breaking changes