#!/usr/bin/perl

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Hash (
  'string_index' => [ qw / a b / ],
  'string_index' => 'c'
);

sub new { bless {}, shift; }
my $o = new X;
my $o2 = new X;

TEST { 1 };

TEST { $o->a(123) };
TEST { $o->a == 123 };
TEST { X->find_a(123) eq $o };
TEST {
  $o2->a(456);
  my @f = X->find_a(123, 456);
  $f[0] eq $o or return 0;
  $f[1] eq $o2 or return 0;
};

TEST { $o->a('foo') };
TEST { ! defined X->find_a(123) };
TEST { X->find_a('foo') eq $o };
TEST { $o->a(456) };
TEST { X->find_a(456) eq $o };

my $h;
$o2->a(789);
TEST { $h = X->find_a };
TEST { ref $h eq 'HASH' };
TEST { scalar keys %$h == 2 };
TEST { $h->{456} eq $o };
TEST { $h->{789} eq $o2 };

TEST { ! $o2->clear_a };
TEST { ! defined X->find_a(789) };

exit 0;

