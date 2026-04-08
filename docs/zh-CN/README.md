# kanfan 中文文档

`kanfan-cli` 是一个源自 [pystardust/ani-cli](https://github.com/pystardust/ani-cli) 的中文站点适配版本。

这组文档面向当前仓库的中文使用场景，重点补充以下内容：

- 项目来源与边界说明
- 常用命令与参数
- 中文站点适配说明
- 代理搜索与直连播放的网络兼容处理

## 推荐阅读顺序

如果你是第一次使用，建议按下面顺序阅读：

1. [安装与依赖](./install.md)
2. [快速使用](./usage.md)
3. [媒体源说明](./sources.md)
4. [网络与代理说明](./networking.md)
5. [LLM 阅读指南](./llm-guide.md)

## 适合谁看

这组文档主要面向以下场景：

- 想直接在命令行里搜索和播放中文站点内容
- 想知道 `--source`、`-S`、`-e` 这些参数怎么用
- 想理解为什么“不开代理搜不到，开代理又播不了”
- 想继续扩展新的中文媒体源

## 项目来源

本项目源自 [pystardust/ani-cli](https://github.com/pystardust/ani-cli)。

原项目提供了命令行交互、播放器调用、历史记录、剧集选择等基础能力；当前版本在此基础上补充了中文站点适配与部分网络兼容处理。

中文站点适配思路与部分规则参考了 [MajoSissi/animeko-source](https://github.com/MajoSissi/animeko-source) 提供的公开订阅源和站点规则定义。

## 内容边界

本项目不提供、托管或分发任何媒体内容。

本项目仅用于对第三方站点进行搜索、页面解析和播放链路适配，具体媒体资源均来自对应站点本身。站点结构、域名和播放行为可能随时发生变化。

## 文档导航

- [快速使用](./usage.md)
- [安装与依赖](./install.md)
- [媒体源说明](./sources.md)
- [网络与代理说明](./networking.md)
- [LLM 阅读指南](./llm-guide.md)

## 当前状态

当前版本主要增加了以下方向：

- 新增 `--source` 参数，用于切换不同媒体源
- 补充中文站点搜索、分集解析与播放链接提取
- 改进“搜索走代理、播放器直连”的网络兼容处理

## 致谢

感谢 [pystardust/ani-cli](https://github.com/pystardust/ani-cli) 及其贡献者提供原始项目与基础框架。
