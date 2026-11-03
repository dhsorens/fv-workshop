import Workshop.Part4.Translation

/-! Solutions to `Workshop/Part4/Exercises.lean`. -/

namespace Workshop.Rust.Solutions

open Workshop.Rust Result

theorem transfer_no_panic (fromBal toBal amount : U64) :
    transfer fromBal toBal amount ≠ panic := by
  unfold transfer U64.checkedAdd U64.sub
  by_cases h1 : amount.val ≤ fromBal.val <;>
    by_cases h2 : toBal.val + amount.val < 2^64 <;> simp [h1, h2]

theorem transfer_fails_iff (fromBal toBal amount : U64) :
    transfer fromBal toBal amount = ok none ↔
      (fromBal.val < amount.val ∨ 2^64 ≤ toBal.val + amount.val) := by
  unfold transfer U64.checkedAdd U64.sub
  by_cases h1 : amount.val ≤ fromBal.val <;>
    by_cases h2 : toBal.val + amount.val < 2^64 <;> simp [h1, h2] <;> omega

theorem transfer_balances {fromBal toBal amount newFrom newTo : U64}
    (h : transfer fromBal toBal amount = ok (some (newFrom, newTo))) :
    newFrom.val = fromBal.val - amount.val ∧ newTo.val = toBal.val + amount.val := by
  unfold transfer U64.checkedAdd U64.sub at h
  by_cases h1 : amount.val ≤ fromBal.val <;>
    by_cases h2 : toBal.val + amount.val < 2^64 <;> simp [h1, h2] at h
  obtain ⟨rfl, rfl⟩ := h
  simp

end Workshop.Rust.Solutions
