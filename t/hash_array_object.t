#!/usr/bin/perl

package Y;
my $count = 0;
sub new { bless { id => $count++ }, shift; }
sub id { shift->{id}; }

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Hash (
  array_of_objects  => [ '-class' => 'Y', { name => 'a', delegate => 'id' } ],
);

sub new { bless {}, shift; }
my $o = new X;

TEST { 1 };

TEST { $o->push_a (Y->new) };
TEST { $o->push_a (Y->new) };
TEST { $o->pop_a->id == 1  };
TEST { $o->push_a (Y->new) };
TEST { @b = $o->a; @b == 2 };
TEST { join (' ', $o->id) eq '0 2' };
TEST { $a = 1; for ($o->a) { $a &&= ( ref ($_) eq 'Y' ) }; $a };

exit 0;

