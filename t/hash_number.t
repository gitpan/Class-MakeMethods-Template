#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash (
  new     => 'new',
  number  => [ qw/ a b c /]
);

package main;

my $o = X->new();

TEST { 1 };
TEST { $o->a == 0 };
TEST { $o->a(123) };
TEST { $o->a == 123 };
TEST { $o->a(undef) == 0 };
TEST { $o->a == 0 };
TEST { $o->a("456") };
TEST { $o->a == 456 };
TEST { $o->a(undef) == 0 };
TEST { $o->a == 0 };
TEST { ! eval { $o->a("Foo"); 1 } };

exit 0;

