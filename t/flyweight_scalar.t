#!/usr/bin/perl

package X;

use Class::MakeMethods::Template::Flyweight (
  new     => 'new',
  'scalar'  => [ qw/ a b c /]
);

package main;
use lib qw ( ./t );
use Test;

my $o = new X;

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

