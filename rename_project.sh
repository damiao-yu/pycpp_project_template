#!/usr/bin/env bash

set -euo pipefail

SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

usage() {
  cat <<EOF
用法: ./${SCRIPT_NAME} NEW_PROJECT_NAME [OLD_PROJECT_NAME]

作用:
  - 一键替换工程中的 project 名称 (默认旧名为 "myproject")
  - 重命名对应的 C++ include 目录、Python package 目录，以及核心源文件/头文件
  - 更新 CMake / pyproject.toml / 源码 中出现的旧项目名

示例:
  ./${SCRIPT_NAME} awesome_proj
  ./${SCRIPT_NAME} awesome_proj myproject

注意:
  - 建议在干净工作区运行 (git status 为空)，否则请先提交或备份
  - 假设项目名只包含字母、数字、下划线和中划线
EOF
}

if [[ "${1-}" == "-h" || "${1-}" == "--help" ]]; then
  usage
  exit 0
fi

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

NEW_NAME="$1"
OLD_NAME="${2:-myproject}"

if [[ -z "$NEW_NAME" || -z "$OLD_NAME" ]]; then
  echo "错误: NEW_PROJECT_NAME 和 OLD_PROJECT_NAME 不能为空" >&2
  exit 1
fi

if [[ "$NEW_NAME" == "$OLD_NAME" ]]; then
  echo "错误: 新旧项目名相同，无需替换。" >&2
  exit 1
fi

# 切到仓库根目录（脚本所在目录）
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "旧项目名: $OLD_NAME"
echo "新项目名: $NEW_NAME"

# 简单检查: 关键目录是否存在
if [[ ! -d "include/$OLD_NAME" ]]; then
  echo "警告: 目录 include/$OLD_NAME 不存在，可能已经改名或模板结构有变。" >&2
fi

if [[ ! -d "bindings/python/$OLD_NAME" ]]; then
  echo "警告: 目录 bindings/python/$OLD_NAME 不存在，可能已经改名或模板结构有变。" >&2
fi

echo "开始替换文件内容中的项目名 ..."

# 只在常见文本文件类型中做替换，避免破坏二进制文件
find . -type f \
  ! -path "./.git/*" \
  ! -path "./build/*" \
  \( -name "*.cpp" -o -name "*.hpp" -o -name "*.h" -o \
     -name "*.py" -o -name "*.toml" -o -name "*.cmake" -o -name "*.in" \
     -name "*.md" -o -name "CMakeLists.txt" -o -name "LICENSE" -o -name "README" -o -name "README.*" \
  \) -print0 \
  | xargs -0 perl -pi -e "s/\\Q$OLD_NAME\\E/$NEW_NAME/g"

echo "文件内容替换完成。"

echo "开始重命名相关文件和目录 ..."

# 先重命名典型文件名，保证与内容中的新名字一致
if [[ -f "include/$OLD_NAME/$OLD_NAME.hpp" ]]; then
  mv "include/$OLD_NAME/$OLD_NAME.hpp" "include/$OLD_NAME/${NEW_NAME}.hpp"
  echo "已重命名: include/$OLD_NAME/$OLD_NAME.hpp -> include/$OLD_NAME/${NEW_NAME}.hpp"
fi

if [[ -f "src/$OLD_NAME.cpp" ]]; then
  mv "src/$OLD_NAME.cpp" "src/${NEW_NAME}.cpp"
  echo "已重命名: src/$OLD_NAME.cpp -> src/${NEW_NAME}.cpp"
fi

if [[ -f "cmake/${OLD_NAME}Config.cmake.in" ]]; then
  mv "cmake/${OLD_NAME}Config.cmake.in" "cmake/${NEW_NAME}Config.cmake.in"
  echo "已重命名: cmake/${OLD_NAME}Config.cmake.in -> cmake/${NEW_NAME}Config.cmake.in"
fi

echo "开始重命名相关目录 ..."

if [[ -d "include/$OLD_NAME" ]]; then
  mv "include/$OLD_NAME" "include/$NEW_NAME"
  echo "已重命名: include/$OLD_NAME -> include/$NEW_NAME"
fi

if [[ -d "bindings/python/$OLD_NAME" ]]; then
  mv "bindings/python/$OLD_NAME" "bindings/python/$NEW_NAME"
  echo "已重命名: bindings/python/$OLD_NAME -> bindings/python/$NEW_NAME"
fi

echo "项目名替换完成。建议执行以下步骤手动检查:"
echo "  1. git diff           # 查看所有修改"
echo "  2. 重新配置并构建工程 (cmake / pip build)"
echo "  3. 运行示例和单元测试，确保一切正常"
