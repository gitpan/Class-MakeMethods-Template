#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash (
  new => 'new',
  'array --get_set_ref' => 'foo'
);

package main;

my $o = X->new;

TEST { 1 };
TEST { ! scalar @{$o->foo} };
TEST { $o->foo(123, 456) };

TEST { scalar( @a = $o->foo ) };
TEST { scalar(@a) == 2 and $o->foo->[1] == 456 };

TEST { ! scalar( @a = $o->foo([]) ) };
TEST { ! scalar @{$o->foo} };
TEST { $o->foo(['b', 'c', 'd']) };
TEST { scalar( @a = $o->foo) == 3 and $o->foo->[1] eq 'c' };

exit 0;

