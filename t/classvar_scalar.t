#!/usr/bin/perl

package X;

use Class::MakeMethods::Template::ClassVar (
  'scalar' => [ qw / a b / ],
  'scalar' => { 'name' => 'c', 'variable' => 'Foozle' }
);

sub new { bless {}, shift; }

package Y;

@ISA = 'X';

package main;
use lib qw ( ./t );
use Test;

my $o = new X;
my $o2 = new Y;

TEST { 1 };

TEST { ! defined $o->a };
TEST { $o->a(123) };
TEST { $o->a == 123 };
TEST { X->a == 123 };
TEST { ! $o2->a };
TEST { ! defined $o->a(undef) };
TEST { ! defined $o->a };
TEST { ! defined X->a };

TEST { ! defined $o->b };
TEST { X->b('nevermore') };
TEST { $o->b eq 'nevermore' };
TEST { X->b eq 'nevermore' };
TEST { ! defined $o2->b };
TEST { $o2->b('hello world') };
TEST { $o2->b eq 'hello world' };
TEST { Y->b eq 'hello world' };
TEST { ! defined $o->b(undef) };
TEST { ! defined X->b };
TEST { $o2->b eq 'hello world' };

TEST { ! defined X->c };
TEST { X->c(123) };
TEST { X->c == 123 };
TEST { $X::Foozle == 123 };
TEST { $Y::Foozle = 9 };
TEST { $o2->c == 9 };
TEST { $X::Foozle = 1234 };
TEST { $o->c() == 1234 };
TEST { $o2->c(99) };
TEST { $Y::Foozle == 99 };

exit 0;

