# NAME

String::Incremental - incremental string with your rule

# SYNOPSIS

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

# DESCRIPTION

String::Incremental is ...

# LICENSE

Copyright (C) issm.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

issm <issmxx@gmail.com>
