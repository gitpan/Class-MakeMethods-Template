#!/usr/bin/perl

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Static (
  'hash' => [ qw / a b / ],
  'hash' => 'c'
);

sub new { bless {}, shift; }
my $o = new X;
my $o2 = new X;

TEST { 1 };
TEST { ! scalar keys %{$o->a} };
TEST { ! defined $o->a('foo') };
TEST { $o->a_push('foo', 'baz') };
TEST { $o->a('foo') eq 'baz' };
TEST { $o->a_push('bar', 'baz2') };
TEST {
  my @l = $o->a([qw / foo bar / ]);
  $l[0] eq 'baz' and $l[1] eq 'baz2'
};

TEST { $o->a_push(qw / a b c d / ) };
TEST {
  my %h = $o->a;
  my @l = sort keys %h;
  $l[0] eq 'a' and
  $l[1] eq 'bar' and
  $l[2] eq 'c' and
  $l[3] eq 'foo'
};

TEST {
  my %h=('w' => 'x', 'y' => 'z');
  my $rh = \%h;
  my $r = $o->a_push($rh);
};

TEST {
  my @l = sort $o->a_keys;
  $l[0] eq 'a' and
  $l[1] eq 'bar' and
  $l[2] eq 'c' and
  $l[3] eq 'foo' and
  $l[4] eq 'w' and
  $l[5] eq 'y'
};

TEST {
  my @l = sort $o->a_values;
  $l[0] eq 'b' and
  $l[1] eq 'baz' and
  $l[2] eq 'baz2' and
  $l[3] eq 'd' and
  $l[4] eq 'x' and
  $l[5] eq 'z'
};

TEST { $o->b_tally(qw / a b c a b a d / ); };
TEST {
  my %h = $o->b;
  $h{'a'} == 3 and
  $h{'b'} == 2 and
  $h{'c'} == 1 and
  $h{'d'} == 1
};

TEST { ! defined $o->c('foo') };
TEST { defined $o->c };

TEST { $o->a eq $o2->a };

exit 0;

