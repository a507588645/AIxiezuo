# AI小说生成系统   作者：聪明小鱼鱼/claude/gemini

基于LangChain的AI小说生成工具，支持多种大语言模型，具备状态管理和Web界面。

## 功能特性

- 🤖 支持多种大语言模型（DeepSeek、OpenAI、Claude、Gemini等）
- 📚 章节状态管理和世界设定保存

- 🌐 Web界面，便于交互式创作
- 📝 多小说项目隔离管理
- 🔄 多版本生成和比较

![111](https://github.com/user-attachments/assets/f52a5c9d-2bc0-47a9-b080-8ba2b630d795)

## 安装使用

### 方式一：Docker部署（推荐）

**使用Docker Compose（最简单）：**

1. 复制环境变量示例文件：
```bash
cp .env.example .env
```

2. 编辑 `.env` 文件，填入你的API密钥

3. 启动服务：
```bash
docker-compose up -d
```

4. 访问 http://localhost:5001

**使用Docker镜像：**

从GitHub Container Registry拉取镜像：
```bash
docker pull ghcr.io/a507588645/aixiezuo:latest
```

运行容器：
```bash
docker run -d \
  -p 5001:5001 \
  -e DEEPSEEK_API_KEY=your_key \
  -e OPENAI_API_KEY=your_key \
  -v $(pwd)/data:/app/data \
  -v $(pwd)/xiaoshuo:/app/xiaoshuo \
  ghcr.io/a507588645/aixiezuo:latest
```

### 方式二：本地安装

**1. 安装依赖**

```bash
pip install -r requirements.txt
```

**2. 配置API密钥**

编辑 `.env` 文件：

```env
# 至少配置一个模型的API密钥
DEEPSEEK_API_KEY=your_deepseek_api_key
OPENAI_API_KEY=your_openai_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key
GOOGLE_API_KEY=your_google_api_key
DSF_API_MODEL="第三方api模型"
DSF_API_KEY="第三方api秘钥"
DSF_API_URL="第三方api链接"
```

**3. 启动方式**

**Web界面（推荐）：**
```bash
python start_web.py
```
访问 http://127.0.0.1:5001

**命令行使用：** 使用麻烦，不推荐
```python
from main import NovelGenerator

generator = NovelGenerator()
content = generator.generate_chapter(
    chapter_outline="第一章：开始的故事",
    model_name="deepseek_chat",
    novel_id="my_novel"
)
```

## 文件结构

```
langchain/
├── main.py                 # 核心生成器
├── web_server.py          # Web服务器
├── modules/               # 功能模块
│   ├── llm_module.py     # 大模型调用
│   ├── memory_module.py  # 记忆管理
│   ├── setting_module.py # 设定管理
│   └── workflow.py       # 工作流
├── web/                   # Web界面
│   ├── index.html
│   ├── app.js
│   └── style.css
├── data/                  # 数据存储

├── xiaoshuo/             # 生成内容
├── prompts/              # 提示词模板
└── templates/            # 写作要求模板
```

## 数据存储格式

### 章节状态文件
**位置：** `data/{novel_id}_chapter_{章节号}_state.json`

```json
{
  "chapter_index": 1,
  "protagonist": {
    "name": "主角姓名",
    "age": 18,
    "level": "练气一层",
    "status": "健康",
    "personality": "坚韧不拔",
    "abilities": ["基础剑法"],
    "goal": "成为强者"
  },
  "inventory": [
    {
      "item_name": "铁剑",
      "description": "普通的铁制长剑"
    }
  ],
  "relationships": [
    {
      "name": "师父",
      "relation": "师徒",
      "status": "友好"
    }
  ],
  "current_plot_summary": "主角开始修炼之路"
}
```

### 世界设定文件
**位置：** `data/{novel_id}_world_bible_{版本号}.json`

```json
{
  "world_name": "修仙世界",
  "setting": "古代修仙背景",
  "power_system": "练气->筑基->金丹->元婴",
  "locations": ["青云宗", "天剑峰"],
  "important_items": ["九转玄功", "天剑"],
  "key_npcs": ["掌门", "师兄"]
}
```

### 章节内容文件
**位置：** `xiaoshuo/{novel_id}_chapter_{章节号}.txt`

纯文本格式，存储生成的章节内容。



## API接口

### 核心方法

```python
# 生成章节
generator.generate_chapter(
    chapter_outline="章节大纲",
    model_name="deepseek_chat",  # 模型选择
    novel_id="项目ID",           # 小说项目ID
    use_state=True,              # 是否使用状态
    update_state=True            # 是否更新状态
)

# 交互调用（命令行使用）
generator.chat(
    user_input="用户输入",
    session_id="会话ID",
    model_name="deepseek_chat"
)

# 状态更新
new_state = generator.update_state(
    chapter_content="章节内容",
    current_state=current_state,
    novel_id="项目ID"
)
```

### Web API端点

- `GET /` - Web界面
- `POST /generate` - 生成章节
- `GET /novels` - 获取小说列表
- `GET /novel/{novel_id}/info` - 获取小说信息

## 支持的模型

- **DeepSeek**: deepseek_chat, deepseek_reasoner
- **OpenAI**: openai_gpt4, openai_gpt35
- **Anthropic**: anthropic_claude
- **Google**: google_gemini
- **其他**: dsf (第三方接口)

## Docker部署

### 构建Docker镜像

```bash
docker build -t aixiezuo:latest .
```

### 使用Docker Compose

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 数据持久化

Docker部署会自动挂载以下目录：
- `./data` - 章节状态和世界设定
- `./xiaoshuo` - 生成的小说内容
- `./versions` - 多版本内容
- `./templates` - 提示词模板

### GitHub Actions自动构建

本项目配置了GitHub Actions工作流，可以手动触发构建并发布Docker镜像到GitHub Container Registry (ghcr.io)。

**触发构建：**
1. 进入GitHub仓库的 Actions 页面
2. 选择 "Build and Push Docker Image" 工作流
3. 点击 "Run workflow"
4. 输入版本号（如 1.0.0）
5. 选择是否同时标记为 latest

**使用发布的镜像：**
```bash
# 拉取最新版本
docker pull ghcr.io/a507588645/aixiezuo:latest

# 拉取指定版本
docker pull ghcr.io/a507588645/aixiezuo:1.0.0
```

## 许可证

MIT License 
