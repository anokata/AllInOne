import std.stdio, std.string;

void change(ref int x) {
    x = x * x;
}

void main() {
    immutable inchesPerFoot = 12;
    immutable byte END = 80;
    foreach (i; 2..END) {
        writefln("%s/%d", i, i);
    }
    int i = 8;
    writef("f i: %d ", i);
    change(i);
    writef("d i: %d ", i);
    writeln("Hello world!");

    string s = "hz\nn2\nur\nz.";
    foreach (str; split(s)) {
        write(str, "_");
    }
    writeln();
    // dict
    int [string] dic;
    // file
    auto file = File("hi.d", "r"); 
    foreach (line; file.byLine) {
        if (line.length > 2) {
            write(line[0..2]);
        }
    }
    dic["a"] = 2;
    dic["ab"] = 12;
    writeln(dic);
}
