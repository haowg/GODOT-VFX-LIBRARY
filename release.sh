#!/bin/bash

# Godot VFX Library Release Script
# 用于快速创建发布包

set -e  # 遇到错误立即退出

echo "🚀 Godot VFX Library Release Tool"
echo "=================================="
echo ""

# 检查是否在正确的目录
if [ ! -f "addons/vfx_library/plugin.cfg" ]; then
    echo "❌ Error: 请在项目根目录运行此脚本"
    exit 1
fi

# 获取版本号
echo "📝 请输入版本号 (例如: 1.0.0):"
read VERSION

if [ -z "$VERSION" ]; then
    echo "❌ Error: 版本号不能为空"
    exit 1
fi

echo ""
echo "准备发布 v$VERSION..."
echo ""

# 创建临时目录
echo "📦 创建发布包..."
TEMP_DIR="release-temp"
RELEASE_DIR="$TEMP_DIR/vfx_library"
ZIP_FILE="godot-vfx-library-v$VERSION.zip"

# 清理旧的临时目录
rm -rf $TEMP_DIR
mkdir -p $RELEASE_DIR

# 复制插件文件
echo "📋 复制插件文件..."
cp -r addons/vfx_library/* $RELEASE_DIR/

# 排除不需要的文件
echo "🧹 清理临时文件..."
find $RELEASE_DIR -name ".DS_Store" -delete
find $RELEASE_DIR -name "*.md~" -delete
find $RELEASE_DIR -name ".git*" -delete

# 创建压缩包
echo "🗜️  创建压缩包..."
cd $TEMP_DIR
zip -r ../$ZIP_FILE vfx_library/ > /dev/null
cd ..

# 清理临时目录
rm -rf $TEMP_DIR

# 显示文件信息
FILE_SIZE=$(du -h $ZIP_FILE | cut -f1)
echo ""
echo "✅ 发布包创建成功！"
echo "📦 文件: $ZIP_FILE"
echo "📊 大小: $FILE_SIZE"
echo ""

# 验证压缩包
echo "📋 压缩包内容预览:"
unzip -l $ZIP_FILE | head -20
echo "... (更多文件)"
echo ""

# 询问是否创建 git tag
echo "🏷️  是否创建 git tag v$VERSION? (y/n)"
read CREATE_TAG

if [ "$CREATE_TAG" = "y" ] || [ "$CREATE_TAG" = "Y" ]; then
    # 检查 tag 是否已存在
    if git rev-parse "v$VERSION" >/dev/null 2>&1; then
        echo "⚠️  警告: Tag v$VERSION 已存在"
        echo "   是否删除并重新创建? (y/n)"
        read RECREATE_TAG
        if [ "$RECREATE_TAG" = "y" ] || [ "$RECREATE_TAG" = "Y" ]; then
            git tag -d "v$VERSION"
            git push origin ":refs/tags/v$VERSION" 2>/dev/null || true
        else
            echo "❌ 已取消"
            exit 1
        fi
    fi
    
    # 创建 tag
    git tag -a "v$VERSION" -m "Release version $VERSION"
    echo "✅ 已创建 tag: v$VERSION"
    echo ""
    
    # 询问是否推送
    echo "📤 是否推送 tag 到 GitHub? (y/n)"
    read PUSH_TAG
    
    if [ "$PUSH_TAG" = "y" ] || [ "$PUSH_TAG" = "Y" ]; then
        git push origin "v$VERSION"
        echo "✅ 已推送 tag 到 GitHub"
        echo ""
    fi
fi

# 显示后续步骤
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📝 后续步骤:"
echo ""
echo "1. 访问 GitHub Releases 页面:"
echo "   https://github.com/haowg/GODOT-VFX-LIBRARY/releases/new?tag=v$VERSION"
echo ""
echo "2. 填写 Release 信息:"
echo "   - Title: VFX Library v$VERSION"
echo "   - Description: 参考 RELEASE_GUIDE.md 中的模板"
echo ""
echo "3. 上传发布包:"
echo "   - 上传文件: $ZIP_FILE"
echo ""
echo "4. 点击 'Publish release'"
echo ""
echo "5. 宣传发布:"
echo "   - 更新 README.md 版本徽章"
echo "   - 发布到社交媒体"
echo "   - 提交到 Godot Asset Library"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✨ 完成！祝发布顺利！"
