use openzeppelin::{
    token::erc721::{ERC721Component::{ERC721Metadata, HasComponent}},
    introspection::src5::SRC5Component,
};

#[starknet::interface]
trait IERC721StaticMetadata<TState> {
    fn name(self: @TState) -> felt252;
    fn symbol(self: @TState) -> felt252;
}

#[starknet::embeddable]
impl ERC721StaticMetadataImpl<
    TContractState,
    +HasComponent<TContractState>,
    +SRC5Component::HasComponent<TContractState>,
    +Drop<TContractState>
> of IERC721StaticMetadata<TContractState> {
    fn name(self: @TContractState) -> felt252 {
        let component = HasComponent::get_component(self);
        ERC721Metadata::name(component)
    }

    fn symbol(self: @TContractState) -> felt252 {
        let component = HasComponent::get_component(self);
        ERC721Metadata::symbol(component)
    }
}
