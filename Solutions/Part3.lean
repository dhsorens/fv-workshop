import Workshop.Part3.Model

/-! Solutions to `Workshop/Part3/Exercises.lean`. -/

namespace Workshop.Part3.Solutions

open Workshop.Part3

theorem transfer_fails_iff (fromBal toBal amount : Nat) :
    transfer fromBal toBal amount = none ↔ fromBal < amount := by
  unfold transfer
  split <;> simp <;> omega

theorem transfer_receiver {fromBal toBal amount newFrom newTo : Nat}
    (h : transfer fromBal toBal amount = some (newFrom, newTo)) :
    newTo = toBal + amount := by
  unfold transfer at h
  split at h
  · cases h
    rfl
  · contradiction

theorem transfer_zero (fromBal toBal : Nat) :
    transfer fromBal toBal 0 = some (fromBal, toBal) := by
  simp [transfer]

end Workshop.Part3.Solutions
