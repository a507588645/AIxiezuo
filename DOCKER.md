# Docker部署指南

本指南介绍如何使用Docker部署AI小说生成系统。

## 快速开始

### 使用Docker Compose（推荐）

1. **准备环境变量文件**
   ```bash
   cp .env.example .env
   ```
   
   编辑 `.env` 文件，填入你的API密钥：
   ```env
   DEEPSEEK_API_KEY=your_deepseek_api_key
   OPENAI_API_KEY=your_openai_api_key
   GOOGLE_API_KEY=your_google_api_key
   ANTHROPIC_API_KEY=your_anthropic_api_key
   ```

2. **启动服务**
   ```bash
   docker-compose up -d
   ```

3. **访问应用**
   
   打开浏览器访问：http://localhost:5001

4. **查看日志**
   ```bash
   docker-compose logs -f
   ```

5. **停止服务**
   ```bash
   docker-compose down
   ```

### 使用预构建镜像

从GitHub Container Registry拉取最新镜像：

```bash
docker pull ghcr.io/a507588645/aixiezuo:latest
```

运行容器：

```bash
docker run -d \
  --name aixiezuo \
  -p 5001:5001 \
  -e DEEPSEEK_API_KEY=your_deepseek_key \
  -e OPENAI_API_KEY=your_openai_key \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/xiaoshuo:/app/xiaoshuo \
  -v $(pwd)/templates:/app/templates \
  ghcr.io/a507588645/aixiezuo:latest
```

### 自行构建镜像

如果你想自己构建Docker镜像：

```bash
docker build -t aixiezuo:latest .
docker run -d -p 5001:5001 --name aixiezuo aixiezuo:latest
```

## 数据持久化

Docker部署会自动挂载以下目录到宿主机，确保数据持久化：

- `./data` - 章节状态和世界设定文件
- `./xiaoshuo` - 生成的小说章节内容
- `./versions` - 多版本内容存储
- `./templates` - 提示词模板文件

## 环境变量配置

支持的环境变量：

| 环境变量 | 说明 | 必需 |
|---------|------|------|
| `DEEPSEEK_API_KEY` | DeepSeek API密钥 | 可选* |
| `OPENAI_API_KEY` | OpenAI API密钥 | 可选* |
| `GOOGLE_API_KEY` | Google Gemini API密钥 | 可选* |
| `ANTHROPIC_API_KEY` | Anthropic Claude API密钥 | 可选* |
| `DSF5_API_MODEL` | 第三方API模型名称 | 可选 |
| `DSF5_API_KEY` | 第三方API密钥 | 可选 |
| `DSF5_API_URL` | 第三方API地址 | 可选 |

\* 至少需要配置一个AI模型的API密钥

## 常见问题

### 如何更新到最新版本？

```bash
docker-compose pull
docker-compose up -d
```

### 如何备份数据？

只需备份挂载的目录：
```bash
tar -czf backup.tar.gz data/ xiaoshuo/ templates/
```

### 如何查看容器日志？

```bash
docker-compose logs -f
# 或
docker logs -f aixiezuo
```

### 端口冲突怎么办？

修改 `docker-compose.yml` 中的端口映射：
```yaml
ports:
  - "8080:5001"  # 使用8080端口代替5001
```

## GitHub Actions自动构建

项目配置了GitHub Actions工作流，可以自动构建并发布Docker镜像。

### 手动触发构建

1. 访问GitHub仓库的 **Actions** 页面
2. 选择 **Build and Push Docker Image** 工作流
3. 点击 **Run workflow**
4. 输入版本号（例如：`1.0.0`）
5. 选择是否同时标记为 `latest`
6. 点击 **Run workflow** 开始构建

### 拉取特定版本

```bash
# 拉取最新版本
docker pull ghcr.io/a507588645/aixiezuo:latest

# 拉取特定版本
docker pull ghcr.io/a507588645/aixiezuo:1.0.0
```

## 技术支持

如有问题，请在GitHub仓库提交Issue。
