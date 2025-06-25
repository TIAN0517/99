# AI 模型选择指南 - Jy技術團隊 瓦斯行管理系統 2025

## 🧠 根据 VPS 内存选择合适的 AI 模型

### 📊 内存需求对照表

| 内存大小 | 推荐模型 | 下载命令 | 特点 |
|---------|----------|----------|------|
| **< 2GB** | `phi3:mini` | `ollama pull phi3:mini` | 超轻量，基础对话 |
| **2-4GB** | `gemma:2b` | `ollama pull gemma:2b` | 轻量级，中文支持好 |
| **4-8GB** | `qwen2:1.5b` | `ollama pull qwen2:1.5b` | 中等性能，中文优化 |
| **8GB+** | `deepseek-r1:8b` | `ollama pull deepseek-r1:8b` | 高性能，推理能力强 |

### 🚀 快速检查内存并选择模型

```bash
# 1. 检查 VPS 内存
free -h

# 2. 根据内存选择模型
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
echo "总内存: ${TOTAL_MEM}GB"

# 3. 自动选择合适的模型
if (( $(echo "$TOTAL_MEM < 2.0" | bc -l) )); then
    AI_MODEL="phi3:mini"
elif (( $(echo "$TOTAL_MEM < 4.0" | bc -l) )); then
    AI_MODEL="gemma:2b"
elif (( $(echo "$TOTAL_MEM < 8.0" | bc -l) )); then
    AI_MODEL="qwen2:1.5b"
else
    AI_MODEL="deepseek-r1:8b"
fi

echo "推荐模型: $AI_MODEL"

# 4. 下载模型
docker exec ollama ollama pull $AI_MODEL
```

### 📝 各模型详细说明

#### 1. phi3:mini (< 2GB 内存)
- **内存占用**: ~1.8GB
- **适用场景**: 超低内存 VPS
- **功能**: 基础中文对话、简单问答
- **下载命令**: 
  ```bash
  docker exec ollama ollama pull phi3:mini
  ```

#### 2. gemma:2b (2-4GB 内存) ⭐ **推荐**
- **内存占用**: ~2.5GB
- **适用场景**: 中小型 VPS
- **功能**: 流畅中文对话、业务咨询、基础分析
- **下载命令**: 
  ```bash
  docker exec ollama ollama pull gemma:2b
  ```

#### 3. qwen2:1.5b (4-8GB 内存)
- **内存占用**: ~3.5GB
- **适用场景**: 中等配置 VPS
- **功能**: 专业中文对话、业务分析、复杂查询
- **下载命令**: 
  ```bash
  docker exec ollama ollama pull qwen2:1.5b
  ```

#### 4. deepseek-r1:8b (8GB+ 内存)
- **内存占用**: ~6.6GB
- **适用场景**: 高配置 VPS
- **功能**: 高级推理、代码生成、复杂业务分析
- **下载命令**: 
  ```bash
  docker exec ollama ollama pull deepseek-r1:8b
  ```

### 🔧 模型管理命令

#### 查看已安装的模型
```bash
docker exec ollama ollama list
```

#### 删除不需要的模型（释放空间）
```bash
# 删除大模型释放空间
docker exec ollama ollama rm deepseek-r1:8b
docker exec ollama ollama rm qwen2:1.5b
```

#### 切换模型
```bash
# 在应用中修改环境变量
echo "DEFAULT_AI_MODEL=gemma:2b" >> /opt/gas-management-system/.env

# 重启应用
systemctl restart gas-management
```

### 🎯 推荐配置方案

#### 方案一：经济型 VPS (2GB 内存)
```bash
# 下载轻量级模型
docker exec ollama ollama pull gemma:2b

# 设置环境变量
echo "DEFAULT_AI_MODEL=gemma:2b" >> .env
```

#### 方案二：标准型 VPS (4GB 内存)
```bash
# 下载中文优化模型
docker exec ollama ollama pull qwen2:1.5b

# 设置环境变量  
echo "DEFAULT_AI_MODEL=qwen2:1.5b" >> .env
```

#### 方案三：高性能 VPS (8GB+ 内存)
```bash
# 下载高性能模型
docker exec ollama ollama pull deepseek-r1:8b

# 设置环境变量
echo "DEFAULT_AI_MODEL=deepseek-r1:8b" >> .env
```

### 🛠️ 故障排除

#### 模型下载失败
```bash
# 检查网络连接
curl -I https://ollama.ai

# 检查 Docker 容器状态
docker ps | grep ollama

# 重启 Ollama 容器
docker restart ollama

# 清理缓存后重试
docker exec ollama ollama rm <模型名>
docker exec ollama ollama pull <模型名>
```

#### 内存不足
```bash
# 检查内存使用
free -h
docker stats

# 删除大模型
docker exec ollama ollama rm deepseek-r1:8b

# 下载更小的模型
docker exec ollama ollama pull phi3:mini
```

#### 模型响应慢
```bash
# 检查 CPU 使用率
htop

# 限制 Docker 内存使用
docker update --memory="2g" ollama

# 切换到更小的模型
docker exec ollama ollama pull gemma:2b
```

### 📊 性能对比

| 模型 | 内存占用 | 响应速度 | 中文质量 | 推理能力 | 适用场景 |
|------|----------|----------|----------|----------|----------|
| phi3:mini | ⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ | 基础对话 |
| gemma:2b | ⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | 业务咨询 |
| qwen2:1.5b | ⭐⭐⭐ | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ | 专业分析 |
| deepseek-r1:8b | ⭐⭐⭐⭐⭐ | ⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 复杂推理 |

### 🚀 一键设置脚本

创建自动检测并下载最佳模型的脚本：

```bash
#!/bin/bash
# 自动模型选择脚本

echo "🤖 自动选择最佳 AI 模型..."

# 检查内存
TOTAL_MEM=$(free -m | awk 'NR==2{printf "%.1f", $2/1024}')
echo "系统内存: ${TOTAL_MEM}GB"

# 选择模型
if (( $(echo "$TOTAL_MEM < 2.0" | bc -l) )); then
    MODEL="phi3:mini"
    echo "🔹 选择超轻量级模型: $MODEL"
elif (( $(echo "$TOTAL_MEM < 4.0" | bc -l) )); then
    MODEL="gemma:2b"
    echo "🔸 选择轻量级模型: $MODEL"
elif (( $(echo "$TOTAL_MEM < 8.0" | bc -l) )); then
    MODEL="qwen2:1.5b" 
    echo "🔶 选择中等模型: $MODEL"
else
    MODEL="deepseek-r1:8b"
    echo "🔷 选择高性能模型: $MODEL"
fi

# 下载模型
echo "📥 下载模型: $MODEL"
docker exec ollama ollama pull $MODEL

# 更新配置
echo "⚙️ 更新配置文件..."
if [ -f "/opt/gas-management-system/.env" ]; then
    sed -i "s/DEFAULT_AI_MODEL=.*/DEFAULT_AI_MODEL=$MODEL/" /opt/gas-management-system/.env
else
    echo "DEFAULT_AI_MODEL=$MODEL" >> /opt/gas-management-system/.env
fi

# 重启服务
echo "🔄 重启应用服务..."
systemctl restart gas-management

echo "✅ 模型配置完成！当前使用: $MODEL"
```

保存为 `auto-setup-ai.sh` 并运行：
```bash
chmod +x auto-setup-ai.sh
./auto-setup-ai.sh
```

---

**💡 建议**: 对于大多数瓦斯行业务场景，`gemma:2b` 是最佳选择，既节省资源又能提供良好的中文对话体验。

**📞 技术支持**: Jy技術團隊 - 2025
