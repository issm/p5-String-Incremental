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
    ok $str->can( 'as_string' );
};

subtest 'basic' => sub {
    my $str = new(
        '%dfoo%2=%04s%%bar',
        '123',
        'abc',
        'hoge',
    );
    is $str->as_string(), '123fooaahoge%bar';
};

subtest 'overload' => sub {
    my $str = new(
        '%dfoo%2=%04s%%bar',
        '123',
        'abc',
        'hoge',
    );
    is "$str", '123fooaahoge%bar';
};

done_testing;

