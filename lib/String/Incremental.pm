package String::Incremental;
use 5.008005;
use strict;
use warnings;
use Mouse;

our $VERSION = "0.01";

sub new {
}

__PACKAGE__->meta->make_immutable();
__END__

=encoding utf-8

=head1 NAME

String::Incremental - incremental string with your rule

=head1 SYNOPSIS

    use String::Incremental;

    my $str = String::Incremental->new(
        'foo-%2s-%2c-%c',
        sub { (localtime)[5] - 100 },
        [0..2],
        'abcd',
    );

    print "$str";  # -> 'foo-14-00-a'

    $str++; $str++;
    print "$str";  # -> 'foo-14-00-c'

    $str++; $str++;
    print "$str";  # -> 'foo-14-01-a'

    ...

    print "$str";  # -> 'foo-14-22-d';
    $str++;  # dies

=head1 DESCRIPTION

String::Incremental is ...

=head1 LICENSE

Copyright (C) issm.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=cut
