# Installation Guide

This guide will walk you through installing and setting up the Godot VFX Library in your project.

## 📋 Requirements

- **Godot Engine**: 4.5 or later
- **Renderer**: Forward+ or Mobile (Compatibility renderer has limited support)
- **Platform**: Windows, macOS, Linux, iOS, Android
- **Project Type**: 2D or 3D projects

## 🚀 Installation Methods

### Method 1: Manual Download

1. **Download Release**
   - Visit [GitHub Releases](https://github.com/haowg/GODOT-VFX-LIBRARY/releases)
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

### Method 2: Git Clone

1. **Clone Repository**
   ```bash
   cd your-project/addons/
   git clone https://github.com/haowg/GODOT-VFX-LIBRARY.git vfx_library
   ```
   
   **Important**: Clone directly into `addons/vfx_library` (not `addons/GODOT-VFX-LIBRARY`)

2. **Enable Plugin**
   - Open project in Godot
   - Enable plugin in Project Settings → Plugins

### Method 3: Symbolic Link (Recommended for Development)

**Best for**: Development, testing, or using the same plugin across multiple projects.

1. **Clone Repository Once**
   ```bash
   # Clone to a central location
   cd ~/godot-plugins/  # or any location you prefer
   git clone https://github.com/haowg/GODOT-VFX-LIBRARY.git
   ```

2. **Create Symbolic Link**
   ```bash
   # In your project directory
   cd your-project/addons/
   ln -s ~/godot-plugins/GODOT-VFX-LIBRARY/addons/vfx_library vfx_library
   ```
   
   **Windows (Command Prompt as Admin)**:
   ```cmd
   cd your-project\addons\
   mklink /D vfx_library C:\path\to\GODOT-VFX-LIBRARY\addons\vfx_library
   ```
   
   **Windows (PowerShell as Admin)**:
   ```powershell
   cd your-project\addons\
   New-Item -ItemType SymbolicLink -Path vfx_library -Target C:\path\to\GODOT-VFX-LIBRARY\addons\vfx_library
   ```

3. **Enable Plugin**
   - Open project in Godot
   - Enable plugin in Project Settings → Plugins

**Advantages**:
- ✅ Update once, reflect in all projects
- ✅ Easy to develop and test changes
- ✅ No duplicate files
- ✅ Git updates apply to all projects immediately

**Note**: Make sure to add `addons/vfx_library` to your project's `.gitignore` if it's a symlink.

### Method 4: Git Submodule

**⚠️ Note**: Due to repository structure, submodule installation requires extra steps.

**Recommended Alternative**: Use Git Clone (Method 2) or Manual Installation (Method 1) instead.

If you must use submodules:

1. **Clone to Temporary Location**
   ```bash
   cd your-project
   git clone https://github.com/haowg/GODOT-VFX-LIBRARY.git temp_vfx
   ```

2. **Copy Plugin Files**
   ```bash
   cp -r temp_vfx/addons/vfx_library addons/
   rm -rf temp_vfx
   ```

3. **Add as Submodule** (optional, for tracking updates)
   ```bash
   cd addons/vfx_library
   git init
   git remote add origin https://github.com/haowg/GODOT-VFX-LIBRARY.git
   git fetch
   git checkout -b main origin/main
   ```

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

### Installation Issues

- **Solution**: Ensure Godot version is 4.5+
- **Check**: Verify all files copied correctly to `addons/vfx_library/`
- **Alternative**: Try different installation method (manual vs Git)

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

### Updating Manual Installation

1. **Backup Current**:
   - Copy `addons/vfx_library` to safe location
   - Note any customizations made

2. **Download New Version**:
   - Download latest release from GitHub
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