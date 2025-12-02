#include <cassert>
#include <myproject/myproject.hpp>

int main() {
    int value = myproject::add_one(1);
    assert(value == 2);
    return 0;
}
