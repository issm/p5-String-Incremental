[![Build Status](https://travis-ci.org/issm/p5-String-Incremental.png?branch=master)](https://travis-ci.org/issm/p5-String-Incremental)
# NAME

String::Incremental - incremental string with your rule

# SYNOPSIS

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

# DESCRIPTION

String::Incremental is ...

# CONSTRUCTORS

- new( @args ) : String::Incremental

    $args\[0\] : Str

    $args\[1\], $args\[2\], ... : (Str|ArrayRef) or (Str|CodeRef)

# METHODS

- as\_string() : Str

    returns "current" string.

    following two variables are equivalent:

        my $a = $str->as_string();
        my $b = "$str";

- set( $val : Str|ArrayRef ) : String::Incremental

    sets "incrementable" cheracters to $val.

- increment() : Str

    increases positional state of order and returns its character.

    following two operation are equivalent:

        $str->increment();
        $str++;

- decrement() : Str

    decreases positional state of order and returns its character.

    following two operation are equivalent:

        $str->decrement();
        $str--;

# LICENSE

Copyright (C) issm.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

issm <issmxx@gmail.com>
