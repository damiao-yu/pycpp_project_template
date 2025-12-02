# myproject 模板工程

一个最小可用的 **C++ 库 + pybind11 Python 绑定** 的工程模板，使用 **CMake + scikit-build-core** 构建。

## 项目结构

```text
myproject/
├── CMakeLists.txt              # 顶层 CMake 配置，导出 myproject::myproject_core 供 find_package 使用
├── pyproject.toml              # Python 构建配置（scikit-build-core）
├── README.md
├── LICENSE
├── .gitignore
├── cmake/
│   ├── ProjectConfig.cmake.in  # CMake package 配置模板
│   └── myprojectConfig.cmake.in
├── include/
│   └── myproject/              # C++ 头文件
│       └── mylib.hpp
├── src/
│   ├── CMakeLists.txt          # 定义 myproject_core 库并安装导出
│   └── mylib.cpp               # C++ 实现
├── bindings/
│   ├── CMakeLists.txt
│   └── python/
│       ├── CMakeLists.txt      # 使用 pybind11 构建 Python 扩展 myproject_cpp
│       ├── module.cpp          # pybind11 绑定代码
│       └── myproject/
│           └── __init__.py     # Python 包入口
├── unittest/
│   ├── CMakeLists.txt          # CTest 集成
│   └── test_basic.cpp          # 简单的 C++ 单元测试
└── examples/
    ├── CMakeLists.txt          # 预留 C++ 示例
    └── example.py              # Python 示例
```

## 构建与安装

### 1. 纯 C++ 构建与安装

在本地构建并安装到自定义前缀（例如 `./install`）：

```bash
cmake -S . -B build -DCMAKE_INSTALL_PREFIX=$PWD/install
cmake --build build --target install
```

安装完成后，可以在其他 CMake 工程中使用：

```cmake
find_package(myproject REQUIRED)
add_executable(demo main.cpp)
target_link_libraries(demo PRIVATE myproject::myproject_core)
```

### 2. Python 包（wheel）构建与安装

在一个 Python 环境中：

```bash
rm -rf build dist
python -m build
python -m pip install --force-reinstall dist/myproject-*.whl
```

安装完成后，直接运行示例脚本：

```bash
python examples/example.py
```

## 后续扩展建议

- **扩展 C++ API**
  - 在 `include/myproject/` 中声明新的函数或类。
  - 在 `src/` 中实现它们。
  - 在 `bindings/python/` 中通过 pybind11 导出到 Python。

- **增加 C++ 测试**
  - 在 `unittest/` 中添加更多 C++ 测试，并在对应的 `CMakeLists.txt` 中注册 `add_test(...)`。

- **项目元数据与发布**
  - 根据实际情况修改 `pyproject.toml` 中的 `authors`、`maintainers`、`classifiers` 与 `[project.urls]`。
