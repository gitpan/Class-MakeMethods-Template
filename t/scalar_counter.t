#!/usr/local/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Scalar ( 
  'new' => 'new',
  'number --counter' => [ qw / a b / ]
);

package main;

my $o = X->new;

# Note that Scalar refs only have a single value, so a and b affect 
# the same underlying data.

TEST { 1 };
TEST { $o->a == 0 };
TEST { $o->a == 0 };
TEST { $o->a_incr == 1 };
TEST { $o->a_incr == 2 };
TEST { $o->a == 2 };
TEST { $o->b == 2 };
TEST { $o->b_incr == 3 };
TEST { $o->a == 3 };

exit 0;
