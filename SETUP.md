# Setup and troubleshooting

## What gets installed

| Thing | Why | Size |
|---|---|---|
| [elan](https://lean-lang.org/install/) | Lean's version manager; installs the exact Lean version this repo needs (`lean-toolchain`) | ~200 MB per Lean version |
| VS Code + the *Lean 4* extension | Editor with the Lean *infoview*, where proof goals appear | |

That's all. The workshop uses only Lean itself: no Mathlib, and no Rust
tooling (the Rust code in `rust/` is there to read, not to build).

## Step by step

```bash
# 1. Lean (macOS / Linux). Windows: see https://lean-lang.org/install/
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
# open a new terminal so that `lake` is on your PATH

# 2. The workshop
git clone https://github.com/dhsorens/fv-workshop
cd fv-workshop
scripts/check-setup.sh
```

Then open the **`fv-workshop` folder** (not a single file) in VS Code.

## Troubleshooting

**The infoview doesn't appear.** Open a `.lean` file, then Cmd/Ctrl+Shift+P →
*Lean 4: Infoview: Display Goal*.

**"Imports are out of date" in VS Code.** Click *Restart File* in the infoview,
or run `lake build` in a terminal.

**The first build is slow.** The first run downloads Lean itself (a few hundred
MB). After that, `lake build` takes seconds.

**Nothing works.** Use [live.lean-lang.org](https://live.lean-lang.org): paste
in the contents of a file from `Workshop/`. For `Workshop/Part4/` files, first
paste `Prelude.lean` and `Translation.lean` (without their `import` lines).
