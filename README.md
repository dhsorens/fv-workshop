# Formal Verification in Lean: a hands-on introduction

A one-hour workshop for developers who are curious about formal verification.
You will learn what formal verification does (and does not) guarantee, write
your first proofs in [Lean](https://lean-lang.org), and verify real Rust code.
No prior knowledge of Lean or formal verification is assumed, and you can work
through everything on your own.

**Slides:** open [`deck/index.html`](deck/index.html) in a browser (no install
needed). Use ← → to move between parts and ↑ ↓ within a part.

## Set up (5–10 minutes)

If you're coming to the workshop, please do this *before* you arrive.

1. Install [VS Code](https://code.visualstudio.com) and its **Lean 4** extension.
2. Install Lean's version manager, elan: <https://lean-lang.org/install/>
3. Clone this repository and check your setup:

   ```bash
   git clone https://github.com/dhsorens/fv-workshop
   cd fv-workshop
   scripts/check-setup.sh
   ```

   This downloads Lean and builds the workshop. Nothing else is needed: no
   Mathlib, and no Rust tooling.
4. Open the `fv-workshop` folder in VS Code, open `Workshop/Part2/Basics.lean`,
   and check that the *Lean Infoview* panel shows `42` next to `#eval`.

Problems? See [SETUP.md](SETUP.md).

## Working through it

Each file is short and says which slides it goes with. Read it with the
infoview open: put your cursor inside a proof to see the goal change.

| Part | Read | Then do |
|---|---|---|
| 1. What is formal verification? | `Workshop/Part1/Spec.lean` | |
| 2. Programs and proofs in Lean | `Workshop/Part2/Basics.lean`, `Tactics.lean` | `Workshop/Part2/Exercises.lean` |
| 3. A token transfer, as a Lean model | `Workshop/Part3/Model.lean` | `Workshop/Part3/Exercises.lean` |
| 4. The same transfer, in Rust | [`rust/src/lib.rs`](rust/src/lib.rs), then `Workshop/Part4/Prelude.lean`, `Translation.lean`, `Specs.lean` | `Workshop/Part4/Exercises.lean`, `BugHunt.lean` |
| 5. Where the guarantee ends | `Workshop/Part5/Limits.lean` | |
| Afterwards | | `Workshop/Part4/TakeHome/` |

In Part 4, `Translation.lean` is a hand-written, line-by-line Lean translation
of the Rust code. `Prelude.lean` says what Rust's integer operations mean,
including when they panic. Tools such as Aeneas and hax produce this kind of
translation automatically.

### Exercises

Exercises are theorems whose proof is `sorry` (Lean for "proof missing").
Replace each `sorry` with a proof. Each file starts with hints.

- ⭐ core
- ⭐⭐ stretch
- ⭐⭐⭐ take-home

Every exercise has a solution in `Solutions/`, in a file with the same name.
The take-homes are two longer challenges: arithmetic primitives (including an
overflow-free `midpoint`), and 256-bit addition on 64-bit limbs, as in every EVM
implementation.

## Repository layout

```
deck/        the slides, built (open deck/index.html)
Workshop/    the workshop, one folder per part; plain Lean, no dependencies
Solutions/   solutions to every exercise
rust/        the Rust code verified in Part 4 (to read; no need to build it)
scripts/     setup check, and the warning check used by CI
```

## Further resources

- [Functional Programming in Lean](https://lean-lang.org/functional_programming_in_lean/):
  Lean as a programming language
- [Theorem Proving in Lean 4](https://lean-lang.org/theorem_proving_in_lean4/):
  Lean as a proof assistant
- [The Natural Number Game](https://adam.math.hhu.de/#/g/leanprover-community/nng4):
  learn tactics by proving facts about numbers, in the browser
- [Lean documentation](https://lean-lang.org/documentation/): manuals, tutorials and references
- [Aeneas](https://github.com/AeneasVerif/aeneas) and [hax](https://github.com/cryspen/hax):
  translating real Rust code to Lean automatically
- [Lean Zulip](https://leanprover.zulipchat.com): the Lean community, very
  welcoming to beginners (try the `#new members` channel)
