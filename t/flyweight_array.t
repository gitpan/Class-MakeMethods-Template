#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Flyweight (
  new => 'new',
  array => [ qw / a b / ]
);

package main;

my $o = X->new;
my $o2 = X->new;

TEST { 1 };
TEST { ! scalar @{$o->a} };
TEST { $o->push_a(123, 456) };
TEST { $o->unshift_a('baz') };
TEST { $o->pop_a == 456 };
TEST { $o->shift_a eq 'baz' };
TEST { ! scalar @{$o2->a} };
TEST { $o2->push_a(123, 456) };

TEST { $o->b(123, 'foo', qw / a b c /, 'bar') };
TEST {
  my @l = $o->b;
  $l[0] == 123 and
  $l[1] eq 'foo' and
  $l[2] eq 'a' and
  $l[3] eq 'b' and
  $l[4] eq 'c' and
  $l[5] eq 'bar'
};

TEST {
  $o->splice_b(1, 2, 'baz');
  my @l = $o->b;
  $l[0] == 123 and
  $l[1] eq 'baz' and
  $l[2] eq 'b' and
  $l[3] eq 'c' and
  $l[4] eq 'bar'
};

TEST { ref $o->b_ref eq 'ARRAY' };
TEST { ! scalar @{$o->clear_b} };
TEST { ! scalar @{$o->b} };

TEST {
  my @l = $o2->a;
  $l[0] == 123 and
  $l[1] == 456
};

exit 0;

