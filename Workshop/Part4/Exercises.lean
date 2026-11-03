import Workshop.Part4.Translation

/-!
# Part 4 — Exercises

Slides: Part 4, "💻 Your turn".

The recipe, as in `Workshop/Part4/Specs.lean`:
`unfold transfer U64.checkedAdd U64.sub`, then `by_cases` on the two
conditions the code tests (`amount.val ≤ fromBal.val` and
`toBal.val + amount.val < 2^64`), then `simp [h1, h2]` and `omega`.
Solutions: `Solutions/Part4/Exercises.lean`.
-/

namespace Workshop.Rust.Exercises

open Workshop.Rust Result

/-- ⭐ Core. `transfer` never panics, on any input. -/
theorem transfer_no_panic (fromBal toBal amount : U64) :
    transfer fromBal toBal amount ≠ panic := by
  sorry

/-- ⭐ Core. The transfer fails exactly when the sender cannot afford it,
or the receiver's balance would overflow. -/
theorem transfer_fails_iff (fromBal toBal amount : U64) :
    transfer fromBal toBal amount = ok none ↔
      (fromBal.val < amount.val ∨ 2^64 ≤ toBal.val + amount.val) := by
  sorry

/-- ⭐⭐ Stretch: *write the spec yourself*.
State and prove: if the transfer succeeds, the sender's new balance is
`fromBal.val - amount.val` and the receiver's is `toBal.val + amount.val`.
Replace `True` with your statement. -/
theorem transfer_balances {fromBal toBal amount newFrom newTo : U64}
    (h : transfer fromBal toBal amount = ok (some (newFrom, newTo))) :
    True := by
  sorry

end Workshop.Rust.Exercises
