#[starknet::contract]
mod Identity {
    use starknet::ContractAddress;
    use starknet::contract_address::ContractAddressZeroable;
    use starknet::{get_caller_address, get_contract_address};
    use starknet::{SyscallResultTrait, StorageBaseAddress};
    use traits::Into;
    use array::{ArrayTrait, SpanTrait};
    use zeroable::Zeroable;
    use starknet::class_hash::ClassHash;
    use identity::interface::identity::{IIdentity, IIdentityDispatcher, IIdentityDispatcherTrait};
    use integer::{u256_safe_divmod, u256_as_non_zero};
    use core::pedersen;
    use debug::PrintTrait;

    const USER_DATA_ADDR: felt252 =
        1043580099640415304067929596039389735845630832049981224284932480360577081706;
    const VERIFIER_DATA_ADDR: felt252 =
        304878986635684253299743444353489138340069571156984851619649640349195152192;

    #[storage]
    struct Storage {
        owner_by_id: LegacyMap<u128, ContractAddress>,
        user_data: LegacyMap<(u128, felt252), felt252>,
        verifier_data: LegacyMap<(u128, felt252, ContractAddress), felt252>,
        main_id_by_addr: LegacyMap<ContractAddress, u128>,
    }

    // 
    // Events
    // 

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        VerifierDataUpdate: VerifierDataUpdate,
        ExtendedVerifierDataUpdate: ExtendedVerifierDataUpdate,
        UserDataUpdate: UserDataUpdate,
        ExtendedUserDataUpdate: ExtendedUserDataUpdate,
    }

    #[derive(Drop, starknet::Event)]
    struct VerifierDataUpdate {
        #[key]
        id: u128,
        field: felt252,
        _data: felt252,
        verifier: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct ExtendedVerifierDataUpdate {
        #[key]
        id: u128,
        field: felt252,
        _data: Span<felt252>,
        verifier: ContractAddress,
    }

    #[derive(Drop, starknet::Event)]
    struct UserDataUpdate {
        #[key]
        id: u128,
        field: felt252,
        _data: felt252,
    }

    #[derive(Drop, starknet::Event)]
    struct ExtendedUserDataUpdate {
        #[key]
        id: u128,
        field: felt252,
        _data: Span<felt252>,
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

        fn get_user_data(self: @ContractState, id: u128, field: felt252, domain: u32) -> felt252 {
            // todo: when volition comes, check on the specified domain
            self.user_data.read((id, field))
        }

        fn get_crosschecked_user_data(self: @ContractState, id: u128, field: felt252) -> felt252 {
            // todo: when volition comes, check on domain 0, if empty, check on volition
            self.user_data.read((id, field))
        }

        fn get_extended_user_data(
            self: @ContractState, id: u128, field: felt252, length: felt252, domain: u32
        ) -> Span<felt252> {
            self
                .get_extended(
                    USER_DATA_ADDR, array![id.into(), field].span(), 0, length.into(), domain,
                )
        }

        fn get_unbounded_user_data(
            self: @ContractState, id: u128, field: felt252, domain: u32
        ) -> Span<felt252> {
            self.get_unbounded(USER_DATA_ADDR, array![id.into(), field].span(), 0, domain,)
        }


        fn get_verifier_data(
            self: @ContractState, id: u128, field: felt252, verifier: ContractAddress, domain: u32
        ) -> felt252 {
            // todo: when volition comes, check on the specified domain
            self.verifier_data.read((id, field, verifier))
        }

        fn get_extended_verifier_data(
            self: @ContractState,
            id: u128,
            field: felt252,
            length: felt252,
            verifier: ContractAddress,
            domain: u32
        ) -> Span<felt252> {
            self
                .get_extended(
                    VERIFIER_DATA_ADDR,
                    array![id.into(), field, verifier.into()].span(),
                    0,
                    length.into(),
                    domain,
                )
        }

        fn get_unbounded_verifier_data(
            self: @ContractState, id: u128, field: felt252, verifier: ContractAddress, domain: u32
        ) -> Span<felt252> {
            self
                .get_unbounded(
                    VERIFIER_DATA_ADDR, array![id.into(), field, verifier.into()].span(), 0, domain,
                )
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
            ref self: ContractState, id: u128, field: felt252, data: felt252, domain: u32
        ) {
            // todo: when volition comes, handle the domain
            self.user_data.write((id, field), data);
            self.emit(Event::UserDataUpdate(UserDataUpdate { id, field, _data: data }))
        }

        fn set_extended_user_data(
            ref self: ContractState, id: u128, field: felt252, data: Span<felt252>, domain: u32
        ) {
            let caller = get_caller_address();
            assert(caller == self.owner_by_id.read(id), 'you don\'t own this id');
            self.set(USER_DATA_ADDR, array![id.into(), field].span(), 0, data, domain);
            self
                .emit(
                    Event::ExtendedUserDataUpdate(
                        ExtendedUserDataUpdate { id, field, _data: data, }
                    )
                );
        }

        fn set_verifier_data(
            ref self: ContractState, id: u128, field: felt252, data: felt252, domain: u32
        ) {
            // todo: when volition comes, handle the domain
            let verifier = get_caller_address();
            self.verifier_data.write((id, field, verifier), data);
            self
                .emit(
                    Event::VerifierDataUpdate(
                        VerifierDataUpdate { id, field, _data: data, verifier, }
                    )
                )
        }

        fn set_extended_verifier_data(
            ref self: ContractState, id: u128, field: felt252, data: Span<felt252>, domain: u32
        ) {
            let verifier = get_caller_address();
            self
                .set(
                    VERIFIER_DATA_ADDR,
                    array![id.into(), field, verifier.into()].span(),
                    0,
                    data,
                    domain
                );
            self
                .emit(
                    Event::ExtendedVerifierDataUpdate(
                        ExtendedVerifierDataUpdate { id, field, _data: data, verifier, }
                    )
                );
        }
    }

    //
    // Internals
    //

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        // todo: move these functions into a storage contract when components are available
        fn get_extended(
            self: @ContractState,
            fn_name: felt252,
            params: Span<felt252>,
            offset: u8,
            length: felt252,
            domain: u32
        ) -> Span<felt252> {
            let base = self.compute_base_address(fn_name, params);
            let mut data = ArrayTrait::new();
            let mut offset = 0;
            loop {
                if length == offset.into() {
                    break ();
                }
                let value = self._get(domain, base, offset);
                data.append(value);
                offset += 1;
            };
            data.span()
        }

        fn get_unbounded(
            self: @ContractState, fn_name: felt252, params: Span<felt252>, offset: u8, domain: u32
        ) -> Span<felt252> {
            let base = self.compute_base_address(fn_name, params);
            let mut data = ArrayTrait::new();
            let mut offset = 0;
            loop {
                let value = self._get(domain, base, offset);
                if value == 0 {
                    break ();
                }
                data.append(value);
                offset += 1;
            };
            data.span()
        }

        fn _get(
            self: @ContractState, domain: u32, base: starknet::StorageBaseAddress, offset: u8,
        ) -> felt252 {
            starknet::storage_read_syscall(
                domain, starknet::storage_address_from_base_and_offset(base, offset)
            )
                .unwrap_syscall()
        }

        fn set(
            ref self: ContractState,
            fn_name: felt252,
            params: Span<felt252>,
            offset: u8,
            value: Span<felt252>,
            domain: u32,
        ) {
            let base = self.compute_base_address(fn_name, params);
            self._set(domain, base, value, offset: offset);
        }

        fn _set(
            ref self: ContractState,
            domain: u32,
            base: starknet::StorageBaseAddress,
            mut value: Span<felt252>,
            offset: u8
        ) {
            match value.pop_front() {
                Option::Some(v) => {
                    starknet::storage_write_syscall(
                        domain, starknet::storage_address_from_base_and_offset(base, offset), *v
                    );
                    self._set(domain, base, value, offset + 1);
                },
                Option::None(_) => {},
            }
        }

        fn compute_base_address(
            self: @ContractState, fn_name: felt252, params: Span<felt252>
        ) -> StorageBaseAddress {
            let mut _params = params;
            let mut tmp: felt252 = hash::LegacyHash::hash(
                fn_name, *_params.pop_front().expect('error computing hash')
            );
            loop {
                if _params.len() == 0 {
                    break ();
                }
                let hash = hash::LegacyHash::hash(
                    tmp, *_params.pop_front().expect('error computing hash')
                );
                tmp = hash;
            };
            starknet::storage_base_address_from_felt252(tmp)
        }
    }
}
