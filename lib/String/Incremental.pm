package String::Incremental;
use 5.008005;
use strict;
use warnings;
use Mouse;
use MouseX::Types::Mouse qw( Str ArrayRef is_Str );
use String::Incremental::Types qw( Char );
use String::Incremental::FormatParser;
use String::Incremental::Char;
use Data::Validator;
use Try::Tiny;

use overload (
    '""' => \&as_string,
    '++' => \&increment,
    '--' => \&decrement,
    '='  => sub { $_[0] },
);

extends 'Exporter';

our $VERSION = "0.01";

our @EXPORT_OK = qw( incremental_string );

has 'format' => ( is => 'ro', isa => Str );
has 'items'  => ( is => 'ro', isa => ArrayRef );
has 'chars'  => ( is => 'ro', isa => ArrayRef['String::Incremental::Char'] );

sub BUILDARGS {
    my ($class, %args) = @_;
    my $v = Data::Validator->new(
        format => { isa => Str },
        orders => { isa => ArrayRef, default => [] },
    );
    %args = %{$v->validate( \%args )};

    my $p = String::Incremental::FormatParser->new( $args{format}, @{$args{orders}} );

    return +{
        format => $p->format,
        items  => $p->items,
        chars  => [ grep $_->isa( __PACKAGE__ . '::Char' ), @{$p->items} ],
    };
}

sub incremental_string {
    my ($format, @orders) = @_;
    return __PACKAGE__->new( format => $format, orders => \@orders );
}

sub char {
    my ($self, $i) = @_;
    my $ch;
    unless ( defined $i ) {
        die 'index to set must be specified';
    }
    unless ( $i =~ /^\d+$/ ) {
        die 'must be specified as Int';
    }
    unless ( defined ( $ch = $self->chars->[$i] ) ) {
        die 'out of index';
    }
    return $ch;
}

sub as_string {
    my ($self) = @_;
    my @vals = map "$_", @{$self->items};
    return sprintf( $self->format, @vals );
}

sub set {
    my $v = Data::Validator->new(
        val => { isa => Str|ArrayRef[Char] },
    )->with( 'Method', 'StrictSequenced' );
    my ($self, $args) = $v->validate( @_ );
    my $val = $args->{val};
    if ( is_Str( $val ) ) {
        $val = [ split //, $val ];
    }

    if ( @$val != @{$self->chars} ) {
        my $msg = 'size mismatch: specified value v.s. chars';
        die $msg;
    }

    my @ng;
    for ( my $i = 0; $i < @$val; $i++ ) {
        my $ch = $self->char( $i );
        try {
            $ch->set( $val->[$i], { test => 1 } );
        } catch {
            my ($msg) = @_;
            push @ng, +{ ch => $ch, msg => $msg };
        };
    }
    if ( @ng ) {
        my $chars = join ',', map "$_->{ch}", @ng;
        my $msg = sprintf 'problem has occured in: %s', $chars;
        die $msg;
    }
    else {
        for ( my $i = 0; $i < @$val; $i++ ) {
            my $ch = $self->char( $i );
            $ch->set( $val->[$i] );
        }
    }

    return "$self";
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

sub re {
    my ($self) = @_;
    my ($re, @re);

    @re = map {
        my $i = $_;
        my $_re = $i->re();
        my $ref = ref $_;
        $ref eq __PACKAGE__ . '::Char' ? "(${_re})" : $_re;
    } @{$self->items};

    (my $fmt = $self->format) =~ s/%(?:\d+(?:\.?\d+)?)?\S/\%s/g;
    $re = sprintf $fmt, @re;

    return qr/^(${re})$/;
}

__PACKAGE__->meta->make_immutable();
__END__

=encoding utf-8

=head1 NAME

String::Incremental - incremental string with your rule

=head1 SYNOPSIS

    use String::Incremental;

    my $str = String::Incremental->new(
        format => 'foo-%2=-%=',
        orders => [
            [0..2],
            'abcd',
        ],
    );

    # or

    use String::Incremental qw( incremental_string );

    my $str = incremental_string(
        'foo-%2=-%=',
        [0..2],
        'abcd',
    );

    print "$str";  # -> 'foo-00-a'

    $str++; $str++; $str++;
    print "$str";  # -> 'foo-00-d'

    $str++;
    print "$str";  # -> 'foo-01-a'

    $str->set( '22d' );
    print "$str";  # -> 'foo-22-d';
    $str++;  # dies, cannot ++ any more

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

=item set( $val : Str|ArrayRef ) : String::Incremental

sets "incrementable" cheracters to $val.

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
