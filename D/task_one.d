module task_one;

import std.stdio;

static this() {
    writeln("module task one is init.");
}

void main() {
    writeln("It main.");
    writeln(cube!float(4.4));
    writeln(sort_bubble([1,3,2,3,1,5,6,7,3,2,1,0]));
    writeln(sort_bubble([1.1, 2.2, 1.3]));
}

T cube(T)(T x) {
    return x * x * x;
}

T[] sort_bubble(T)(T[] array) {
    bool sorted = false;
    while (!sorted) {
        sorted = true;
        for(int i = 0; i < array.length - 1; i++) {
            for(int j = i + 1; j < array.length; j++) {
                if (array[i] > array[j]) {
                    sorted = false;
                    T t = array[i];
                    array[i] = array[j];
                    array[j] = t;
                }
            }
        }
    }
    return array;
}

unittest {
    writeln("testing start");
    assert(cube(4) == 64);
    writeln("testing ok");
}
