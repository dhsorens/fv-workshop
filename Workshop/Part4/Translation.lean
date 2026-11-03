import Workshop.Part4.Prelude

/-!
# Part 4 — `rust/src/lib.rs`, translated to Lean

Slides: Part 4, "Translating Rust to Lean".

Each function below is a line-by-line, hand-written translation of the Rust
function of the same name. The rules:

* every Rust operation that can panic becomes a call from
  `Workshop/Part4/Prelude.lean` that returns a `Result`;
* `let x = e;` becomes `let x ← e`, which stops at the first panic;
* everything else (`if`, `match`, tuples, `Option`) stays as it is.

Writing this by hand is the step we *trust*: if the translation is wrong,
the proofs are about the wrong program. Tools such as Aeneas and hax
automate it.
-/

namespace Workshop.Rust

open Result

/-! ## Part 4: the running example -/

/-- `transfer` in `rust/src/lib.rs`. -/
def transfer (fromBal toBal amount : U64) :
    Result (Option (U64 × U64)) := do
  if amount ≤ fromBal then
    match U64.checkedAdd toBal amount with
    | some newTo =>
      let newFrom ← U64.sub fromBal amount
      return some (newFrom, newTo)
    | none => return none
  else
    return none

/-- `transfer_unchecked` in `rust/src/lib.rs`. -/
def transfer_unchecked (fromBal toBal amount : U64) :
    Result (Option (U64 × U64)) := do
  if amount ≤ fromBal then
    let newFrom ← U64.sub fromBal amount
    let newTo ← U64.add toBal amount
    return some (newFrom, newTo)
  else
    return none

/-! ## Take-home 1: arithmetic primitives -/

/-- `add` in `rust/src/lib.rs`. -/
def add (a b : U64) : Result U64 :=
  U64.add a b

/-- `max` in `rust/src/lib.rs`. (`protected`, so that it is written `Rust.max` and
does not clash with Lean's own `max`.) -/
protected def max (a b : U64) : Result U64 :=
  if a ≥ b then return a else return b

/-- `saturating_sub` in `rust/src/lib.rs`. -/
def saturating_sub (a b : U64) : Result U64 :=
  if a ≥ b then U64.sub a b else return 0

/-- `midpoint` in `rust/src/lib.rs`: `a / 2 + b / 2 + (a % 2 + b % 2) / 2`. -/
def midpoint (a b : U64) : Result U64 := do
  let x ← U64.div a 2
  let y ← U64.div b 2
  let xy ← U64.add x y
  let ra ← U64.rem a 2
  let rb ← U64.rem b 2
  let r ← U64.add ra rb
  let r2 ← U64.div r 2
  U64.add xy r2

/-! ## Take-home 2: 256-bit addition -/

/-- `U256` in `rust/src/lib.rs`: four 64-bit limbs, least significant first.
Rust's `[u64; 4]` is a `Vector U64 4`: an array whose length is part of its type,
so indexing it with `0`, `1`, `2` or `3` cannot go out of bounds. -/
structure U256 where
  limbs : Vector U64 4

/-- `adc` in `rust/src/lib.rs`. -/
def adc (a b carry : U64) : Result (U64 × U64) := do
  let ab ← U128.add (U64.toU128 a) (U64.toU128 b)
  let sum ← U128.add ab (U64.toU128 carry)
  return (U128.toU64 sum, U128.toU64 (U128.shr64 sum))

/-- `add_u256` in `rust/src/lib.rs`. -/
def add_u256 (a b : U256) : Result (U256 × U64) := do
  let (r0, c0) ← adc a.limbs[0] b.limbs[0] 0
  let (r1, c1) ← adc a.limbs[1] b.limbs[1] c0
  let (r2, c2) ← adc a.limbs[2] b.limbs[2] c1
  let (r3, c3) ← adc a.limbs[3] b.limbs[3] c2
  return ({ limbs := #v[r0, r1, r2, r3] }, c3)

end Workshop.Rust
