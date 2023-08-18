use starknet::ContractAddress;

#[starknet::interface]
trait IIdentity<TContractState> {
    fn owner_of(self: @TContractState, id: u128) -> ContractAddress;

    fn get_user_data(self: @TContractState, id: u128, field: felt252, domain: felt252) -> felt252;

    fn get_crosschecked_user_data(self: @TContractState, id: u128, field: felt252) -> felt252;

    fn get_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress, domain: felt252
    ) -> felt252;

    fn get_crosschecked_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress
    ) -> felt252;

    fn get_main_id(self: @TContractState, user: ContractAddress) -> u128;

    fn mint(ref self: TContractState, id: u128);

    fn set_main_id(ref self: TContractState, id: u128);

    // todo: add support for multifelts data

    fn set_user_data(
        ref self: TContractState, id: u128, field: felt252, data: felt252, domain: felt252
    );

    fn set_verifier_data(
        ref self: TContractState, id: u128, field: felt252, data: felt252, domain: felt252
    );
}
