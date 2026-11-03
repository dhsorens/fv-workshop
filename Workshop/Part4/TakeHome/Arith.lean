import Workshop.Part4.Translation

/-!
# Take-home 1 — Arithmetic primitives

Not on the slides: a challenge to try after the workshop.

Specs for the small functions in `rust/src/lib.rs`. They are short, but
each one teaches something: preconditions, case splits, and why
"obviously correct" arithmetic needs checking.

`∃ c, f a b = ok c ∧ P c` means: running `f a b` does not panic, and its
result `c` satisfies `P c`.

Hints: `unfold` the function and the `U64` operations it uses. For a function
with an `if`, use `by_cases`. For a function with many steps, where every
step is safe, `simp (disch := omega) [dif_pos]` lets `simp` use `omega` to
decide each `if` inside the Rust operations.
Solutions: `Solutions/Part4/TakeHome/Arith.lean`.
-/

namespace Workshop.Rust.TakeHome

open Workshop.Rust Result

/-- ⭐ `add` panics on overflow, so this statement is *false* as written.
Add the precondition it needs as a hypothesis, then prove it. -/
theorem add_spec (a b : U64) :
    ∃ c, add a b = ok c ∧ c.val = a.val + b.val := by
  sorry

/-- ⭐ `max` returns the larger argument. (Hint: `Nat.max_def`.) -/
theorem max_spec (a b : U64) :
    ∃ m, Rust.max a b = ok m ∧ m.val = Nat.max a.val b.val := by
  sorry

/-- ⭐ `saturating_sub` never underflows. (On `Nat`, `-` already stops at 0.) -/
theorem saturating_sub_spec (a b : U64) :
    ∃ c, saturating_sub a b = ok c ∧ c.val = a.val - b.val := by
  sorry

/-- ⭐⭐ `midpoint` computes `(a + b) / 2` *without* overflowing, even for
`a = b = u64::MAX`, where `(a + b) / 2` in Rust would panic.
(Hint: `omega` needs to know that `a.val < 2^64`: that is `a.isLt`.) -/
theorem midpoint_spec (a b : U64) :
    ∃ m, midpoint a b = ok m ∧ m.val = (a.val + b.val) / 2 := by
  sorry

end Workshop.Rust.TakeHome
