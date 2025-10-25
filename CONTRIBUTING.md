# Contributing to Godot VFX Library

Thank you for your interest in contributing to the Godot VFX Library! We welcome contributions from the community to help make this library even better.

## 🚀 Getting Started

### Prerequisites

- Godot Engine 4.5 or later
- Basic knowledge of GDScript and Godot's particle systems
- Understanding of shaders (for shader contributions)

### Setting Up Development Environment

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/yourusername/godot-vfx-library.git
   cd godot-vfx-library
   ```
3. Open the project in Godot Engine
4. Test the demo scene to ensure everything works

## 📋 How to Contribute

### 🐛 Reporting Bugs

Before reporting a bug, please:
1. Check existing issues to avoid duplicates
2. Test with the latest version
3. Include the following information:
   - Godot version
   - Operating system
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots/videos if applicable

Use our [Bug Report Template](.github/ISSUE_TEMPLATE/bug_report.md) when creating issues.

### 💡 Suggesting Features

We welcome feature requests! Please:
1. Check if the feature already exists or is planned
2. Describe the use case and benefit
3. Consider implementation complexity
4. Provide examples or mockups if possible

Use our [Feature Request Template](.github/ISSUE_TEMPLATE/feature_request.md).

### 🎨 Contributing Effects

#### Particle Effects

1. Create your effect as a `.tscn` scene in `addons/vfx_library/effects/`
2. Follow naming convention: `effect_name.tscn` (lowercase, underscores)
3. Ensure proper node structure:
   ```
   EffectName (GPUParticles2D)
   ├── ProcessMaterial (ParticleProcessMaterial)
   └── Texture (use provided textures when possible)
   ```
4. Test performance impact
5. Add usage example to demo scene

#### Shader Effects

1. Create shader files in `addons/vfx_library/shaders/`
2. Follow naming convention: `effect_name.gdshader`
3. Include proper documentation comments:
   ```glsl
   // Shader: Effect Name
   // Description: What this shader does
   // Author: Your Name
   // Parameters: List key uniforms
   ```
4. Test with different textures and parameters
5. Update shader usage guide

#### Manager Functions

When adding new manager functions:

1. **For VFX Manager** (`vfx.gd`):
   - Combat-related effects
   - Screen effects (shake, freeze)
   - UI feedback (damage numbers, flash)

2. **For EnvVFX Manager** (`env_vfx.gd`):
   - Environmental/atmospheric effects
   - Background elements
   - Non-combat particle systems

3. Function naming convention:
   ```gdscript
   # Creation functions (return node reference)
   func create_effect_name(parent: Node, offset: Vector2) -> Node2D
   
   # Spawning functions (one-shot effects)
   func spawn_effect_name(position: Vector2, optional_params...)
   ```

### 📖 Documentation

Help us improve documentation:

- Fix typos or unclear explanations
- Add usage examples
- Translate to other languages
- Improve API documentation
- Create video tutorials

### 🔧 Code Standards

#### GDScript Style

Follow [Godot's GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html):

```gdscript
# Use snake_case for variables and functions
var particle_count: int = 100
func spawn_blood_splash(pos: Vector2):

# Use PascalCase for classes and enums
class_name VFXManager
enum EffectType { FIRE, ICE, POISON }

# Add type hints
func create_effect(parent: Node2D, duration: float) -> GPUParticles2D:

# Document public functions
## Spawns a blood splash effect at the given position
## @param pos: World position to spawn the effect
## @param intensity: Effect intensity (0.0 to 1.0)
func spawn_blood_splash(pos: Vector2, intensity: float = 1.0):
```

#### Shader Style

```glsl
// Use descriptive uniform names
uniform float wave_speed : hint_range(0.0, 10.0) = 1.0;
uniform vec4 primary_color : source_color = vec4(1.0);

// Comment complex calculations
// Calculate UV distortion based on time and position
vec2 distorted_uv = uv + sin(TIME * wave_speed + uv.x * 10.0) * 0.01;
```

#### Scene Structure

```
EffectName
├── GPUParticles2D (main node)
│   ├── amount: reasonable default (50-200)
│   ├── lifetime: appropriate duration
│   ├── process_material: ParticleProcessMaterial
│   └── texture: optimized texture
└── (optional child nodes for complex effects)
```

## 🔄 Pull Request Process

### Before Submitting

1. Test your changes thoroughly
2. Update documentation if needed
3. Add your effect to the demo scene
4. Ensure backward compatibility
5. Check performance impact

### Pull Request Guidelines

1. **Title**: Clear, descriptive title
   - ✅ "Add ice shard particle effect"
   - ❌ "New effect"

2. **Description**: Include:
   - What changes were made
   - Why they were made
   - Testing performed
   - Screenshots/videos for visual changes

3. **Commits**: 
   - Use meaningful commit messages
   - Keep commits focused and atomic
   - Squash related commits before submitting

### Review Process

1. Automated checks will run
2. Maintainers will review the code
3. Address any feedback promptly
4. Once approved, your PR will be merged

## 🎯 Project Goals

Keep these goals in mind when contributing:

- **Performance**: Effects should run smoothly on mid-range hardware
- **Usability**: Simple, intuitive API for common use cases
- **Flexibility**: Customizable parameters for different needs
- **Quality**: Professional-looking effects suitable for commercial games
- **Compatibility**: Works across different Godot 4.x versions

## 📦 Release Process

### Versioning

We use [Semantic Versioning](https://semver.org/):

- `MAJOR.MINOR.PATCH` (e.g., 1.2.3)
- **MAJOR**: Breaking changes
- **MINOR**: New features, backward compatible
- **PATCH**: Bug fixes, small improvements

### Release Types

- **Stable releases**: Thoroughly tested, production-ready
- **Beta releases**: Feature-complete, needs testing
- **Alpha releases**: Early development, experimental features

## 🏆 Recognition

Contributors will be:

- Listed in `CONTRIBUTORS.md`
- Mentioned in release notes
- Credited in effect file headers (for major contributions)

## ❓ Questions?

- **Discord**: Join our community server (link in README)
- **GitHub Discussions**: For broader topics
- **Issues**: For specific bugs or features
- **Email**: maintainer@example.com

## 📜 Code of Conduct

This project follows the [Contributor Covenant](https://www.contributor-covenant.org/version/2/1/code_of_conduct/). Please be respectful and inclusive.

---

Thank you for contributing to the Godot VFX Library! Your efforts help make game development more accessible and enjoyable for everyone. 🎮✨