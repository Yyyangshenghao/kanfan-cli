# 快速使用

本文档介绍当前版本常用的命令与参数写法。

## 基本命令

直接搜索并播放：

```bash
ani-cli "进击的巨人"
```

指定媒体源：

```bash
ani-cli --source omofun111 "进击的巨人"
```

指定搜索结果序号：

```bash
ani-cli --source omofun111 -S 11 "进击的巨人"
```

指定集数：

```bash
ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

只调试，不真正打开播放器：

```bash
ANI_CLI_PLAYER=debug ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

## 常用参数

### `--source`

指定媒体源站点。

当前版本涉及到的值：

- `allanime`
- `senfun`
- `omofun111`

示例：

```bash
ani-cli --source omofun111 "孤独摇滚"
```

### `-S, --select-nth`

指定搜索结果中的第几个条目。

示例：

```bash
ani-cli --source omofun111 -S 3 "葬送的芙莉莲"
```

### `-e`

指定要播放的集数。

示例：

```bash
ani-cli --source omofun111 -S 3 -e 12 "葬送的芙莉莲"
```

### `-q, --quality`

指定清晰度选择策略。

常见值：

- `best`
- `worst`
- `1080`
- `720`

示例：

```bash
ani-cli --source omofun111 -q best "进击的巨人"
```

## 环境变量

### `ANI_CLI_PLAYER`

指定播放器，或用于调试。

示例：

```bash
ANI_CLI_PLAYER=debug ani-cli --source omofun111 "进击的巨人"
```

### `ANI_CLI_MEDIA_SOURCE`

设置默认媒体源。

示例：

```bash
export ANI_CLI_MEDIA_SOURCE=omofun111
ani-cli "孤独摇滚"
```

### `ANI_CLI_PLAYER_NO_PROXY`

控制播放器启动时是否清除代理环境变量。

默认值为 `1`，表示播放器尽量直连。

示例：

```bash
ANI_CLI_PLAYER_NO_PROXY=1 ani-cli --source omofun111 "进击的巨人"
```

如果你想让播放器也继续沿用当前终端代理，可以改成：

```bash
ANI_CLI_PLAYER_NO_PROXY=0 ani-cli --source omofun111 "进击的巨人"
```

## 推荐排查方式

当你不确定是“没有搜到”还是“播放失败”时，建议先用 `debug` 模式：

```bash
ANI_CLI_PLAYER=debug ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

如果能输出最终 `m3u8` 或 `mp4` 链接，说明搜索和解析基本正常，问题更可能出在播放器、网络出口或请求头兼容上。
