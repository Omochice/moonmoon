# moonmoon

[![OpenSSF Scorecard](https://api.scorecard.dev/projects/github.com/Omochice/moonmoon/badge)](https://scorecard.dev/viewer/?uri=github.com/Omochice/moonmoon)

A monorepo of personal [MoonBit](https://www.moonbitlang.com/) libraries.

Each library is a separate module, so a program depends only on the ones it uses.
The table below lists the modules.

| Module                         | Summary                                                                             |
| ------------------------------ | ----------------------------------------------------------------------------------- |
| [Omochice/keyring](./keyring/) | Access to the operating system's credential store                                   |
| [Omochice/mcp](./mcp/)         | An MCP tool server over stdio                                                       |
| [Omochice/schema](./schema/)   | A typed schema DSL that yields both a JSON Schema and a decoder from one definition |

## Development

See [CONTRIBUTING.md](./CONTRIBUTING.md) for how to develop on this project.

## License

The libraries are licensed under the zlib License in [LICENSE](./LICENSE).
