use strict;
use warnings;
use Test::More;
use Test::Exception;
use String::Incremental;

sub new {
    my $str = String::Incremental->new( @_ );
    return $str;
}

subtest 'call' => sub {
    my $str = new( 'foobar' );
    ok $str->can( 'set' );
};

subtest 'ng' => sub {
    my $str = new( '%s-%=%=', 'foo', 'abc', 'xyz' );
    is "$str", 'foo-ax';

    dies_ok {
        $str->set();
    } 'no arg';
    is "$str", 'foo-ax', 'should not be updated when die';

    dies_ok {
        $str->set( 'cz3' );
    } 'nums are mismatch: "Char" items v.s. chars of arg';
    is "$str", 'foo-ax', 'should not be updated when die';

    dies_ok {
        $str->set( 'xa' );
    } 'out of order: all chars';
    is "$str", 'foo-ax', 'should not be updated when die';

    dies_ok {
        $str->set( 'bb' );
    } 'out of order: one char';
    is "$str", 'foo-ax', 'should not be updated when die';
};

subtest 'ok' => sub {
    my $str = new( '%s-%=%=', 'foo', 'abc', 'xyz' );
    is "$str", 'foo-ax';

    lives_ok {
        $str->set( 'cz' );
        is "$str", 'foo-cz';
    } 'arg is-a Str';

    lives_ok {
        $str->set( ['b', 'y'] );
        is "$str", 'foo-by';
    } 'arg is-a ArrayRef';
};

done_testing;

