---
description: Sync tool versions and Lua tooling from this template to sibling Playdate projects
argument-hint: [project-name|all]
---

# Playdate Template Sync

This template is the source of truth for Playdate/Lua project configurations. It extends ~/projects/project-template, which owns the foundational files (`.gitignore` base, `.pre-commit-config.yaml` base hooks, `vite.config.ts`, markdownlint, yamllint, `.github/` patterns, and the shared sync includes).

Template path: !`pwd`

## Managed files

`scripts/audit-just-options.py` and its `audit-just-options` justfile recipe stay in the template. The sync runs the audit against each sibling from here; do not copy the script or the recipe into siblings.

### Mise tools

Read tool versions from `.mise/config.toml` in this template:

- `lua` (5.4 line, matching the Playdate runtime)
- `aqua:JohnnyMorganz/StyLua`
- `just`, `pre-commit`, `node`, `npm:markdownlint-cli2`, `npm:vite-plus`

### Lua rocks

The `lua-tools` recipe pins `busted` and `luacheck` rock versions and installs them into `~/.luarocks`. Keep the pinned versions identical across the template and every project.

### Lua tooling configs

- `stylua.toml` and `.styluaignore` — copied verbatim
- `.busted` — copied verbatim
- `.luacheckrc` — the `std`, `include_files`, `max_line_length`, `self`, SDK `read_globals`, and `files["spec"]` settings are shared; the module and scene global lists are per project
- `spec/support/playdate_stub.lua` — the `import` shim and `package.path` setup are shared; each project extends the `playdate` table with the SDK functions its logic needs

### Justfile recipes

`lua-tools`, `test`, `lint`, `format`, `format-check`, and `verify`, plus the `.just/*.just` imports. Projects keep their own game-specific recipes (screenshots, launcher art, typecheck).

### Pre-commit

The project-template base hooks plus `stylua`, with:

- `check-json` excluding `^\.vscode/.*\.json$`, because VS Code settings files allow comments
- a top-level `exclude` for `.vscode/playdate-luacats/`, which is vendored

### GitHub workflows

`merge-group.yml` adds `stylua`, `luacheck`, and `busted` jobs to the project-template jobs, and the `All checks` gate needs all of them. Branch protection on each project should require `All checks`.

### Vendored type stubs

`.vscode/playdate-luacats` is vendored. `.markdownlintignore` and the `.markdownlint-cli2.jsonc` `ignores` list both skip it.

## Version policy

@.claude/includes/sync-version-policy.md

Versions to check for this template:

```bash
mise ls-remote lua | grep '^5\.4' | tail -1
mise ls-remote aqua:JohnnyMorganz/StyLua | tail -1
mise ls-remote just | tail -1
luarocks search busted
luarocks search luacheck
```

## Projects

`$ARGUMENTS` is a project name, `all`, or empty (treated as `all`).

@.claude/includes/sync-project-list.md

## Stale and conflicting tool configs

@.claude/includes/sync-stale-configs.md

Suspect configs for this template's toolchain:

- `biome`, `prettier`, and `eslint` pre-commit hooks — Playdate projects have no `package.json` dependencies, so these hooks call tools that are not installed
- `.github/workflows/just-format.yml` — superseded by the `pre-commit` job in `merge-group.yml`
- Any other config for a tool the template has dropped

## Git ignore files

@.claude/includes/sync-gitignore.md

## Default git test

@.claude/includes/sync-git-test.md

## Just recipe options

@.claude/includes/sync-just-options.md

## Workflow

Work through these in order:

- **Refresh the template.** Run the version checks above; if this template is behind, update it first.
- **Pull from projects.** Read `.llm/projects.yaml` and scan each project's `.mise/config.toml`, `justfile`, `.luacheckrc`, `.busted`, `stylua.toml`, `spec/support/playdate_stub.lua`, and `.github/workflows/*`. If any project has a newer version or a better pattern, verify it is intentional, update this template, then push to the others.
- **Scan for stale configs.** For each project, run the stale-config scan above before generating tooling tasks. Alert on findings; do not delete.
- **Scan ignore files.** For each project, run the `.gitignore` / `.git/info/exclude` scan above. Promote per-clone excludes every peer needs; question only hand-added dead entries. Alert on findings; do not edit either file.
- **Audit recipe options.** Run the shared `just` option audit against each project and create one project-scoped task for every failure.
- **Generate tasks.** For each project, compare against this template and write tasks into its `.llm/todo.md` for any mismatches.

## Creating tasks

@.claude/includes/sync-task-dedup.md

Marker for this template: `Source: ~/projects/playdate-template`

### Task templates

**Mise tool update:**

```
Update stylua <current> → <target>
  Edit .mise/config.toml
  Change: "aqua:JohnnyMorganz/StyLua" = "<current>"
  To: "aqua:JohnnyMorganz/StyLua" = "<target>"
  Source: ~/projects/playdate-template
```

**Rock version update:**

```
Update busted <current> → <target>
  Edit justfile lua-tools recipe
  Change: luarocks install --local busted <current>
  To: luarocks install --local busted <target>
  Source: ~/projects/playdate-template
```

**Adopt the All checks gate:**

```
Adopt merge-group.yml with the All checks gate
  Copy .github/workflows/merge-group.yml, pull-request.yml, and push.yml from the template
  Remove .github/workflows/just-format.yml
  Require "All checks" in branch protection
  Source: ~/projects/playdate-template
```

## Report

@.claude/includes/sync-report.md
