use starknet::ContractAddress;

#[starknet::interface]
trait IIdentity<TContractState> {
    fn get_user_data(
        self: @TContractState, starknet_id: felt252, field: felt252, domain: felt252
    ) -> felt252;

    fn get_crosschecked_user_data(
        self: @TContractState, starknet_id: felt252, field: felt252
    ) -> felt252;

    fn get_verifier_data(
        self: @TContractState, starknet_id: felt252, field: felt252, domain: felt252
    ) -> felt252;

    fn get_crosschecked_verifier_data(
        self: @TContractState, starknet_id: felt252, field: felt252
    ) -> felt252;
}
