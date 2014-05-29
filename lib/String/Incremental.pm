package String::Incremental;
use 5.008005;
use strict;
use warnings;
use Mouse;
use MouseX::Types::Mouse qw( Str ArrayRef );
use String::Incremental::FormatParser;
use String::Incremental::Char;

use overload (
    '""' => \&as_string,
    '++' => \&increment,
    '--' => \&decrement,
    '='  => sub { $_[0] },
);

our $VERSION = "0.01";

has 'format' => ( is => 'ro', isa => Str );
has 'items'  => ( is => 'ro', isa => ArrayRef );

sub BUILDARGS {
    my ($class, @args) = @_;
    my $p = String::Incremental::FormatParser->new( @args );

    return +{
        format => $p->format,
        items  => $p->items,
    };
}

sub as_string {
    my ($self) = @_;
    my @vals = map "$_", @{$self->items};
    return sprintf( $self->format, @vals );
}

sub increment {
    my ($self) = @_;
    my ($last_ch) = grep $_->isa( __PACKAGE__ . '::Char' ), reverse @{$self->items};
    if ( defined $last_ch ) {
        $last_ch++;
    }
    return "$self";
}

sub decrement {
    my ($self) = @_;
    my ($last_ch) = grep $_->isa( __PACKAGE__ . '::Char' ), reverse @{$self->items};
    if ( defined $last_ch ) {
        $last_ch--;
    }
    return "$self";
}

__PACKAGE__->meta->make_immutable();
__END__

=encoding utf-8

=head1 NAME

String::Incremental - incremental string with your rule

=head1 SYNOPSIS

    use String::Incremental;

    my $str = String::Incremental->new(
        'foo-%2s-%2=-%=',
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

=head1 CONSTRUCTORS

=over 4

=item new( @args ) : String::Incremental

$args[0] : Str

$args[1], $args[2], ... : (Str|ArrayRef) or (Str|CodeRef)

=back

=head1 METHODS

=over 4

=item as_string() : Str

returns "current" string.

following two variables are equivalent:

    my $a = $str->as_string();
    my $b = "$str";

=item increment() : Str

increases positional state of order and returns its character.

following two operation are equivalent:

    $str->increment();
    $str++;

=item decrement() : Str

decreases positional state of order and returns its character.

following two operation are equivalent:

    $str->decrement();
    $str--;

=back

=head1 LICENSE

Copyright (C) issm.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

issm E<lt>issmxx@gmail.comE<gt>

=cut
