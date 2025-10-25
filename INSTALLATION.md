# Installation Guide

This guide will walk you through installing and setting up the Godot VFX Library in your project.

## 📋 Requirements

- **Godot Engine**: 4.5 or later
- **Renderer**: Forward+ or Mobile (Compatibility renderer has limited support)
- **Platform**: Windows, macOS, Linux, iOS, Android
- **Project Type**: 2D or 3D projects

## 🚀 Installation Methods

### Method 1: Asset Library (Recommended)

1. **Open Godot Engine**
   - Launch Godot 4.5+
   - Open your existing project or create a new one

2. **Access Asset Library**
   - Click the **AssetLib** tab (next to FileSystem)
   - Search for "VFX Library" or "Godot VFX Library"

3. **Install Plugin**
   - Click on the VFX Library result
   - Click **Download**
   - Click **Install** when download completes
   - Choose installation folder (default: `addons/vfx_library`)

4. **Enable Plugin**
   - Go to **Project** → **Project Settings**
   - Click **Plugins** tab
   - Find "VFX Library" and check **Enable**

### Method 2: Manual Download

1. **Download Release**
   - Visit [GitHub Releases](https://github.com/yourusername/godot-vfx-library/releases)
   - Download the latest `vfx-library-vX.X.X.zip`
   - Extract the archive

2. **Copy to Project**
   ```
   your-project/
   └── addons/
       └── vfx_library/    ← Copy extracted folder here
   ```

3. **Enable Plugin**
   - Open your project in Godot
   - Go to **Project** → **Project Settings** → **Plugins**
   - Find "VFX Library" and check **Enable**

### Method 3: Git Clone

1. **Clone Repository**
   ```bash
   cd your-project/addons/
   git clone https://github.com/yourusername/godot-vfx-library.git vfx_library
   ```

2. **Enable Plugin**
   - Open project in Godot
   - Enable plugin in Project Settings

### Method 4: Git Submodule

1. **Add Submodule**
   ```bash
   cd your-project
   git submodule add https://github.com/yourusername/godot-vfx-library.git addons/vfx_library
   git submodule update --init --recursive
   ```

2. **Update Submodule** (for future updates)
   ```bash
   git submodule update --remote addons/vfx_library
   ```

3. **Enable Plugin**
   - Open project in Godot
   - Enable plugin in Project Settings

## ⚙️ Configuration

### Automatic Setup

When you enable the plugin, the following happens automatically:

1. **Autoloads Added**:
   - `VFX` → `res://addons/vfx_library/vfx.gd`
   - `EnvVFX` → `res://addons/vfx_library/env_vfx.gd`

2. **Plugin Activated**:
   - Manager systems initialized
   - Demo scene becomes available

### Manual Setup (if needed)

If autoloads aren't added automatically:

1. **Go to Project Settings** → **AutoLoad**
2. **Add VFX Manager**:
   - **Path**: `res://addons/vfx_library/vfx.gd`
   - **Node Name**: `VFX`
   - **Enable**: ✓

3. **Add EnvVFX Manager**:
   - **Path**: `res://addons/vfx_library/env_vfx.gd`
   - **Node Name**: `EnvVFX`
   - **Enable**: ✓

## ✅ Verification

### Test Installation

1. **Run Demo Scene**
   ```
   addons/vfx_library/demo/vfx_demo.tscn
   ```
   - Press **F6** (Play Scene) or click scene play button
   - Use keyboard shortcuts to test effects (see demo for keys)

2. **Test in Code**
   ```gdscript
   # Add to any script
   func _ready():
       # Test VFX manager
       VFX.screen_shake(5.0, 0.2)
       
       # Test EnvVFX manager  
       EnvVFX.create_torch(self, Vector2.ZERO)
   ```

3. **Check File Structure**
   ```
   addons/vfx_library/
   ├── plugin.cfg          ← Plugin configuration
   ├── plugin.gd           ← Plugin script
   ├── vfx.gd             ← VFX manager
   ├── env_vfx.gd         ← Environment VFX manager
   ├── effects/           ← Particle effect scenes
   ├── shaders/           ← Shader files
   ├── demo/              ← Demo and examples
   └── docs/              ← Documentation
   ```

## 🔧 Troubleshooting

### Plugin Not Showing in Asset Library

- **Solution**: Check Godot version (needs 4.5+)
- **Alternative**: Use manual installation method

### "VFX" or "EnvVFX" Not Found Error

**Symptoms**: 
```
Invalid get index 'VFX' (on base: 'Nil')
```

**Solutions**:
1. **Check Autoloads**:
   - Project Settings → AutoLoad
   - Ensure `VFX` and `EnvVFX` are listed and enabled

2. **Manual Add**:
   - Add autoloads manually (see Configuration section)

3. **Plugin Enabled**:
   - Project Settings → Plugins
   - Ensure "VFX Library" is checked

### Effects Not Visible

**Symptoms**: Functions run but no visual effects appear

**Solutions**:
1. **Check Renderer**:
   - Project Settings → Rendering → Renderer
   - Use Forward+ or Mobile (not Compatibility)

2. **Camera/Viewport**:
   - Ensure effects are in camera view
   - Check Z-index for 2D effects

3. **Layer/Groups**:
   - Verify particle layers match camera cull mask

### Performance Issues

**Symptoms**: Frame rate drops with effects

**Solutions**:
1. **Adjust Particle Count**:
   ```gdscript
   # Reduce particles for mobile
   var particle_effect = VFX.spawn_blood_splash(pos)
   particle_effect.amount = 50  # Default: 100
   ```

2. **Limit Simultaneous Effects**:
   ```gdscript
   # Track active effects
   var max_effects = 10
   if active_effects.size() < max_effects:
       VFX.spawn_energy_burst(pos)
   ```

3. **Use Texture Settings**:
   - Import textures with lower resolution for mobile
   - Enable texture compression

### File Path Errors

**Symptoms**: 
```
res://addons/vfx_library/effects/blood_splash.tscn: No such file
```

**Solutions**:
1. **Reimport Project**:
   - Project → Reload Current Project

2. **Check Installation**:
   - Verify all files copied correctly
   - Re-download if files are missing

3. **Path Case Sensitivity** (Linux/macOS):
   - Ensure exact filename matches

## 📱 Platform-Specific Notes

### Mobile (iOS/Android)

1. **Renderer Settings**:
   - Use Mobile renderer for better performance
   - Limit particle counts (50-100 per effect)

2. **Memory Management**:
   ```gdscript
   # Clean up effects more aggressively
   VFX.cleanup_particles_after = 2.0  # seconds
   ```

### Web (HTML5)

1. **WebGL Compatibility**:
   - Some advanced shaders may need simplification
   - Test thoroughly in browser

2. **Performance**:
   - Reduce particle counts
   - Limit simultaneous effects

### Console Platforms

1. **Memory Constraints**:
   - Monitor texture memory usage
   - Consider effect pooling for performance

## 🔄 Updates

### Updating via Asset Library

1. Go to **AssetLib**
2. Search for "VFX Library"  
3. Click **Download** on newer version
4. Choose **Update** when prompted

### Updating Manual Installation

1. **Backup Current**:
   - Copy `addons/vfx_library` to safe location
   - Note any customizations made

2. **Download New Version**:
   - Download latest release
   - Replace `addons/vfx_library` folder

3. **Restore Customizations**:
   - Copy back any custom modifications
   - Update according to changelog

### Updating Git Submodule

```bash
cd your-project
git submodule update --remote addons/vfx_library
git add addons/vfx_library
git commit -m "Update VFX Library to latest version"
```

## 🗑️ Uninstalling

1. **Disable Plugin**:
   - Project Settings → Plugins
   - Uncheck "VFX Library"

2. **Remove Autoloads** (if needed):
   - Project Settings → AutoLoad
   - Remove `VFX` and `EnvVFX` entries

3. **Delete Files**:
   - Remove `addons/vfx_library/` folder
   - Clean up any custom scenes that reference the effects

4. **Update Code**:
   - Remove or comment out VFX function calls
   - Replace with alternative effects if needed

## ✋ Need Help?

- **GitHub Issues**: Report bugs or ask questions
- **Documentation**: Check `addons/vfx_library/docs/`
- **Demo Scene**: Interactive examples and testing
- **Community**: Discord server (link in README)

---

Happy game development! 🎮✨