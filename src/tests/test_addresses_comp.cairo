use starknet::testing;
use identity::identity::internal::InternalImpl;
use identity::interface::identity::{IIdentity, IIdentityDispatcher, IIdentityDispatcherTrait};
use identity::identity::main::Identity;
use debug::PrintTrait;
use starknet::{SyscallResultTrait, StorageBaseAddress};
use traits::{Into, TryInto};

const VERIFIER_DATA_ADDR: felt252 =
    304878986635684253299743444353489138340069571156984851619649640349195152192;

#[test]
#[available_gas(20000000000)]
fn test_compute_address_single_param() {
    let mut unsafe_state = Identity::unsafe_new_contract_state();

    // It should return the same value as utils::get_storage_var_address() from starknet-rs
    let expected_0 = 0x04496ba66d9685813220a5ba3d7b2be924385ad47abfafeec804b0e2f3f0ec56;
    let computed_addr_0 = InternalImpl::compute_base_address(
        @unsafe_state, VERIFIER_DATA_ADDR, array![0].span()
    );
    assert(computed_addr_0 == expected_0, 'Invalid storage address');

    // It should return the same value as utils::get_storage_var_address() from starknet-rs
    let expected: felt252 = 0x01f65ea3e42f099a1c085eecf45ce0d476a1ab440e3ed539604cac5ba6944258;
    let computed_addr = InternalImpl::compute_base_address(
        @unsafe_state, VERIFIER_DATA_ADDR, array![123].span()
    );
    assert(computed_addr == expected, 'Invalid storage address');
}


#[test]
#[available_gas(20000000000)]
fn test_compute_address_multiple_params() {
    let mut unsafe_state = Identity::unsafe_new_contract_state();

    // It should return the same value as utils::get_storage_var_address() from starknet-rs
    let expected = 0x023289a31298cac4a750e1fbc154c96b5398aa7e94018d9d5c115690aa124767;
    let computed_addr = InternalImpl::compute_base_address(
        @unsafe_state, VERIFIER_DATA_ADDR, array![0, 1, 3].span()
    );
    assert(computed_addr == expected, 'Invalid storage address');
}


#[test]
#[available_gas(20000000000)]
fn test_compute_address_empty_param() {
    let mut unsafe_state = Identity::unsafe_new_contract_state();

    // It should return the same value as utils::get_storage_var_address() from starknet-rs
    let expected = 0x00ac8e2e1fdb949863544c38e1ed04b4c447121f2b60005f7c7f798c6a35ab40;
    let computed_addr = InternalImpl::compute_base_address(
        @unsafe_state, VERIFIER_DATA_ADDR, array![].span()
    );
    assert(computed_addr == expected, 'Invalid storage address');
}
