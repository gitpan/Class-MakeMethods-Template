#!/usr/bin/perl

package X;

use Class::MakeMethods::Template::Static (
  'scalar --with_clear' => [ qw / a b / ],
  'scalar --with_clear' => 'c'
);

sub new { bless {}, shift; }

package main;
use lib qw ( ./t );
use Test;

my $o = new X;
my $o2 = new X;

TEST { 1 };
TEST { ! defined $o->a };
TEST { $o->a(123) };
TEST { $o->a == 123 };
TEST { $o2->a == 123 };
TEST { ! defined $o2->clear_a };
TEST { ! defined $o->a };

TEST { ! defined $o->b };
TEST { $o->b('hello world') };
TEST { $o->b eq 'hello world' };
TEST { $o2->b eq 'hello world' };
TEST { ! defined $o2->clear_b };
TEST { ! defined $o->b };

my $foo = 'this';
TEST { ! defined $o->c };
TEST { $o->c(\$foo) };

$foo = 'that';

TEST { $o->c eq \$foo };
TEST { $o2->c eq \$foo };
TEST { ${$o->c} eq ${$o2->c}};
TEST { ${$o->c} eq 'that'};
TEST { ${$o->c} eq 'that'};
TEST { ! defined $o2->clear_c };
TEST { ! defined $o->c };

exit 0;

