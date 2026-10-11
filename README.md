# xcompose-ptbr-us-intl

A small `.XCompose` configuration for Linux users who type in both **Brazilian Portuguese** and **English** on a **US International keyboard**.

The goal is to keep the normal system Compose rules while fixing a few behaviors that are inconvenient for a PT-BR/English workflow.

## What it fixes

The most important rule is:

```text
' + c  →  ç
' + C  →  Ç
```

It also explicitly supports the characters used in modern Brazilian Portuguese:

| Keys | Result |
|---|---|
| `' + a/e/i/o/u` | á é í ó ú |
| `` ` + a `` | à |
| `^ + a/e/o` | â ê ô |
| `~ + a/o` | ã õ |
| `' + c` | ç |

Uppercase versions are included as well.

## English-friendly apostrophe behavior

On some Linux Compose tables, the apostrophe key configured as `dead_acute` can combine with consonants and produce characters that are rarely useful in a Portuguese/English workflow.

This configuration makes consonant combinations behave as a literal apostrophe plus the letter.

Examples:

```text
' + m  →  'm
' + s  →  's
' + t  →  't
' + n  →  'n
```

That makes normal English contractions comfortable to type:

```text
I'm
it's
don't
we'll
John's
```

The exception is `c`, which intentionally produces `ç`.

## Design

The file starts with:

```text
include "%L"
```

This means the system's existing Compose table remains available. The project only overrides combinations that are useful for Brazilian Portuguese and bilingual Portuguese/English typing.

This keeps the configuration smaller and easier to audit than replacing the entire Compose table.

## Installation

Clone the repository:

```bash
git clone https://github.com/dbmello75/xcompose-ptbr-us-intl.git
cd xcompose-ptbr-us-intl
```

Copy the configuration to your home directory:

```bash
cp .XCompose ~/.XCompose
```

Then log out of your graphical session and log back in.

If your desktop environment does not automatically load `~/.XCompose`, add this to `~/.profile`:

```bash
export XCOMPOSEFILE="$HOME/.XCompose"
```

and log out/in again.

## Updating

From the cloned repository:

```bash
git pull
cp .XCompose ~/.XCompose
```

## Testing

Try these combinations after logging in again:

```text
' + a   → á
' + e   → é
' + c   → ç
~ + a   → ã
~ + o   → õ
^ + a   → â
^ + e   → ê
^ + o   → ô
` + a   → à
' + m   → 'm
' + s   → 's
```

## Compatibility

XCompose behavior can vary between desktop environments and application toolkits.

The configuration is intended for Linux systems using an XCompose-compatible input stack. Applications running through X11, Wayland, GTK, Qt, Chromium/Electron, or an input-method framework may not all consume Compose rules in exactly the same way.

If you find an application or desktop environment where a rule does not work, please open an issue and include:

- Linux distribution and version
- desktop environment
- X11 or Wayland
- keyboard layout
- application where the problem occurs

## Similar projects

This project follows the same general idea as other community XCompose configurations for bilingual PT-BR/US-International users, while intentionally keeping the file small and relying on the system Compose table wherever possible.

## License

MIT License. See [LICENSE](LICENSE).
