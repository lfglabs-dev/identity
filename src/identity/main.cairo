use core::array::SpanTrait;
#[starknet::contract]
mod StarknetId {
    use starknet::ContractAddress;
    use starknet::contract_address::ContractAddressZeroable;
    use starknet::{get_caller_address, get_contract_address};
    use traits::Into;
    use array::{ArrayTrait, SpanTrait};
    use zeroable::Zeroable;
    use starknet::class_hash::ClassHash;
    use identity::interface::identity::{IIdentity, IIdentityDispatcher, IIdentityDispatcherTrait};
    use integer::{u256_safe_divmod, u256_as_non_zero};
    use core::pedersen;


    #[storage]
    struct Storage {}

    #[constructor]
    fn constructor(ref self: ContractState) {}

    #[external(v0)]
    impl NamingImpl of IIdentity<ContractState> {
        fn owner_of(self: @ContractState, id: u128) -> ContractAddress {
            ContractAddressZeroable::zero()
        }

        fn get_user_data(
            self: @ContractState, id: u128, field: felt252, domain: felt252
        ) -> felt252 {
            1
        }

        fn get_crosschecked_user_data(self: @ContractState, id: u128, field: felt252) -> felt252 {
            1
        }


        fn get_verifier_data(
            self: @ContractState,
            id: u128,
            field: felt252,
            verifier: ContractAddress,
            domain: felt252
        ) -> felt252 {
            1
        }


        fn get_crosschecked_verifier_data(
            self: @ContractState, id: u128, field: felt252, verifier: ContractAddress
        ) -> felt252 {
            1
        }

        fn set_verifier_data(ref self: ContractState, id: u128, field: felt252, domain: felt252) {}
    }
}
