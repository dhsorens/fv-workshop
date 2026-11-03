/-!
# Part 3 — Verifying a model of `transfer`

Slides: Part 3, "A token transfer, in Lean" and "Conservation of supply".

Before we look at Rust, we write the transfer we *mean* in Lean, on
unbounded natural numbers. Later we prove the same properties about
the real Rust code, where integers are 64 bits and can overflow.
-/

namespace Workshop.Part3

/-- Move `amount` from the sender's balance to the receiver's.
Fails (returns `none`) if the sender cannot afford it. -/
def transfer (fromBal toBal amount : Nat) : Option (Nat × Nat) :=
  if amount ≤ fromBal then
    some (fromBal - amount, toBal + amount)
  else
    none

#eval transfer 100 5 30   -- some (70, 35)
#eval transfer 10 5 30    -- none

/-- **Conservation of supply.** A successful transfer neither creates nor
destroys tokens. -/
theorem transfer_conserves {fromBal toBal amount newFrom newTo : Nat}
    (h : transfer fromBal toBal amount = some (newFrom, newTo)) :
    newFrom + newTo = fromBal + toBal := by
  unfold transfer at h
  split at h
  · cases h
    omega
  · contradiction

/-- **Success.** If the sender can afford it, the transfer succeeds. -/
theorem transfer_succeeds {fromBal toBal amount : Nat} (h : amount ≤ fromBal) :
    transfer fromBal toBal amount = some (fromBal - amount, toBal + amount) := by
  simp [transfer, h]

end Workshop.Part3
