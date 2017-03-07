print "hello\n";
%h = ( some => 'val');
%d = ('a', 2, 'b', 3);
$x = 123;
print(join(" -> ", %h));
print("\n");
print(join(" -> ", %d));

sub sum2{
    return 0;
}
print("\n");
print(sum2);
$x .= 'some';
print("\n");
print($x);
print("\n");
print($x =~ m/3/);
print("\n");
$x =~ s/(o|m)/A/g;
print($x);
print("\n");
$x =~ s/([1-9])/$1-$1/g;
print($x);
print("\n");
$a = 1; print($a);
++$a;print($a);
while (++$a < 10){ print(",".$a);}

print("\n");
$x=~s=(-)=_=g;
print($x);
print("\n");
print("abcabc");
print(system"pwd");
print("\n");
my @aa = qw/12 34 bc/;
print(join(" ", @aa));

sub f1{
    my $x = shift();
    my $y = shift;
    print("\n$x and $y \n");
}

f1('a', 'b', 'c');


