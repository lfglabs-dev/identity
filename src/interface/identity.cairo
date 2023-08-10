use starknet::ContractAddress;

#[starknet::interface]
trait IIdentity<TContractState> {
    fn get_user_data(self: @TContractState, id: u128, field: felt252, domain: felt252) -> felt252;

    fn get_crosschecked_user_data(self: @TContractState, id: u128, field: felt252) -> felt252;

    fn get_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress, domain: felt252
    ) -> felt252;

    fn get_crosschecked_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress
    ) -> felt252;

    fn set_verifier_data(ref self: TContractState, id: u128, field: felt252, domain: felt252);
}
