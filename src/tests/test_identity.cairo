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
fn test_user_data() {
    let identity = deploy_identity();
    identity.mint(1);

    identity.set_user_data(1, 'starknet', 0x123, 0);
    assert(identity.get_user_data(1, 'starknet', 0) == 0x123, 'wrong data');
}

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
