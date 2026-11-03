import Workshop.Part4.Translation

/-! Solutions to `Workshop/Part4/TakeHome/U256.lean`. -/

namespace Workshop.Rust.Solutions

open Workshop.Rust Result

/-- The number that four little-endian 64-bit limbs represent. -/
def U256.toNat (x : U256) : Nat :=
  x.limbs[0].val + 2^64 * x.limbs[1].val + 2^128 * x.limbs[2].val + 2^192 * x.limbs[3].val

theorem adc_spec (a b c : U64) (hc : c.val ≤ 1) :
    ∃ r c', adc a b c = ok (r, c') ∧
      r.val + 2^64 * c'.val = a.val + b.val + c.val ∧ c'.val ≤ 1 := by
  have := a.isLt
  have := b.isLt
  unfold adc U128.add U64.toU128 U128.toU64 U128.shr64
  simp (disch := omega) [dif_pos, and_assoc]
  omega

theorem add_u256_spec (a b : U256) :
    ∃ r c, add_u256 a b = ok (r, c) ∧
      U256.toNat r + 2^256 * c.val = U256.toNat a + U256.toNat b := by
  obtain ⟨r0, c0, h0, e0, hc0⟩ := adc_spec a.limbs[0] b.limbs[0] 0 (by simp)
  obtain ⟨r1, c1, h1, e1, hc1⟩ := adc_spec a.limbs[1] b.limbs[1] c0 hc0
  obtain ⟨r2, c2, h2, e2, hc2⟩ := adc_spec a.limbs[2] b.limbs[2] c1 hc1
  obtain ⟨r3, c3, h3, e3, -⟩ := adc_spec a.limbs[3] b.limbs[3] c2 hc2
  unfold add_u256
  simp [h0, h1, h2, h3, U256.toNat, and_assoc]
  simp at e0
  omega

end Workshop.Rust.Solutions
