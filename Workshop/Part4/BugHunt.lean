import Workshop.Part4.Translation

/-!
# Part 4 — Bug hunt

Slides: Part 4, "🐞 Bug hunt".

`transfer_unchecked` in `rust/src/lib.rs` computes `to_bal + amount` directly.
Its unit tests pass. Let's try to prove it never panics.

1. Uncomment the attempt below and put your cursor at the end of the proof.
   One goal is left. Read its hypotheses: which inputs make it impossible to
   prove? That is a concrete input on which the Rust code panics.
2. Check your counterexample with `#eval transfer_unchecked ...`.
3. Prove the version with a precondition below.

Solution: `Solutions/Part4/BugHunt.lean`.
-/

namespace Workshop.Rust.BugHunt

open Workshop.Rust Result

/-
theorem transfer_unchecked_no_panic (fromBal toBal amount : U64) :
    transfer_unchecked fromBal toBal amount ≠ panic := by
  unfold transfer_unchecked U64.sub U64.add
  by_cases h1 : amount.val ≤ fromBal.val <;>
    by_cases h2 : toBal.val + amount.val < 2^64 <;> simp [h1, h2]
-/

/-- ⭐ The fix, as a precondition: it is safe whenever the receiver
cannot overflow. -/
theorem transfer_unchecked_safe (fromBal toBal amount : U64)
    (h : toBal.val + amount.val < 2^64) :
    transfer_unchecked fromBal toBal amount ≠ panic := by
  sorry

end Workshop.Rust.BugHunt
