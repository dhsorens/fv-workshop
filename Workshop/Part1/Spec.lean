/-!
# Part 1 — What is formal verification?

Slides: Part 1, "Tests check some inputs" and "Proofs cover all inputs".

A *test* checks a program on the inputs you thought of.
A *specification* is a precise statement about *all* inputs,
and a *proof* is a machine-checked argument that the program meets it.
-/

namespace Workshop.Part1

/-- The implementation: the larger of two numbers. -/
def max (a b : Nat) : Nat :=
  if a ≤ b then b else a

/-! ## Tests: some inputs -/

#guard max 3 5 == 5
#guard max 5 3 == 5
#guard max 4 4 == 4

/-! ## A specification: all inputs

`max a b` is at least as big as both arguments, and it is one of them. -/
theorem max_spec (a b : Nat) :
    a ≤ max a b ∧ b ≤ max a b ∧ (max a b = a ∨ max a b = b) := by
  unfold max
  split <;> omega

end Workshop.Part1
