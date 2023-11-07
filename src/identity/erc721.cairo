use openzeppelin::{
    token::erc721::{ERC721Component::{ERC721Metadata, HasComponent}},
    introspection::src5::SRC5Component,
};
use custom_uri::{main::custom_uri_component::InternalImpl, main::custom_uri_component};


#[starknet::interface]
trait IERC721Metadata<TState> {
    fn name(self: @TState) -> felt252;
    fn symbol(self: @TState) -> felt252;
    fn token_uri(self: @TState, tokenId: u256) -> Array<felt252>;
    fn tokenURI(self: @TState, tokenId: u256) -> Array<felt252>;
}

#[starknet::embeddable]
impl IERC721MetadataImpl<
    TContractState,
    +HasComponent<TContractState>,
    +SRC5Component::HasComponent<TContractState>,
    +custom_uri_component::HasComponent<TContractState>,
    +Drop<TContractState>
> of IERC721Metadata<TContractState> {
    fn name(self: @TContractState) -> felt252 {
        let component = HasComponent::get_component(self);
        ERC721Metadata::name(component)
    }

    fn symbol(self: @TContractState) -> felt252 {
        let component = HasComponent::get_component(self);
        ERC721Metadata::symbol(component)
    }

    fn token_uri(self: @TContractState, tokenId: u256) -> Array<felt252> {
        let component = custom_uri_component::HasComponent::get_component(self);
        component.get_uri(tokenId)
    }

    fn tokenURI(self: @TContractState, tokenId: u256) -> Array<felt252> {
        self.token_uri(tokenId)
    }
}
