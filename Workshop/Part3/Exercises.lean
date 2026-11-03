import Workshop.Part3.Model

/-!
# Part 3 — Exercises

Slides: Part 3, "💻 Your turn".

Replace each `sorry` with a proof.
A good first move is `unfold transfer` (add `at h` for a hypothesis),
then `split` to consider both branches of the `if`.
Solutions: `Solutions/Part3.lean`.
-/

namespace Workshop.Part3.Exercises

open Workshop.Part3

/-- ⭐ Core. A transfer fails exactly when the sender cannot afford it. -/
theorem transfer_fails_iff (fromBal toBal amount : Nat) :
    transfer fromBal toBal amount = none ↔ fromBal < amount := by
  sorry

/-- ⭐⭐ Stretch. The receiver gets exactly `amount`. -/
theorem transfer_receiver {fromBal toBal amount newFrom newTo : Nat}
    (h : transfer fromBal toBal amount = some (newFrom, newTo)) :
    newTo = toBal + amount := by
  sorry

/-- ⭐⭐ Stretch. Transferring zero changes nothing. -/
theorem transfer_zero (fromBal toBal : Nat) :
    transfer fromBal toBal 0 = some (fromBal, toBal) := by
  sorry

end Workshop.Part3.Exercises
