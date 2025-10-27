# Release Guide

本指南说明如何创建和发布 Godot VFX Library 的新版本。

## 📋 发布前检查清单

### 1. 代码准备

- [ ] 所有功能已完成并测试
- [ ] 所有已知 Bug 已修复
- [ ] 代码已提交到 main 分支
- [ ] 文档已更新（README, API_REFERENCE, CHANGELOG）
- [ ] 演示场景正常工作

### 2. 版本号确定

使用[语义化版本](https://semver.org/lang/zh-CN/)：`MAJOR.MINOR.PATCH`

- **MAJOR** (1.x.x): 不兼容的 API 变更
- **MINOR** (x.1.x): 向下兼容的功能新增
- **PATCH** (x.x.1): 向下兼容的问题修复

**当前版本**: 1.0.0  
**下一版本**: ______

### 3. 更新文档

#### 更新 CHANGELOG.md

```markdown
## [1.0.1] - 2024-10-27

### Added
- 新增的功能列表

### Changed
- 修改的功能列表

### Fixed
- 修复的 Bug 列表

### Deprecated
- 即将废弃的功能
```

#### 更新版本号

需要更新以下文件中的版本号：

1. **plugin.cfg**
   ```ini
   [plugin]
   version="1.0.1"
   ```

2. **README.md**
   ```markdown
   [![Version](https://img.shields.io/badge/version-1.0.1-green.svg)]
   ```

3. **README_CN.md**
   ```markdown
   [![Version](https://img.shields.io/badge/version-1.0.1-green.svg)]
   ```

## 🚀 创建 Release

### 方法 1: GitHub Web 界面（推荐）

1. **访问 Releases 页面**
   ```
   https://github.com/haowg/GODOT-VFX-LIBRARY/releases
   ```

2. **点击 "Draft a new release"**

3. **填写 Release 信息**

   **Tag version**: `v1.0.0`
   - 格式: `v` + 版本号
   - 例如: `v1.0.0`, `v1.0.1`, `v1.1.0`

   **Release title**: `VFX Library v1.0.0`
   - 格式: `VFX Library v` + 版本号

   **Description**: (见下方模板)

4. **选择目标分支**: `main`

5. **添加发布说明** (使用下方模板)

6. **生成 Release Notes** (可选)
   - 点击 "Generate release notes" 自动生成
   - 手动编辑优化内容

7. **上传文件** (可选但推荐)
   - 上传预编译的插件压缩包
   - 见下方"准备发布文件"部分

8. **发布**
   - 预览无误后点击 "Publish release"
   - 或点击 "Save draft" 保存草稿

### 方法 2: Git 命令行

```bash
# 1. 确保在 main 分支且代码最新
git checkout main
git pull origin main

# 2. 创建并推送 tag
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# 3. 在 GitHub 网页上编写 Release 说明
```

## 📦 准备发布文件

### 创建插件压缩包

只打包插件核心文件，不包含项目文件：

```bash
# 进入项目目录
cd /Users/weiguohao/workspace/godot-vfx-library

# 创建临时目录
mkdir -p release-temp/vfx_library

# 复制插件文件
cp -r addons/vfx_library/* release-temp/vfx_library/

# 创建压缩包
cd release-temp
zip -r ../godot-vfx-library-v1.0.0.zip vfx_library/

# 清理临时目录
cd ..
rm -rf release-temp

# 验证压缩包
unzip -l godot-vfx-library-v1.0.0.zip
```

**包含的文件**:
```
vfx_library/
├── plugin.cfg
├── plugin.gd
├── vfx.gd
├── env_vfx.gd
├── effects/
├── shaders/
├── demo/
└── (所有 .import 和 .uid 文件)
```

**不包含**:
- `project.godot`
- `.godot/`
- `.git/`
- 根目录的文档文件（用户可以在 GitHub 查看）

### 上传到 Release

将生成的 `godot-vfx-library-v1.0.0.zip` 上传到 GitHub Release 页面的 "Attach binaries" 区域。

## 📝 Release 说明模板

### 英文版

```markdown
# VFX Library v1.0.0

A comprehensive collection of 35+ particle effects and 17+ shaders for Godot 4.

## ✨ Highlights

- 🎆 35+ ready-to-use particle effects
- 🎨 17+ customizable shaders
- 🎮 Easy-to-use manager systems
- 📖 Complete documentation and API reference
- 🎯 Optimized for action games and platformers

## 📥 Installation

### Recommended Method
```bash
cd your-project/addons/
git clone https://github.com/haowg/GODOT-VFX-LIBRARY.git vfx_library
```

### Manual Installation
1. Download `godot-vfx-library-v1.0.0.zip` below
2. Extract to your project's `addons/` folder
3. Enable "VFX Library" in Project Settings → Plugins

## 📖 Documentation

- [README](https://github.com/haowg/GODOT-VFX-LIBRARY#readme)
- [Installation Guide](https://github.com/haowg/GODOT-VFX-LIBRARY/blob/main/INSTALLATION.md)
- [API Reference](https://github.com/haowg/GODOT-VFX-LIBRARY/blob/main/API_REFERENCE.md)
- [Demo Scene](https://github.com/haowg/GODOT-VFX-LIBRARY/tree/main/addons/vfx_library/demo)

## 🎯 What's New

### Added
- Initial release with 35+ particle effects
- 17+ shader effects for various visual needs
- VFX and EnvVFX manager systems
- Complete API documentation
- Interactive demo scene

## 🔧 Requirements

- Godot 4.5 or later
- Forward+ or Mobile renderer

## 📊 Assets Included

**Particle Effects (35+)**
- Combat: Blood splash, energy burst, shield break, sparks
- Movement: Dash trail, jump dust, wall slide sparks
- Environment: Fire, water, weather, atmospheric effects
- Magic: Portals, lightning, ice, summoning circles

**Shaders (17+)**
- Character status effects
- Environmental effects
- Post-processing effects

## 🤝 Contributing

Contributions are welcome! See [CONTRIBUTING.md](https://github.com/haowg/GODOT-VFX-LIBRARY/blob/main/CONTRIBUTING.md)

## 📝 License

MIT License - Free for commercial use

---

⭐ If you find this useful, please star the repository!
```

### 中文版（可选，添加到英文版后面）

```markdown
---

## 中文说明

Godot 4 专用的综合特效库，包含35+粒子特效和17+着色器。

### 安装方法

**推荐方式**
```bash
cd your-project/addons/
git clone https://github.com/haowg/GODOT-VFX-LIBRARY.git vfx_library
```

**手动安装**
1. 下载下方的 `godot-vfx-library-v1.0.0.zip`
2. 解压到项目的 `addons/` 文件夹
3. 在项目设置 → 插件中启用 "VFX Library"

### 文档
- [中文 README](https://github.com/haowg/GODOT-VFX-LIBRARY/blob/main/README_CN.md)
- [完整文档](https://github.com/haowg/GODOT-VFX-LIBRARY)

### 包含内容
- 35+ 粒子特效（战斗、移动、环境、魔法）
- 17+ 着色器（状态效果、环境、后处理）
- 完整的管理器系统和文档
```

## ✅ 发布后操作

### 1. 验证 Release

- [ ] 下载并测试发布的压缩包
- [ ] 确认文件完整性
- [ ] 在新项目中测试安装

### 2. 更新文档链接

如果文档中有 "latest release" 链接，确保它们指向正确版本。

### 3. 社交媒体宣传

- [ ] 发布到 Godot 社区论坛
- [ ] 分享到相关 Discord 服务器
- [ ] B站发布演示视频
- [ ] Twitter/X 宣传

### 4. Godot Asset Library（可选）

提交到 Godot 官方资源库：
1. 访问 https://godotengine.org/asset-library/asset
2. 点击 "Submit asset"
3. 填写插件信息
4. 等待审核

## 🔄 快速发布脚本

创建一个自动化脚本 `release.sh`：

```bash
#!/bin/bash

# Godot VFX Library Release Script

# 获取版本号
echo "Enter version number (e.g., 1.0.1):"
read VERSION

echo "Creating release for v$VERSION..."

# 创建发布文件
mkdir -p release-temp/vfx_library
cp -r addons/vfx_library/* release-temp/vfx_library/

# 创建压缩包
cd release-temp
zip -r ../godot-vfx-library-v$VERSION.zip vfx_library/
cd ..
rm -rf release-temp

echo "✅ Created: godot-vfx-library-v$VERSION.zip"

# 创建 git tag
echo "Create git tag? (y/n)"
read CREATE_TAG

if [ "$CREATE_TAG" = "y" ]; then
    git tag -a v$VERSION -m "Release version $VERSION"
    echo "✅ Created tag: v$VERSION"
    
    echo "Push tag to GitHub? (y/n)"
    read PUSH_TAG
    
    if [ "$PUSH_TAG" = "y" ]; then
        git push origin v$VERSION
        echo "✅ Pushed tag to GitHub"
        echo "📝 Now go to GitHub to create the release with the zip file"
        echo "   https://github.com/haowg/GODOT-VFX-LIBRARY/releases/new?tag=v$VERSION"
    fi
fi

echo "Done!"
```

使用方法：
```bash
chmod +x release.sh
./release.sh
```

## 📋 版本发布检查表

打印此清单，发布时逐项检查：

```
□ 代码已合并到 main 分支
□ 所有测试通过
□ CHANGELOG.md 已更新
□ plugin.cfg 版本号已更新
□ README.md 徽章版本已更新
□ README_CN.md 徽章版本已更新
□ 创建了插件压缩包
□ 创建了 git tag
□ 推送了 tag 到 GitHub
□ 在 GitHub 创建了 Release
□ 上传了压缩包
□ 填写了 Release 说明
□ 发布了 Release
□ 测试了下载和安装
□ 发布了宣传信息
```

---

**下次发布提醒**: 在发布后立即更新 CHANGELOG.md 添加 `## [Unreleased]` 部分，记录后续的开发变更。