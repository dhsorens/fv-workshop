import Workshop.Part4.Translation

/-! Solutions to `Workshop/Part4/BugHunt.lean`.

The attempt leaves one goal, with the hypothesis
`h2 : ¬toBal.val + amount.val < 2 ^ 64`: it fails whenever the receiver's
balance plus the amount does not fit in 64 bits. For example,
`transfer_unchecked 1 U64.MAX 1` panics. -/

namespace Workshop.Rust.Solutions

open Workshop.Rust Result

#eval transfer_unchecked 1 U64.MAX 1   -- panic

theorem transfer_unchecked_safe (fromBal toBal amount : U64)
    (h : toBal.val + amount.val < 2^64) :
    transfer_unchecked fromBal toBal amount ≠ panic := by
  unfold transfer_unchecked U64.sub U64.add
  by_cases h1 : amount.val ≤ fromBal.val <;> simp [h1, h]

end Workshop.Rust.Solutions
