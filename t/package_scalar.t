#!/usr/bin/perl

package X;

use Class::MakeMethods::Template::PackageVar (
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
TEST { $o2->a == 123 };
TEST { ! defined $o2->a(undef) };
TEST { ! defined $o->a };

TEST { ! defined $o->b };
TEST { $o->b('hello world') };
TEST { $o->b eq 'hello world' };
TEST { $o2->b eq 'hello world' };
TEST { ! defined $o2->b(undef) };
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
TEST { ! defined $o2->c(undef) };
TEST { ! defined $o->c };

TEST { ! defined X->c };
TEST { X->c(123) };
TEST { X->c == 123 };
TEST { $X::Foozle = 123 };
TEST { ! defined $Y::Foozle };
TEST { $o2->c == 123 };
TEST { $X::Foozle = 1234 };
TEST { $o->c() == 1234 };
TEST { ! defined $Y::Foozle };

exit 0;

