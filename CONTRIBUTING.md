# Contributing

The toolchain is managed with [Nix](https://nixos.org/).

Routine tasks are managed with [Task](https://taskfile.dev/).

```sh
nix develop
task check
task test
nix fmt
```

`task check` also rewrites each package's `pkg.generated.mbti`, and CI fails unless the rewritten files are committed.

`task --list` shows the other tasks.

## Layout

Each library is a separate module listed in the root `moon.work`, so that another MoonBit program can depend on one without pulling in the others.

- `keyring/` is the OS credential store binding.
- `mcp/` is the MCP SDK.
- `schema/` is the typed schema DSL that `mcp/` declares tools with.

All modules share one version, which release-please bumps together.

## Versioning

Follow [Semantic Versioning 2.0.0](https://semver.org/).

## Commit

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and use the well-known [commit types](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional#type-enum).
