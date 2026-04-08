# kanfan-cli LLM Context File

format: machine-oriented repository context

## Project Identity

- project_name: `kanfan-cli`
- project_type: `shell-based command-line anime playback tool`
- upstream_project: `pystardust/ani-cli`
- upstream_url: `https://github.com/pystardust/ani-cli`
- repository_role: `modified downstream adaptation`
- primary_focus:
  - `Chinese web source adaptation`
  - `episode listing extraction`
  - `final playback URL extraction`
  - `proxy-search + direct-player compatibility`

## License

- effective_license: `GPL-3.0`
- preserve_upstream_license: `required`
- preserve_attribution: `required`
- do_not_claim_originality_for_core_framework: `true`

## Non-Goals

- not_a_media_host: `true`
- not_a_content_distributor: `true`
- not_a_general_plugin_framework: `true`
- not_a_complete rewrite: `true`

## Repository Boundaries

- repository_contains:
  - `shell script implementation`
  - `documentation`
  - `source adaptation logic`
  - `network compatibility logic`
- repository_does_not_contain:
  - `owned media assets`
  - `self-hosted streaming backend`
  - `stable public API contracts for source adapters`

## Primary Entry Point

- main_file: `ani-cli`

## Important Functional Areas in `ani-cli`

- CLI argument parsing
- source selection
- search flow
- episode list extraction
- final playback URL extraction
- playback invocation
- history handling
- player network environment handling

## Source Model

- source_strategy: `embedded per-source branching in main script`
- external_plugin_system: `false`

Current known source IDs:

- `allanime`
- `senfun`
- `omofun111`

- `allanime` = upstream/default source path
- `senfun` = Chinese-site experimental adaptation
- `omofun111` = Chinese-site experimental adaptation with page parsing and playback extraction

## Key Functions To Inspect First

- read_order:

1. `setup_media_source`
2. `search_anime`
3. `episodes_list`
4. `get_episode_url`
5. `play_episode`

Then inspect source-specific implementations:

6. `search_anime_senfun`
7. `episodes_list_senfun`
8. `get_episode_url_senfun`
9. `search_anime_omofun`
10. `episodes_list_omofun`
11. `get_episode_url_omofun`

## Control Flow Summary

- execution_flow:

1. parse CLI args
2. choose source
3. search title
4. resolve selected show
5. extract episode list
6. choose episode
7. extract final playback URL
8. invoke player
9. update history

## Chinese Source Adaptation Pattern

- chinese_source_flow:

1. fetch search page HTML
2. extract detail page path
3. fetch detail page
4. extract episode play-page paths
5. fetch play page
6. extract final `m3u8` or `mp4`
7. pass URL + referer to player

## Parsing Strategy

- parsing_tools:

- `curl`
- `grep`
- `sed`
- `awk`

- parsing_characteristics:

- brittle against HTML structure changes
- fast to prototype
- easy to patch for one source at a time
- poor fit for highly dynamic JS-heavy sources

## Network Strategy

- routing_observation:

- search pages may work better through proxy
- media/CDN playback may work better without proxy

- current_solution:

- script-side requests inherit current terminal environment
- player launch can remove proxy-related environment variables

- `ANI_CLI_PLAYER_NO_PROXY`

- player_no_proxy_semantics:

- `1` => strip proxy env vars when launching player
- `0` => keep proxy env vars for player process

- stripped_proxy_envs:

- `http_proxy`
- `https_proxy`
- `HTTP_PROXY`
- `HTTPS_PROXY`
- `all_proxy`
- `ALL_PROXY`
- `no_proxy`
- `NO_PROXY`

## Debugging Guidance

- first_diagnostic_command:

```bash
ANI_CLI_PLAYER=debug ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"
```

- debug_output_interpretation:

- if no search results: likely search-page/network/source parsing issue
- if episode list empty: likely detail-page parsing issue
- if final direct URL missing: likely play-page extraction issue
- if final URL exists but playback fails: likely player headers / network / CDN issue

## Important Environment Variables

- `ANI_CLI_PLAYER`
- `ANI_CLI_MEDIA_SOURCE`
- `ANI_CLI_PLAYER_NO_PROXY`
- `ANI_CLI_QUALITY`
- `ANI_CLI_MODE`

## Command Surface

- main_command: `ani-cli`
- common_commands:
  - `ani-cli "进击的巨人"`
  - `ani-cli --source omofun111 "进击的巨人"`
  - `ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"`
  - `ANI_CLI_PLAYER=debug ani-cli --source omofun111 -S 11 -e 1 "进击的巨人"`

## Important Flags

- `--source` => select media source
- `-S` / `--select-nth` => choose nth search result
- `-e` => choose episode number
- `-q` / `--quality` => select output quality
- `-v` / `--vlc` => use VLC

## Install Hints

- install_mode: `copy shell script into PATH or run from repository`
- macos_from_source:
  - `git clone <repo-url>`
  - `cd <repo-dir>`
  - `cp ./ani-cli "$(brew --prefix)"/bin`
- macos_dependencies:
  - `brew install curl grep aria2 ffmpeg git fzf yt-dlp`
  - `brew install --cask iina`

## Files Useful For Context

- human_docs:

- `docs/zh-CN/README.md`
- `docs/zh-CN/usage.md`
- `docs/zh-CN/sources.md`
- `docs/zh-CN/networking.md`

- machine_read_priority:

1. `docs/zh-CN/llm-guide.md`
2. `ani-cli`
3. `docs/zh-CN/sources.md`
4. `docs/zh-CN/networking.md`
5. `README.md`

## Rules For Future Modifications

- preserve GPL-3.0 distribution
- preserve upstream attribution
- do not remove license text
- do not present the project as a fully original player framework
- prefer minimal source-specific patches over broad speculative refactors
- verify source extraction via `ANI_CLI_PLAYER=debug` before changing player behavior
- when source behavior differs by network environment, diagnose search and playback separately
