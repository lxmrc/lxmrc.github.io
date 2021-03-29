Mocks and stubs

**Stubs** help with **input**.
**Mocks** help with **output**.

You are testing a class whose behaviour (naturally) depends on other classes, but you don't want to have to instantiate instances of those other classes in your test*.

If the behaviour you're testing requires some dependency to return some value, you can use a **stub** to simulate this. You simply tell the stub that when it receives some message `do_something()` it will return some value `expected value`. You can then carry on with testing the actual behaviour without having actually instantiated the dependency or having to run any of the logic it would need to run in the real world.

If you need to verify in your test that a specific message is sent to some object, but you don't want to actually send this message (e.g.: calling a method that hits a payment API and charges someone's credit card) you can use **mocks** to intercept this message and verify that the messages was indeed sent. You simply tell it to expect some method `do_something()` to be called; if the mock receives this method call the test passes, otherwise it fails.

*Why not? Speculation, not sure if true: 
- because a set of tests for a specific class should be testing only that class, in isolation, a sort of separation of concerns, minimalism, decoupling, etc. If something fails it should be because of the class that's being tested not one of its dependencies. Avoids having to reason about more than one class.
- those dependencies might have some real-world effects e.g. hitting a payment API
- tests will run faster probably