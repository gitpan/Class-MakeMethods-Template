#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Struct (
  new     => 'new',
  'scalar'  => [ qw/ a b c /]
);

package main;

my $o = X->new();

TEST { 1 };
TEST { ! defined $o->a };
TEST { $o->a(123) };
TEST { $o->a == 123 };
TEST { ! defined $o->a(undef) };
TEST { ! defined $o->a };
TEST { $o->a(456) };
TEST { $o->a == 456 };
TEST { ! defined $o->a (undef) };
TEST { ! defined $o->a };

exit 0;

