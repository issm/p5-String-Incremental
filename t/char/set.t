use strict;
use warnings;
use Test::More;
use Test::Exception;
use String::Incremental::Char;

sub new {
    my $ch = String::Incremental::Char->new( @_ );
    return $ch;
}

subtest 'call' => sub {
    my $ch = new( order => 'ace' );
    ok $ch->can( 'set' );
};

subtest 'ng' => sub {
    my $ch = new( order => 'ace' );

    dies_ok {
        $ch->set( 'ae' );
    } 'invalid';

    dies_ok {
        $ch->set( 'x' );
    } 'not in order';

    is "$ch", 'a';
    is $ch->__i, 0;
};

subtest 'ok' => sub {
    my $ch = new( order => 'ace' );

    lives_ok {
        $ch->set( 'e' );
    };

    is "$ch", 'e';
    is $ch->__i, 2;

    $ch->set( 'c' );
    is "$ch", 'c';
    is $ch->__i, 1;
};

done_testing;

