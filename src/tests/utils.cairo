use array::ArrayTrait;
use core::result::ResultTrait;
use option::OptionTrait;
use starknet::{class_hash::Felt252TryIntoClassHash, ContractAddress, SyscallResultTrait};
use identity::interface::identity::{IIdentityDispatcher, IIdentityDispatcherTrait};
use identity::identity::main::Identity;
use traits::TryInto;

const ADMIN: felt252 = 0x123;

fn deploy(contract_class_hash: felt252, calldata: Array<felt252>) -> ContractAddress {
    let (address, _) = starknet::deploy_syscall(
        contract_class_hash.try_into().unwrap(), 0, calldata.span(), false
    )
        .unwrap_syscall();
    address
}

fn deploy_identity() -> IIdentityDispatcher {
    let address = deploy(Identity::TEST_CLASS_HASH, array![ADMIN, 0]);
    IIdentityDispatcher { contract_address: address }
}
