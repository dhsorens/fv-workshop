/-!
# Part 2 — Programs and proofs in Lean

Slides: Part 2, "Lean is a programming language" through "Induction: for all lists".

Lean is a functional programming language *and* a proof assistant.
We write ordinary programs, then state and prove facts about them in the same file.
-/

namespace Workshop.Part2

/-! ## Programs

Balances are a list of natural numbers, one per account. -/

/-- The total supply is the sum of all balances. -/
def totalSupply : List Nat → Nat
  | [] => 0
  | b :: bs => b + totalSupply bs

/-- Mint `amount` new tokens into a fresh account. -/
def mint (balances : List Nat) (amount : Nat) : List Nat :=
  amount :: balances

-- Run code with `#eval`; the result appears in the infoview.
#eval totalSupply [10, 20, 12]
#eval totalSupply (mint [10, 20, 12] 100)

/-! ## Statements and proofs

A `theorem` states a proposition. Everything after `:= by` is a proof,
built step by step with *tactics*. Put your cursor inside the proof and
watch the goal change in the infoview. -/

/-- A concrete fact: Lean checks it by computing both sides. -/
theorem supply_example : totalSupply [10, 20, 12] = 42 := by
  rfl

/-- A fact about *every* list of balances and *every* amount. -/
theorem totalSupply_mint (balances : List Nat) (amount : Nat) :
    totalSupply (mint balances amount) = totalSupply balances + amount := by
  simp only [mint, totalSupply]
  omega

/-- Facts about *all* lists usually need induction: prove it for `[]`,
then for `b :: bs` assuming it holds for `bs`. -/
theorem totalSupply_append (xs ys : List Nat) :
    totalSupply (xs ++ ys) = totalSupply xs + totalSupply ys := by
  induction xs with
  | nil => simp [totalSupply]
  | cons x xs ih =>
    simp only [List.cons_append, totalSupply, ih]
    omega

end Workshop.Part2
