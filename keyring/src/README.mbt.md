# Omochice/keyring

Four operations on the operating system's credential store, `get`, `set`, `delete`, and `list`, written as C stubs that reach each platform's library without link flags in the consumer's build, so a consumer adds nothing of its own.

The module covers the macOS Keychain, the Secret Service through libsecret on Linux, and the Windows Credential Manager.
It covers nothing else: no other store, no prompt for a secret, and no policy on what the service and account names mean.

On macOS the plaintext of a read secret stays in freed memory until it is reused, because CoreFoundation offers no call that wipes a `CFData` before releasing it.
The Linux and Windows stubs wipe the buffer before freeing it.

## Usage

The test below stores a secret, reads it back, lists the accounts of its service, and removes it again.
Every operation raises `KeyringError`, which tells a machine without a reachable store (`NoStore`) apart from a store that rejected the request (`Refused`).
The package supports only the native target, so a consumer has to build for it as well.

The block is skipped by `moon test` because it would write to the credential store of whoever runs the tests, but `moon check` still compiles it.

```mbt check
///|
#skip("touches the OS credential store")
test "a secret round-trips through the credential store" {
  let service = "my-app"
  let account = "alice@example.com"
  try {
    @keyring.set(service~, account~, secret="s3cret")
    match @keyring.get(service~, account~) {
      Some(secret) => println("found a secret of \{secret.length()} characters")
      None => println("nothing is stored for \{account}")
    }
    for stored in @keyring.list(service) {
      println(stored)
    }
    @keyring.delete(service~, account~)
  } catch {
    NoStore(message) => println("no credential store: \{message}")
    Refused(code) => println("the store refused the operation: \{code}")
  }
}
```
