import Workshop.Part2.Basics

/-!
# Part 2 — A short tour of tactics

Slides: Part 2, "A handful of tactics goes a long way".

Each theorem below shows one tactic doing the main work.
A handful of tactics goes a long way.

| Tactic      | What it does                                             |
|-------------|----------------------------------------------------------|
| `rfl`       | both sides compute to the same value                     |
| `decide`    | decide a statement about concrete values by computation  |
| `simp`      | rewrite with known equations until the goal is solved    |
| `omega`     | linear arithmetic over `Nat` and `Int`                   |
| `intro`     | assume the hypothesis of an `→` / introduce a `∀`        |
| `cases`     | split on the possible shapes of a value or hypothesis    |
| `induction` | prove for all lists / numbers, one step at a time        |
| `grind`     | automation: combines rewriting, arithmetic and case splits |
-/

namespace Workshop.Part2

/-- `rfl`: the two sides are equal by computation. -/
theorem ex_rfl : totalSupply [1, 2, 3] = 6 := by
  rfl

/-- `decide`: a decidable statement about concrete values. -/
theorem ex_decide : ∀ n, n < 5 → n * n < 25 := by
  decide

/-- `simp`: rewrite with the defining equations of `totalSupply`. -/
theorem ex_simp (b : Nat) : totalSupply [b, 0, 0] = b := by
  simp [totalSupply]

/-- `omega`: linear arithmetic, including subtraction on `Nat`. -/
theorem ex_omega (balance amount : Nat) (h : amount ≤ balance) :
    balance - amount + amount = balance := by
  omega

/-- `intro`: to prove `P → Q`, assume `P` and prove `Q`. -/
theorem ex_intro : ∀ (a b : Nat), a ≤ b → a ≤ b + 1 := by
  intro a b h
  omega

/-- `cases`: an `Option` is either `none` or `some x`. -/
theorem ex_cases (o : Option Nat) : o.getD 0 = 0 ∨ o.isSome := by
  cases o with
  | none => simp
  | some x => simp

/-- `induction`: every balance is at most the total supply. -/
theorem ex_induction (bs : List Nat) (b : Nat) (h : b ∈ bs) :
    b ≤ totalSupply bs := by
  induction bs with
  | nil => simp at h
  | cons x xs ih =>
    simp only [List.mem_cons] at h
    simp only [totalSupply]
    cases h with
    | inl h => omega
    | inr h => have := ih h; omega

/-- `grind`: often finishes goals that need several of the above at once. -/
theorem ex_grind (a b : Nat) (h₁ : a ≤ b) (h₂ : b ≤ a) (f : Nat → Nat) :
    f a = f b := by
  grind

end Workshop.Part2
