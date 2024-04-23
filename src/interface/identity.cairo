use starknet::ContractAddress;

#[starknet::interface]
trait IIdentity<TContractState> {
    fn owner_from_id(self: @TContractState, id: u128) -> ContractAddress;

    fn get_user_data(self: @TContractState, id: u128, field: felt252, domain: u32) -> felt252;

    fn get_extended_user_data(
        self: @TContractState, id: u128, field: felt252, length: felt252, domain: u32
    ) -> Span<felt252>;

    fn get_unbounded_user_data(
        self: @TContractState, id: u128, field: felt252, domain: u32
    ) -> Span<felt252>;

    fn get_crosschecked_user_data(self: @TContractState, id: u128, field: felt252) -> felt252;

    fn get_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress, domain: u32
    ) -> felt252;

    fn get_extended_verifier_data(
        self: @TContractState,
        id: u128,
        field: felt252,
        length: felt252,
        verifier: ContractAddress,
        domain: u32
    ) -> Span<felt252>;

    fn get_unbounded_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress, domain: u32
    ) -> Span<felt252>;

    fn get_crosschecked_verifier_data(
        self: @TContractState, id: u128, field: felt252, verifier: ContractAddress
    ) -> felt252;

    fn get_main_id(self: @TContractState, user: ContractAddress) -> u128;

    fn mint(ref self: TContractState, id: u128);

    fn set_main_id(ref self: TContractState, id: u128);

    fn reset_main_id(ref self: TContractState);

    fn set_user_data(
        ref self: TContractState, id: u128, field: felt252, data: felt252, domain: u32
    );

    fn set_extended_user_data(
        ref self: TContractState, id: u128, field: felt252, data: Span<felt252>, domain: u32
    );

    fn set_verifier_data(
        ref self: TContractState, id: u128, field: felt252, data: felt252, domain: u32
    );

    fn set_extended_verifier_data(
        ref self: TContractState, id: u128, field: felt252, data: Span<felt252>, domain: u32
    );

    fn migrate(
        ref self: TContractState, token_uri: ByteArray
    );
}
