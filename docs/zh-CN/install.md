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

## 面向新手的推荐方式

如果你只是想尽快装起来，优先尝试仓库自带脚本：

### 一键安装

```bash
./scripts/install.sh
```

这个脚本会尽量：

- 检测当前平台
- 使用可识别的包管理器安装常见依赖
- 把 `ani-cli` 复制到可执行目录

### 依赖自检

```bash
./scripts/check-deps.sh
```

这个脚本会：

- 检查常见依赖是否缺失
- 输出当前平台下的安装建议命令
- 给出推荐验证命令

如果你不确定缺的是脚本、播放器还是系统依赖，先运行这个脚本最省事。

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

### 推荐方案

Windows 下最推荐的运行方式不是直接在 `cmd` 或原生 PowerShell 中运行，而是：

- 使用 `Windows Terminal`
- 在里面使用 `Git Bash`
- 通过 `scoop` 安装常见依赖

这是因为当前项目本质上仍然是 shell 脚本，`Git Bash` 环境会比传统 Windows 命令行更稳定。

### 为什么不推荐直接用 cmd / PowerShell

常见问题包括：

- shell 行为不一致
- 路径兼容问题
- `fzf` 在不同终端中的交互问题
- `bash.exe` 来源混乱导致脚本调用异常

所以对 Windows 用户来说，目标不是“在任何终端都能跑”，而是优先进入一个更接近 Unix 的终端环境。

### 默认前提

这部分文档默认你已经：

- 安装了 `git`
- 大概率也已经有 `Windows Terminal`

如果你没有这些基础工具，再单独补装即可；这里不把它们当成主要门槛。

### 真正需要额外准备的依赖

在 PowerShell 中执行：

```powershell
scoop bucket add extras
scoop install fzf ffmpeg mpv
```

如果后面需要下载相关能力，也建议装上：

```powershell
scoop install yt-dlp aria2
```

### 运行前确认

重点不是“有没有 Terminal”，而是：

- 请尽量在 `Windows Terminal` 中打开 `Git Bash`
- 不要优先在原生 `cmd` 或原生 PowerShell 里直接执行 shell 脚本

### 克隆仓库

进入 `Git Bash` 后执行：

```bash
git clone https://github.com/Yyyangshenghao/kanfan-cli.git
cd kanfan-cli
chmod +x ./ani-cli
```

### 先用调试模式验证

建议先不要直接播放，先验证搜索和播放链接提取：

```bash
ANI_CLI_PLAYER=debug ./ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

如果能输出最终 `m3u8` 或 `mp4` 地址，说明：

- Git Bash 环境基本可用
- 依赖已基本就绪
- 搜索和解析链路基本正常

### 正式运行

```bash
./ani-cli --source omofun111 "进击的巨人"
```

### Windows 常见问题

#### 1. 卡在搜索输入或交互异常

优先确认你是不是在 `Windows Terminal + Git Bash` 中运行。

不要优先使用：

- 原生 `cmd`
- 原生 PowerShell
- Git 自带的 mintty 终端

#### 2. 报找不到文件或 bash 路径不对

这通常说明当前调用到的不是 Git for Windows 的 `bash.exe`，而是别的 bash 环境。

最稳的做法是：

- 直接在 `Git Bash` 中进入仓库目录运行 `./ani-cli`
- 不要先折腾全局 shim

#### 3. 搜索正常，但播放器打不开

优先检查：

- `mpv` 是否正确安装
- 是否已经加入 Windows PATH
- 是否存在代理与直连冲突

可以先用调试模式确认是否已经拿到最终链接：

```bash
ANI_CLI_PLAYER=debug ./ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

### 现阶段结论

对 Windows 用户来说，当前版本最稳的使用方式是：

- 依赖安装走 `scoop`
- 运行环境走 `Windows Terminal + Git Bash`
- 项目运行使用仓库内的 `./ani-cli`

这比强行让小白直接在原生 PowerShell 或 cmd 中跑 shell 脚本更靠谱。

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

如果你不想手动复制脚本到 `PATH`，也可以在仓库根目录直接运行：

```bash
./scripts/check-deps.sh
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
