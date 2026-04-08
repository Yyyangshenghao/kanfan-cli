# 安装与依赖

本文档用于补充 `kanfan-cli` 当前版本在不同平台上的安装方式、依赖准备和从源码运行方法。

## 先说明一件事

当前仓库核心仍然是一个 shell 脚本，主入口文件名还是：

```bash
ani-cli
```

也就是说，即使仓库名叫 `kanfan-cli`，你实际执行的命令通常仍然是：

```bash
ani-cli
```

如果你后面想把脚本文件名也改成 `kanfan-cli`，那是下一步的仓库整理工作。

## 运行所需的基础依赖

不同平台安装方式不同，但一般至少需要下面几类依赖：

- `curl`
- `grep`
- `fzf`
- 一个播放器：`mpv`、`vlc` 或 macOS 上的 `iina`

以下依赖在部分功能下也常见：

- `aria2`
- `ffmpeg`
- `yt-dlp`
- `git`

## macOS

### 推荐方式

使用 Homebrew 安装依赖，然后直接从源码复制脚本到 `PATH`。

### 安装依赖

```bash
brew install curl grep aria2 ffmpeg git fzf yt-dlp
brew install --cask iina
```

### 从源码安装

如果你已经克隆了仓库：

```bash
cd /path/to/kanfan-cli
cp ./ani-cli "$(brew --prefix)"/bin
```

然后就可以直接执行：

```bash
ani-cli --source omofun111 "进击的巨人"
```

### macOS 说明

- 当前版本在 macOS + IINA 场景下做了较多兼容处理
- 如果遇到搜索正常但播放失败，优先参考 [网络与代理说明](./networking.md)

## Linux

### 依赖安装思路

不同发行版命令不同，但通常建议准备：

```bash
curl
grep
fzf
mpv
aria2
ffmpeg
git
yt-dlp
```

### 从源码运行

```bash
git clone https://github.com/Yyyangshenghao/kanfan-cli.git
cd kanfan-cli
chmod +x ./ani-cli
./ani-cli --source omofun111 "进击的巨人"
```

### 安装到本地命令路径

如果你想全局执行：

```bash
sudo cp ./ani-cli /usr/local/bin/ani-cli
```

然后执行：

```bash
ani-cli --source omofun111 "进击的巨人"
```

## Windows

### 推荐理解方式

Windows 下更适合在 Git Bash、WSL 或类 Unix shell 环境里运行，而不是直接在传统 `cmd` 里运行。

### 建议准备

- `git`
- `fzf`
- `ffmpeg`
- `mpv` 或 `vlc`

如果你沿用原 `ani-cli` 的做法，可以参考原 README 中更完整的 Windows 说明。

### 简化建议

如果你只是想先跑起来：

1. 安装 Git for Windows
2. 使用 Git Bash
3. 准备好 `fzf` 和播放器
4. 在仓库目录中执行：

```bash
./ani-cli --source omofun111 "进击的巨人"
```

## Android

### Termux 方式

如果你使用 Termux，至少需要有一个可以拉起的播放器，并准备基本命令行环境。

### 基本思路

```bash
pkg up -y
pkg install git curl grep fzf
```

然后克隆仓库：

```bash
git clone https://github.com/Yyyangshenghao/kanfan-cli.git
cd kanfan-cli
chmod +x ./ani-cli
./ani-cli --source omofun111 "进击的巨人"
```

播放器可以使用 Android 平台上的 `mpv` 或 `vlc` 应用。

## 从源码直接运行

这是最通用、也最适合当前版本的方式。

```bash
git clone https://github.com/Yyyangshenghao/kanfan-cli.git
cd kanfan-cli
chmod +x ./ani-cli
./ani-cli --source omofun111 "进击的巨人"
```

## 推荐安装后第一条验证命令

建议先不要直接播放，先验证搜索和播放链接提取：

```bash
ANI_CLI_PLAYER=debug ./ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

如果能输出最终 `m3u8` 或 `mp4` 地址，说明：

- 脚本可执行
- 依赖基本可用
- 当前源的搜索和解析链路基本正常

## 常见问题

### 1. 装好了，但命令找不到

如果你是直接在仓库目录里运行，请使用：

```bash
./ani-cli
```

如果你想全局运行，需要把脚本复制到 `PATH` 目录里。

### 2. 搜索不到结果

优先检查：

- 当前网络环境
- 目标站点是否可访问
- 是否需要代理

参考：

- [网络与代理说明](./networking.md)

### 3. 搜索正常，但播放器播不了

优先检查：

- 是否需要播放器直连
- 是否需要 `Referer`
- 当前播放器是否与站点 CDN 兼容

参考：

- [网络与代理说明](./networking.md)
- [快速使用](./usage.md)
