use identity::identity::main::Identity;
use starknet::{SyscallResultTrait, storage_base_address_from_felt252};

#[generate_trait]
impl InternalImpl of InternalTrait {

    fn get_extended(
        self: @Identity::ContractState,
        fn_name: felt252,
        params: Span<felt252>,
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
            let value = self._get(domain, storage_base_address_from_felt252(base + offset));
            data.append(value);
            offset += 1;
        };
        data.span()
    }

    fn get_unbounded(
        self: @Identity::ContractState, fn_name: felt252, params: Span<felt252>, domain: u32
    ) -> Span<felt252> {
        let base = self.compute_base_address(fn_name, params);
        let mut data = ArrayTrait::new();
        let mut offset = 0;
        loop {
            let value = self._get(domain, storage_base_address_from_felt252(base + offset));
            if value == 0 {
                break ();
            }
            data.append(value);
            offset += 1;
        };
        data.span()
    }

    fn _get(
        self: @Identity::ContractState, domain: u32, base: starknet::StorageBaseAddress
    ) -> felt252 {
        starknet::storage_read_syscall(
            domain, starknet::storage_address_from_base_and_offset(base, 0)
        )
            .unwrap_syscall()
    }

    fn set(
        ref self: Identity::ContractState,
        fn_name: felt252,
        params: Span<felt252>,
        value: Span<felt252>,
        domain: u32,
    ) {
        let base = self.compute_base_address(fn_name, params);
        self._set(domain, base, value);
    }

    fn _set(
        ref self: Identity::ContractState, domain: u32, base: felt252, mut values: Span<felt252>,
    ) {
        match values.pop_back() {
            Option::Some(value) => {
                let addr = storage_base_address_from_felt252(base + values.len().into());
                starknet::storage_write_syscall(
                    domain, starknet::storage_address_from_base_and_offset(addr, 0), *value
                ).unwrap();
                self._set(domain, base, values);
            },
            Option::None(_) => {},
        }
    }

    fn compute_base_address(
        self: @Identity::ContractState, fn_name: felt252, mut params: Span<felt252>
    ) -> felt252 {
        let mut hashed = fn_name;
        loop {
            match params.pop_front() {
                Option::Some(param) => { hashed = hash::LegacyHash::hash(hashed, *param); },
                Option::None => { break; }
            };
        };
        hashed
    }
}
