# Combination test matrix

Use this checklist after installing `.XCompose`.

The goal is to verify the combinations that this project explicitly changes, while also checking the Portuguese characters expected from a US International keyboard.

## Brazilian Portuguese

| Keys | Expected |
|---|---|
| `' + a` | `á` |
| `' + A` | `Á` |
| `' + e` | `é` |
| `' + E` | `É` |
| `' + i` | `í` |
| `' + I` | `Í` |
| `' + o` | `ó` |
| `' + O` | `Ó` |
| `' + u` | `ú` |
| `' + U` | `Ú` |
| `' + c` | `ç` |
| `' + C` | `Ç` |
| `` ` + a `` | `à` |
| `` ` + A `` | `À` |
| `^ + a` | `â` |
| `^ + A` | `Â` |
| `^ + e` | `ê` |
| `^ + E` | `Ê` |
| `^ + o` | `ô` |
| `^ + O` | `Ô` |
| `~ + a` | `ã` |
| `~ + A` | `Ã` |
| `~ + o` | `õ` |
| `~ + O` | `Õ` |

## English apostrophe behavior

These combinations should produce a literal apostrophe followed by the consonant.

| Keys | Expected |
|---|---|
| `' + b` | `'b` |
| `' + d` | `'d` |
| `' + f` | `'f` |
| `' + g` | `'g` |
| `' + h` | `'h` |
| `' + j` | `'j` |
| `' + k` | `'k` |
| `' + l` | `'l` |
| `' + m` | `'m` |
| `' + n` | `'n` |
| `' + p` | `'p` |
| `' + q` | `'q` |
| `' + r` | `'r` |
| `' + s` | `'s` |
| `' + t` | `'t` |
| `' + v` | `'v` |
| `' + w` | `'w` |
| `' + x` | `'x` |
| `' + y` | `'y` |
| `' + z` | `'z` |

Test uppercase versions as well.

## Real-word sanity checks

Type these normally:

```text
I'm
it's
don't
we'll
John's

ação
coração
informação
você
também
português
São Paulo
```

## Environment notes

If a combination fails, record:

- Linux distribution and version
- desktop environment
- X11 or Wayland
- keyboard layout
- application name
- whether it works in another application

This helps distinguish an XCompose rule problem from an application/toolkit input-method issue.
