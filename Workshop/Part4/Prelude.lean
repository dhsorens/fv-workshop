/-!
# Part 4 — What Rust's integers mean, in Lean

Slides: Part 4, "What a `u64` operation means".

To reason about Rust code in Lean, we first say what Rust's primitive
operations *do*. This file is that dictionary. `Workshop/Part4/Translation.lean`
then uses it to translate `rust/src/lib.rs` line by line.

Two things are new compared to the Lean model of Part 3:

* A Rust `u64` is a number below `2^64`, not an unbounded `Nat`.
* Rust arithmetic can **panic**. `a + b` panics on overflow and `a - b` on
  underflow (in debug builds; release builds silently wrap around, which is
  arguably worse). So an operation that may panic returns a `Result`.

Tools such as Aeneas and hax produce exactly this kind of translation
automatically, together with a library like this one.
-/

namespace Workshop.Rust

/-- The outcome of running Rust code: a value, or a panic. -/
inductive Result (α : Type) where
  | ok (v : α)
  | panic
  deriving Repr, DecidableEq

namespace Result

/-- Run `r`; if it produced a value, continue with `f`. A panic stops everything. -/
def bind {α β : Type} (r : Result α) (f : α → Result β) : Result β :=
  match r with
  | ok v => f v
  | panic => panic

/-- This instance is what makes `do` notation and `←` work for `Result`. -/
instance : Monad Result where
  pure := ok
  bind := bind

@[simp] theorem pure_eq {α : Type} (v : α) : (pure v : Result α) = ok v := rfl
@[simp] theorem ok_bind {α β : Type} (v : α) (f : α → Result β) :
    (ok v >>= f) = f v := rfl
@[simp] theorem panic_bind {α β : Type} (f : α → Result β) :
    ((panic : Result α) >>= f) = panic := rfl

end Result

open Result

/-! ## `u64` -/

/-- A Rust `u64`: a natural number together with a proof that it fits in 64 bits. -/
structure U64 where
  val : Nat
  isLt : val < 2^64
  deriving DecidableEq

namespace U64

instance : Repr U64 := ⟨fun a _ => repr a.val⟩

/-- Numerals like `30 : U64`. Out-of-range literals wrap around; we only write small ones. -/
instance (n : Nat) : OfNat U64 n := ⟨⟨n % 2^64, Nat.mod_lt _ (by decide)⟩⟩

@[simp] theorem val_ofNat (n : Nat) : (no_index (OfNat.ofNat n : U64)).val = n % 2^64 := rfl

/-- Rust compares `u64`s as numbers. -/
instance : LE U64 := ⟨fun a b => a.val ≤ b.val⟩
instance : LT U64 := ⟨fun a b => a.val < b.val⟩
instance (a b : U64) : Decidable (a ≤ b) := inferInstanceAs (Decidable (a.val ≤ b.val))
instance (a b : U64) : Decidable (a < b) := inferInstanceAs (Decidable (a.val < b.val))

@[simp] theorem le_iff (a b : U64) : a ≤ b ↔ a.val ≤ b.val := Iff.rfl
@[simp] theorem lt_iff (a b : U64) : a < b ↔ a.val < b.val := Iff.rfl

/-- Rust's `u64::MAX`. -/
def MAX : U64 := ⟨2^64 - 1, by decide⟩

/-- Rust's `a + b` on `u64`: panics if the sum does not fit in 64 bits. -/
def add (a b : U64) : Result U64 :=
  if h : a.val + b.val < 2^64 then ok ⟨a.val + b.val, h⟩ else panic

/-- Rust's `a - b` on `u64`: panics if the result would be negative. -/
def sub (a b : U64) : Result U64 :=
  if b.val ≤ a.val then ok ⟨a.val - b.val, by have := a.isLt; omega⟩ else panic

/-- Rust's `a / b` on `u64`: panics on division by zero. -/
def div (a b : U64) : Result U64 :=
  if b.val = 0 then panic
  else ok ⟨a.val / b.val, Nat.lt_of_le_of_lt (Nat.div_le_self _ _) a.isLt⟩

/-- Rust's `a % b` on `u64`: panics on division by zero. -/
def rem (a b : U64) : Result U64 :=
  if h : b.val = 0 then panic
  else ok ⟨a.val % b.val, Nat.lt_trans (Nat.mod_lt _ (by omega)) b.isLt⟩

/-- Rust's `a.checked_add(b)`: never panics, returns `None` on overflow. -/
def checkedAdd (a b : U64) : Option U64 :=
  if h : a.val + b.val < 2^64 then some ⟨a.val + b.val, h⟩ else none

end U64

/-! ## `u128` -/

/-- A Rust `u128`: a natural number that fits in 128 bits. -/
structure U128 where
  val : Nat
  isLt : val < 2^128

namespace U128

/-- Rust's `a + b` on `u128`: panics if the sum does not fit in 128 bits. -/
def add (a b : U128) : Result U128 :=
  if h : a.val + b.val < 2^128 then ok ⟨a.val + b.val, h⟩ else panic

/-- Rust's `a >> 64` on `u128`: shifting right by 64 bits divides by `2^64`. -/
def shr64 (a : U128) : U128 :=
  ⟨a.val / 2^64, Nat.lt_of_le_of_lt (Nat.div_le_self _ _) a.isLt⟩

/-- Rust's `a as u64`: keeps the low 64 bits (the remainder mod `2^64`). Never panics. -/
def toU64 (a : U128) : U64 :=
  ⟨a.val % 2^64, Nat.mod_lt _ (by decide)⟩

end U128

/-- Rust's `a as u128`: always fits. -/
def U64.toU128 (a : U64) : U128 :=
  ⟨a.val, Nat.lt_trans a.isLt (by decide)⟩

end Workshop.Rust
