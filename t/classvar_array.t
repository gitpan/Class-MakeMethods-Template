#!/usr/bin/perl

package X;
use Class::MakeMethods::Template::ClassVar ( 
  'array' => [ qw / a b / ]
);

package Y;
@ISA = 'X';

package main;

use lib qw ( ./t );
use Test;

TEST { 1 };
TEST { ! scalar @{X->a} };
TEST { X->push_a(123, 456) };
TEST { X->unshift_a('baz') };
TEST { ! scalar @{Y->a} };
TEST { X->pop_a == 456 };
TEST { X->shift_a eq 'baz' };
TEST { scalar @{X->a} == 1 };
TEST { Y->push_a(123, 456) };
TEST { scalar @{X->a} == 1 };
TEST { Y->unshift_a('baz') };
TEST { Y->pop_a == 456 };
TEST { Y->shift_a eq 'baz' };

TEST { X->b(123, 'foo', qw / a b c /, 'bar') };
TEST {
  my @l = X->b;
  $l[0] == 123 and
  $l[1] eq 'foo' and
  $l[2] eq 'a' and
  $l[3] eq 'b' and
  $l[4] eq 'c' and
  $l[5] eq 'bar'
};

TEST {
  X->splice_b(1, 2, 'baz');
  my @l = X->b;
  $l[0] == 123 and
  $l[1] eq 'baz' and
  $l[2] eq 'b' and
  $l[3] eq 'c' and
  $l[4] eq 'bar'
};

TEST { ref X->b_ref eq 'ARRAY' };
TEST { ! scalar @{X->clear_b} };
TEST { ! scalar @{X->b} };

exit 0;

