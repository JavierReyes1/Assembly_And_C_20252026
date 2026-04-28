#include <stdio.h>
#include <assert.h>

// function from my assembly code
extern int register_adder(int a, int b);

int main() {
    printf("Testing register_adder...\n\n");

    // basic stuff
    assert(register_adder(2, 3) == 5);
    assert(register_adder(0, 0) == 0);
    assert(register_adder(1, 1) == 2);
    printf("basic addition works\n");

    // negative numbers
    assert(register_adder(-1, -1) == -2);
    assert(register_adder(-5, 5) == 0);
    printf("negatives work\n");

    // make sure a+b gives same as b+a
    assert(register_adder(7, 3) == register_adder(3, 7));
    printf("commutative check passed\n");

    // adding zero shouldnt change anything
    assert(register_adder(42, 0) == 42);
    assert(register_adder(0, 42) == 42);
    printf("adding zero works\n");

    // bigger numbers within our -999999 to 999999 range
    assert(register_adder(999999, 0) == 999999);
    assert(register_adder(-999999, 0) == -999999);
    assert(register_adder(999999, -999999) == 0);
    assert(register_adder(500000, 499999) == 999999);
    printf("boundary values ok\n");

    printf("\nall tests passed!\n");
    return 0;
}
