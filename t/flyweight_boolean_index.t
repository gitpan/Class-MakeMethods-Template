#!/usr/bin/perl

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Flyweight (
  boolean_index => [ qw / a b / ],
  boolean_index => 'c'
);

sub new { bless {}, shift; }
my $o = new X;

TEST { 1 };

TEST { ! $o->a };
TEST { ! $o->b };
TEST { ! $o->c };

TEST { $o->a(1); };
TEST { $o->a };

TEST { $o->set_a };
TEST { $o->a };

TEST { ! $o->a(0) };
TEST { ! $o->a };

TEST { ! $o->clear_a; };
TEST { ! $o->a };

my $a = new X;
my $b = new X;
my $c = new X;
$a->set_a;
$b->set_a;
$c->set_a;


TEST {
  my %h = map { $_, $_ } X->find_a;
  foreach (values %h) {
    $_->a or return 0;
  }
  return 1;
};

TEST {
  my %h = map { $_, $_ } X->find_a;
  $h{$a} and $h{$b} and $h{$c};
};

TEST {
  $b->clear_a;
  my %h = map { $_, $_  } X->find_a;
  $h{$a} and !$h{$b} and $h{$c}
};


exit 0;

