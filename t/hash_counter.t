#!/usr/bin/perl

package X;

use Class::MakeMethods::Template::Static
  'number --counter' => [ qw / a b / ];

package main;
use lib qw ( ./t );
use Test;

TEST { 1 };
TEST { X->a == 0 };
TEST { X->a == 0 };
TEST { X->a_incr == 1 };
TEST { X->a_incr == 2 };
TEST { X->a == 2 };
TEST { X->b == 0 };
TEST { X->b_incr == 1 };

exit 0;

