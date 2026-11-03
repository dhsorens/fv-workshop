//! The Rust code we verify in the workshop.
//!
//! `Workshop/Part4/Translation.lean` is a hand-written, line-by-line translation
//! of this file to Lean, and the rest of `Workshop/Part4/` proves things about it.
//! You don't need Rust installed: this file is here to read side by side.

// ---------------------------------------------------------------------------
// Part 3b: the running example
// ---------------------------------------------------------------------------

/// Move `amount` from the sender's balance to the receiver's.
///
/// Returns `None` if the sender cannot afford it, or if the receiver's
/// balance would overflow.
pub fn transfer(
    from_bal: u64,
    to_bal: u64,
    amount: u64,
) -> Option<(u64, u64)> {
    if amount <= from_bal {
        match to_bal.checked_add(amount) {
            Some(new_to) => {
                let new_from = from_bal - amount;
                Some((new_from, new_to))
            }
            None => None,
        }
    } else {
        None
    }
}

/// The same transfer, written the "obvious" way. It looks fine, and its
/// tests pass. Can you prove it never panics?
pub fn transfer_unchecked(from_bal: u64, to_bal: u64, amount: u64) -> Option<(u64, u64)> {
    if amount <= from_bal {
        let new_from = from_bal - amount;
        let new_to = to_bal + amount;
        Some((new_from, new_to))
    } else {
        None
    }
}

// ---------------------------------------------------------------------------
// Take-home 1: arithmetic primitives
// ---------------------------------------------------------------------------

/// Panics if the sum overflows.
pub fn add(a: u64, b: u64) -> u64 {
    a + b
}

/// The larger of two numbers.
pub fn max(a: u64, b: u64) -> u64 {
    if a >= b {
        a
    } else {
        b
    }
}

/// Subtraction that stops at zero instead of underflowing.
pub fn saturating_sub(a: u64, b: u64) -> u64 {
    if a >= b {
        a - b
    } else {
        0
    }
}

/// The midpoint of `a` and `b`, rounded down, without overflowing.
/// (`(a + b) / 2` overflows for large inputs: a classic binary-search bug.)
pub fn midpoint(a: u64, b: u64) -> u64 {
    a / 2 + b / 2 + (a % 2 + b % 2) / 2
}

// ---------------------------------------------------------------------------
// Take-home 2: 256-bit addition, as in the EVM and in ZK circuits
// ---------------------------------------------------------------------------

/// A 256-bit unsigned integer as four 64-bit limbs, least significant first.
#[derive(Clone, Copy)]
pub struct U256 {
    pub limbs: [u64; 4],
}

/// Add two limbs and an incoming carry (0 or 1).
/// Returns the low 64 bits of the sum and the outgoing carry (0 or 1).
pub fn adc(a: u64, b: u64, carry: u64) -> (u64, u64) {
    let sum = (a as u128) + (b as u128) + (carry as u128);
    (sum as u64, (sum >> 64) as u64)
}

/// Add two 256-bit numbers. Returns the sum modulo 2^256 and the final carry.
pub fn add_u256(a: U256, b: U256) -> (U256, u64) {
    let (r0, c0) = adc(a.limbs[0], b.limbs[0], 0);
    let (r1, c1) = adc(a.limbs[1], b.limbs[1], c0);
    let (r2, c2) = adc(a.limbs[2], b.limbs[2], c1);
    let (r3, c3) = adc(a.limbs[3], b.limbs[3], c2);
    (U256 { limbs: [r0, r1, r2, r3] }, c3)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn transfer_examples() {
        assert_eq!(transfer(100, 5, 30), Some((70, 35)));
        assert_eq!(transfer(10, 5, 30), None);
        assert_eq!(transfer(1, u64::MAX, 1), None);
    }

    // The tests for the unchecked version pass too.
    #[test]
    fn transfer_unchecked_examples() {
        assert_eq!(transfer_unchecked(100, 5, 30), Some((70, 35)));
        assert_eq!(transfer_unchecked(10, 5, 30), None);
    }

    #[test]
    fn midpoint_examples() {
        assert_eq!(midpoint(3, 8), 5);
        assert_eq!(midpoint(u64::MAX, u64::MAX), u64::MAX);
    }

    #[test]
    fn add_u256_carries() {
        let a = U256 { limbs: [u64::MAX, u64::MAX, 0, 0] };
        let b = U256 { limbs: [1, 0, 0, 0] };
        let (r, c) = add_u256(a, b);
        assert_eq!(r.limbs, [0, 0, 1, 0]);
        assert_eq!(c, 0);
    }
}
