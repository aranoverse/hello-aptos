module hello_aptos::counter {
    use std::signer::address_of;

    struct Counter has key {
        value: u8,
    }

    public fun increment(signer: &signer) acquires Counter {
        let addr = address_of(signer);
        if (!exists<Counter>(addr)) {
            move_to(signer, Counter { value: 0 });
        };

        let r = borrow_global_mut<Counter>(address_of(signer));
        r.value = r.value + 1;
    }


    public fun counter(addr: address): u8 acquires Counter {
        borrow_global<Counter>(addr).value
    }

    spec increment {
        let conter = global<Counter>(address_of(signer)).value;


        let post conter_post = global<Counter>(address_of(signer)).value;
        ensures conter_post == conter + 1;
    }


    #[test(signer = @hello_aptos)]
    public fun test_increment(signer: &signer) acquires Counter {
        increment(signer);
        let counter_log_1 = counter(address_of(signer));
        increment(signer);
        let counter_log_2 = counter(address_of(signer));
        assert!(counter_log_1 + 1 == counter_log_2, 1);
    }
}
