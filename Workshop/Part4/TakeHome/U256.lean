import Workshop.Part4.Translation

/-!
# Take-home 2 — 256-bit addition

Not on the slides: a challenge to try after the workshop.

The EVM computes on 256-bit words, but CPUs (and many ZK proof systems)
work with 64-bit limbs. So every EVM implementation, and every zkEVM,
contains code like `add_u256` in `rust/src/lib.rs`: add limb by limb,
propagating a carry. A bug here is a consensus bug.

Prove that the limb-wise algorithm really is 256-bit addition.
Solutions: `Solutions/Part4/TakeHome/U256.lean`.
-/

namespace Workshop.Rust.TakeHome

open Workshop.Rust Result

/-- The number that four little-endian 64-bit limbs represent. -/
def U256.toNat (x : U256) : Nat :=
  x.limbs[0].val + 2^64 * x.limbs[1].val + 2^128 * x.limbs[2].val + 2^192 * x.limbs[3].val

/-- ⭐⭐ Add-with-carry on one limb: the low limb plus `2^64` times the carry-out
is the true sum, and the carry-out is again 0 or 1.

Hint: `unfold adc U128.add U64.toU128 U128.toU64 U128.shr64`, then
`simp (disch := omega) [dif_pos, and_assoc]` and `omega`. Both `omega`s need
to know that `a.val < 2^64` and `b.val < 2^64`: add them with `have := a.isLt`. -/
theorem adc_spec (a b c : U64) (hc : c.val ≤ 1) :
    ∃ r c', adc a b c = ok (r, c') ∧
      r.val + 2^64 * c'.val = a.val + b.val + c.val ∧ c'.val ≤ 1 := by
  sorry

/-- ⭐⭐⭐ The result plus `2^256` times the final carry is the true sum.
In other words, `add_u256` is addition modulo `2^256` with an overflow flag.

Hint: you can use `adc_spec` even before you have proved it. Use it four
times, once per limb, e.g.
`obtain ⟨r0, c0, h0, e0, hc0⟩ := adc_spec a.limbs[0] b.limbs[0] 0 (by simp)`.
Then `unfold add_u256`, `simp [h0, h1, h2, h3, U256.toNat, and_assoc]`,
and finish with `omega`. -/
theorem add_u256_spec (a b : U256) :
    ∃ r c, add_u256 a b = ok (r, c) ∧
      U256.toNat r + 2^256 * c.val = U256.toNat a + U256.toNat b := by
  sorry

/-! ⭐⭐⭐⭐ Go further: add `sbb` (subtract with borrow) and `sub_u256` to
`rust/src/lib.rs`, translate them to Lean in the style of
`Workshop/Part4/Translation.lean`, and prove them correct. -/

end Workshop.Rust.TakeHome
