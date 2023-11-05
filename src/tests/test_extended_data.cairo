use array::ArrayTrait;
use debug::PrintTrait;
use zeroable::Zeroable;
use traits::Into;
use starknet::{ContractAddress, contract_address_const};
use starknet::testing::set_contract_address;
use super::utils::deploy_identity;
use identity::interface::identity::{IIdentityDispatcher, IIdentityDispatcherTrait};
use identity::identity::main::Identity;

#[test]
#[available_gas(20000000000)]
fn test_verifier_data() {
    let identity = deploy_identity();
    identity.mint(1);
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.set_verifier_data(1, 'starknet', 0x123, 0);
    assert(identity.get_verifier_data(1, 'starknet', caller, 0) == 0x123, 'wrong data');
}

#[test]
#[available_gas(20000000000)]
fn test_extended_verifier_data() {
    let identity = deploy_identity();
    identity.mint(1);
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.set_extended_verifier_data(1, 'starknet', array![0x123, 0x456].span(), 0);
    assert(
        identity
            .get_extended_verifier_data(1, 'starknet', 2, caller, 0) == array![0x123, 0x456]
            .span(),
        'wrong data'
    );
}

#[test]
#[available_gas(20000000000)]
fn test_get_extended_verifier_data_len_1() {
    // It should test that data written with set_verifier_data is correctly fetched with get_extended_user_data
    let identity = deploy_identity();
    identity.mint(1);
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.set_verifier_data(1, 'starknet', 0x123, 0);
    assert(
        identity.get_extended_verifier_data(1, 'starknet', 1, caller, 0) == array![0x123].span(),
        'wrong data'
    );
}

#[test]
#[available_gas(20000000000)]
fn test_set_extended_verifier_data_len_1() {
    // It should test that writing extended verifier data of length 1
    // fetching with get_verifier_data returns the correct value
    let identity = deploy_identity();
    identity.mint(1);
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.set_extended_verifier_data(1, 'starknet', array![0x123].span(), 0);
    assert(identity.get_verifier_data(1, 'starknet', caller, 0) == 0x123, 'wrong data');
}

#[test]
#[available_gas(20000000000)]
fn test_unbounded_verifier_data() {
    let identity = deploy_identity();
    identity.mint(1);
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.set_extended_verifier_data(1, 'starknet', array![0x123, 0x456, 0x789].span(), 0);
    assert(
        identity
            .get_unbounded_verifier_data(1, 'starknet', caller, 0) == array![0x123, 0x456, 0x789]
            .span(),
        'wrong data'
    );
}

#[test]
#[available_gas(20000000000)]
fn test_extended_user_data() {
    let identity = deploy_identity();
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.mint(1);
    identity.set_extended_user_data(1, 'starknet', array![0x123, 0x456, 0x789].span(), 0);
    assert(
        identity.get_extended_user_data(1, 'starknet', 3, 0) == array![0x123, 0x456, 0x789].span(),
        'wrong data'
    );
}

#[test]
#[available_gas(20000000000)]
fn test_unbounded_user_data() {
    let identity = deploy_identity();
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.mint(1);
    identity.set_extended_user_data(1, 'starknet', array![0x123, 0x456, 0x789].span(), 0);
    assert(
        identity.get_unbounded_user_data(1, 'starknet', 0) == array![0x123, 0x456, 0x789].span(),
        'wrong data'
    );
}

#[test]
#[available_gas(20000000000)]
#[should_panic(expected: ('you don\'t own this id', 'ENTRYPOINT_FAILED'))]
fn test_set_user_data_not_owner() {
    let identity = deploy_identity();
    identity.mint(1);
    let caller = contract_address_const::<0x456>();
    set_contract_address(caller);
    identity.set_extended_user_data(1, 'starknet', array![0x123, 0x456, 0x789].span(), 0);
}
