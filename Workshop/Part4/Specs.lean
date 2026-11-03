import Workshop.Part4.Translation
import Workshop.Part3.Model

/-!
# Part 4 — Verifying the Rust `transfer`

Slides: Part 4, "Conservation, for the Rust code" through "The model and the code".

`Workshop/Part4/Translation.lean` translates `rust/src/lib.rs` to Lean by hand.
Every Rust function became a Lean function returning a `Result`: either
`ok v`, or `panic` when the Rust code would panic (here: on overflow).
-/

namespace Workshop.Rust

open Result

/-! ## Running the translated code -/

#eval transfer 100 5 30   -- ok (some (70, 35))
#eval transfer 10 5 30    -- ok none

-- The unchecked version panics when the receiver's balance overflows.
#eval transfer_unchecked 1 U64.MAX 1   -- panic

/-! ## Specifications

The recipe for every proof in this part:

1. `unfold` the function, and the Rust operations it uses (`U64.sub`, ...);
2. `by_cases` on each condition the code tests, so Lean considers every path;
3. `simp` with those cases, and `omega` for the arithmetic that is left. -/

/-- **Conservation of supply**, now for the Rust code: a successful
transfer preserves the sum of the two balances (compare Part 3). -/
theorem transfer_conserves {fromBal toBal amount newFrom newTo : U64}
    (h : transfer fromBal toBal amount = ok (some (newFrom, newTo))) :
    newFrom.val + newTo.val = fromBal.val + toBal.val := by
  unfold transfer U64.checkedAdd U64.sub at h
  by_cases h1 : amount.val ≤ fromBal.val <;>
    by_cases h2 : toBal.val + amount.val < 2^64 <;> simp [h1, h2] at h
  -- Only the path where both checks pass is left. `h` says what the outputs are.
  obtain ⟨rfl, rfl⟩ := h
  simp
  omega

/-- **The whole story** in one theorem: the Rust `transfer` never panics; if it
succeeds it conserves supply, and if it refuses, it had a good reason. -/
theorem transfer_spec (fromBal toBal amount : U64) :
    ∃ r, transfer fromBal toBal amount = ok r ∧
      match r with
      | some (newFrom, newTo) => newFrom.val + newTo.val = fromBal.val + toBal.val
      | none => fromBal.val < amount.val ∨ 2^64 ≤ toBal.val + amount.val := by
  unfold transfer U64.checkedAdd U64.sub
  by_cases h1 : amount.val ≤ fromBal.val <;>
    by_cases h2 : toBal.val + amount.val < 2^64 <;> simp [h1, h2] <;> omega

/-! ## The model and the code

The Lean model of Part 3 works with unbounded numbers. The Rust code
behaves exactly like the model, as long as the receiver's balance does not
overflow 64 bits. This theorem pins down precisely where they differ. -/

theorem transfer_refines_model (fromBal toBal amount : U64)
    (h : toBal.val + amount.val < 2^64) :
    ∃ r, transfer fromBal toBal amount = ok r ∧
      r.map (Prod.map U64.val U64.val) =
        Workshop.Part3.transfer fromBal.val toBal.val amount.val := by
  unfold transfer U64.checkedAdd U64.sub Workshop.Part3.transfer
  by_cases h1 : amount.val ≤ fromBal.val <;> simp [h1, h, and_assoc]

end Workshop.Rust
