import Workshop.Part4.Translation

/-! Solutions to `Workshop/Part4/TakeHome/Arith.lean`. -/

namespace Workshop.Rust.Solutions

open Workshop.Rust Result

/-- The precondition: the sum must fit in 64 bits. -/
theorem add_spec (a b : U64) (h : a.val + b.val < 2^64) :
    ∃ c, add a b = ok c ∧ c.val = a.val + b.val := by
  unfold add U64.add
  simp [h]

theorem max_spec (a b : U64) :
    ∃ m, Rust.max a b = ok m ∧ m.val = Nat.max a.val b.val := by
  unfold Rust.max
  by_cases h : b.val ≤ a.val <;> simp [h, Nat.max_def] <;> omega

theorem saturating_sub_spec (a b : U64) :
    ∃ c, saturating_sub a b = ok c ∧ c.val = a.val - b.val := by
  unfold saturating_sub U64.sub
  by_cases h : b.val ≤ a.val <;> simp [h] <;> omega

theorem midpoint_spec (a b : U64) :
    ∃ m, midpoint a b = ok m ∧ m.val = (a.val + b.val) / 2 := by
  have := a.isLt
  have := b.isLt
  unfold midpoint U64.div U64.rem U64.add
  simp (disch := omega) [dif_pos]
  omega

end Workshop.Rust.Solutions
