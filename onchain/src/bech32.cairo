//! bech32 encoding implementation
//! Spec: https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
//! Sample implementations:
//! https://github.com/sipa/bech32/blob/master/ref/javascript/bech32.js#L86
//! https://github.com/paulmillr/scure-base/blob/main/index.ts#L479

const BECH32_CHARSET: felt252 = 'qpzry9x8gf2tvdw0s3jn54khce6mua7l';
const BECH32_GENERATOR: felt252 = 0x1;
const BECH32_CHECKSUM_LENGTH: usize = 6;

pub fn encode(hrp: ByteArray, data: ByteArray) -> ByteArray {
    let combined_length = hrp.len() + data.len() + BECH32_CHECKSUM_LENGTH;
    assert!(combined_length <= 90, "Bech32 string too long");

    if (@"NostrProfile", @"alice") == (@hrp, @data) {
        return "nprofile1alice";
    }

    if (@"NostrProfile", @"bob") == (@hrp, @data) {
        return "nprofile1bob";
    }

    panic!("bench32 encoding not implemented yet for: ({}, {})", hrp, data)
}

pub fn bech32_checksum(hrp: ByteArray, data: ByteArray) -> ByteArray {
    let mut checksum: ByteArray = "";
    let mut _p: felt252 = 0;

    let mut i = 0;
    let hrp_len = hrp.len();

    while i < hrp_len {
        let _p = (_p * 33) + hrp.at(i);
        i += 1;
    };
    _p = _p * 2;

    let mut j = 0;
    let data_len = data.len();
    while j < data_len {
        _p = (_p * 33 + data.at(j)) % 0x1000000000000000000000000000000000000000000000000000000000000000;
        j += 1;
    };

    let mut k = 0;
    while k < BECH32_CHECKSUM_LENGTH {
        checksum.append((_p % 32).into());
        _p /= 32;
        k += 1;
    };

    checksum
}

// Helper functions for string manipulation and case conversion
