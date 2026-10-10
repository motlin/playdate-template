# Playdate Template

A template for [Playdate](https://play.date/) games written in Lua. It extends [project-template](https://github.com/motlin/project-template) with the Playdate SDK build, StyLua formatting, luacheck linting, and busted specs that run on the host.

## Getting started

1. Install the [Playdate SDK](https://play.date/dev/) so `pdc` and the Simulator are available.
2. Run `just mise` to install the pinned tools, then `just lua-tools` to install busted and luacheck into `~/.luarocks`.
3. Set `PROJECT_NAME` (or edit `project_name` in the `justfile`) and update `source/pdxinfo`.
4. Run `just run` to build and open the game in the Simulator.

## Recipes

| Recipe              | Purpose                                                |
| ------------------- | ------------------------------------------------------ |
| `just build`        | Compile `source/` into `builds/<name>.pdx` with `pdc`  |
| `just run`          | Build and open the game in the Playdate Simulator      |
| `just test`         | Run busted specs from `spec/` against a Playdate stub  |
| `just lint`         | Run luacheck over `source/` and `spec/`                |
| `just format`       | Format Lua with StyLua                                 |
| `just format-check` | Check Lua formatting without writing                   |
| `just verify`       | Run every pre-commit hook, then lint, specs, and build |
| `just lua-tools`    | Install the pinned busted and luacheck rocks           |

## Host-side specs

Specs load modules through `spec/support/playdate_stub.lua`, which puts `source/` on the Lua path and stands in for the Playdate runtime. Extend the stub with the SDK functions your game logic touches; keep drawing and input code out of the modules you test.

## Continuous integration

`merge-group.yml` runs pre-commit, StyLua, luacheck, busted, markdownlint, yamllint, actionlint, and zizmor, gated by the `All checks` job. `pdc` is not available on GitHub runners, so the Playdate build stays in `just verify`.

## Vendored files

`.vscode/playdate-luacats` holds the Playdate SDK type stubs for the Lua language server. Formatters and linters skip it so it stays identical to upstream.
