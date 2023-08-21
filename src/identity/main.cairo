use core::array::SpanTrait;
#[starknet::contract]
mod Identity {
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
    use debug::PrintTrait;


    #[storage]
    struct Storage {
        owner_by_id: LegacyMap<u128, ContractAddress>,
        user_data: LegacyMap<(u128, felt252), felt252>,
        verifier_data: LegacyMap<(u128, felt252, ContractAddress), felt252>,
        main_id_by_addr: LegacyMap<ContractAddress, u128>,
    }

    #[constructor]
    fn constructor(ref self: ContractState) {}

    #[external(v0)]
    impl IdentityImpl of IIdentity<ContractState> {
        fn owner_of(self: @ContractState, id: u128) -> ContractAddress {
            // todo: when components are ready, use ERC721
            self.owner_by_id.read(id)
        }

        fn get_main_id(self: @ContractState, user: ContractAddress) -> u128 {
            self.main_id_by_addr.read(user)
        }

        fn get_user_data(
            self: @ContractState, id: u128, field: felt252, domain: felt252
        ) -> felt252 {
            // todo: when volition comes, check on the specified domain
            self.user_data.read((id, field))
        }

        fn get_crosschecked_user_data(self: @ContractState, id: u128, field: felt252) -> felt252 {
            // todo: when volition comes, check on domain 0, if empty, check on volition
            self.user_data.read((id, field))
        }


        fn get_verifier_data(
            self: @ContractState,
            id: u128,
            field: felt252,
            verifier: ContractAddress,
            domain: felt252
        ) -> felt252 {
            // todo: when volition comes, check on the specified domain
            self.verifier_data.read((id, field, verifier))
        }


        fn get_crosschecked_verifier_data(
            self: @ContractState, id: u128, field: felt252, verifier: ContractAddress
        ) -> felt252 {
            // todo: when volition comes, check on domain 0, if empty, check on volition
            self.verifier_data.read((id, field, verifier))
        }

        fn mint(ref self: ContractState, id: u128) {
            // todo: when components are ready, use ERC721
            if self.owner_by_id.read(id).into() == 0 {
                self.owner_by_id.write(id, get_caller_address());
            }
        }

        fn set_main_id(ref self: ContractState, id: u128) {
            // todo: add event
            let caller = get_caller_address();
            assert(caller == self.owner_by_id.read(id), 'you don\'t own this id');
            self.main_id_by_addr.write(caller, id);
        }

        fn reset_main_id(ref self: ContractState) {
            // todo: add event
            self.main_id_by_addr.write(get_caller_address(), 0);
        }

        fn set_user_data(
            ref self: ContractState, id: u128, field: felt252, data: felt252, domain: felt252
        ) {
            // todo: when volition comes, handle the domain
            self.user_data.write((id, field), data);
        }

        fn set_verifier_data(
            ref self: ContractState, id: u128, field: felt252, data: felt252, domain: felt252
        ) {
            // todo: when volition comes, handle the domain
            self.verifier_data.write((id, field, get_caller_address()), data);
        }
    }
}
