import Workshop.Part3.Model

/-!
# Part 5 — Where the guarantee ends

Slides: Part 5, "What a proof does not tell you" and "Check what a proof rests on".

A proof only establishes the statement that was proved. Lean checks the
proof; *you* still have to check the statement.
-/

namespace Workshop.Part5.Limits

/-! ## A proved, but useless, specification

This "transfer" ignores its inputs and returns `none`.
The theorem below is true and fully proved, and says nothing useful:
a spec that only talks about the success case is satisfied vacuously by
a function that never succeeds. -/

def brokenTransfer (_fromBal _toBal _amount : Nat) : Option (Nat × Nat) :=
  none

theorem brokenTransfer_conserves {fromBal toBal amount newFrom newTo : Nat}
    (h : brokenTransfer fromBal toBal amount = some (newFrom, newTo)) :
    newFrom + newTo = fromBal + toBal := by
  simp [brokenTransfer] at h

/-! ## Check what a proof rests on

`#print axioms` lists everything a theorem depends on beyond Lean's logic.
A finished proof shows only Lean's standard axioms. -/

#print axioms Workshop.Part3.transfer_conserves

/-- An unfinished proof is accepted with a warning, but `#print axioms`
reveals `sorryAx`. Look for it before trusting a result. -/
theorem trust_me : 1 = 2 := by
  sorry

#print axioms trust_me

end Workshop.Part5.Limits
