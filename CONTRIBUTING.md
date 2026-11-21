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

Each module has its own version and changelog, and release-please opens a separate release pull request for each module that has changed.
A release is tagged as `<module>-v<version>`, such as `keyring-v1.1.0`.
The version a module requires of another module in its `moon.mod` is not bumped by a release, so it has to be raised by hand when the dependent module starts to need the newer release.

## Versioning

Follow [Semantic Versioning 2.0.0](https://semver.org/).

## Commit

Follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) and use the well-known [commit types](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional#type-enum).
