#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash (
  new      => 'new',
  'scalar --self_closure' => 'a b',
);

package main;

TEST { 1 };

my $o = X->new();
my $o2 = X->new();

my $oa = $o->a();
my $ob = $o->b();
my $o2a = $o2->a();

TEST { $oa and $ob and $o2a };

TEST { ! defined &$oa() };
TEST { &$oa(123) };
TEST { &$oa() == 123 };

TEST { ! defined &$o2a() };
TEST { &$o2a(911) };
TEST { &$o2a() == 911 };
TEST { ! defined &$o2a(undef) };

TEST { ! defined &$oa(undef) };
TEST { ! defined &$oa() };
TEST { &$oa(456) };
TEST { &$oa() == 456 };

TEST { ! defined &$ob() };
TEST { &$ob(911) };
TEST { &$ob() == 911 };
TEST { ! defined &$ob(undef) };

TEST { ! defined &$oa (undef) };
TEST { ! defined &$oa() };

exit 0;

