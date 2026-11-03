import Workshop.Part2.Basics

/-!
# Part 2 — Exercises

Slides: Part 2, "💻 Your turn".

Replace each `sorry` with a proof. The infoview shows the current goal.
Solutions: `Solutions/Part2.lean`.
-/

namespace Workshop.Part2.Exercises

open Workshop.Part2

/-- ⭐ Core. Hint: `rfl` or `decide`. -/
theorem ex1 : totalSupply (mint [] 7) = 7 := by
  sorry

/-- ⭐ Core. Hint: unfold the definitions, then `omega`. -/
theorem ex2 (b₁ b₂ : Nat) : totalSupply [b₁, b₂] = b₂ + b₁ := by
  sorry

/-- ⭐⭐ Stretch. Minting twice adds both amounts. Hint: reuse `totalSupply_mint`. -/
theorem ex3 (bs : List Nat) (x y : Nat) :
    totalSupply (mint (mint bs x) y) = totalSupply bs + x + y := by
  sorry

/-- ⭐⭐⭐ Take-home. `n` accounts holding `x` each. Hint: `induction n`. -/
theorem ex4 (n x : Nat) : totalSupply (List.replicate n x) = n * x := by
  sorry

end Workshop.Part2.Exercises
