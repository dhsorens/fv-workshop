import Workshop.Part2.Basics

/-! Solutions to `Workshop/Part2/Exercises.lean`. -/

namespace Workshop.Part2.Solutions

open Workshop.Part2

theorem ex1 : totalSupply (mint [] 7) = 7 := by
  rfl

theorem ex2 (b₁ b₂ : Nat) : totalSupply [b₁, b₂] = b₂ + b₁ := by
  simp only [totalSupply]
  omega

theorem ex3 (bs : List Nat) (x y : Nat) :
    totalSupply (mint (mint bs x) y) = totalSupply bs + x + y := by
  rw [totalSupply_mint, totalSupply_mint]

theorem ex4 (n x : Nat) : totalSupply (List.replicate n x) = n * x := by
  induction n with
  | zero => simp [totalSupply]
  | succ n ih =>
    simp only [List.replicate_succ, totalSupply, ih, Nat.succ_mul]
    omega

end Workshop.Part2.Solutions
