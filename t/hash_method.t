#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash (
  'new' => 'new',
  'code --method' => [ qw / a b / ],
  'code --method' => 'c'
);

package main;

sub meth { $_[0] };
sub foo { "foo" };
sub bar { $_[0] };

my $o = new X;

TEST { 1 };
#TEST { eval { $o->a }; !$@ }; # Ooops! this is broken at the moment.
TEST { $o->a(\&foo) };
TEST { $o->a eq 'foo' };
TEST { $o->b(\&bar) };
TEST { $o->b('xxx') eq $o };
TEST { $o->c(sub { "baz" } ) };
TEST { $o->c eq 'baz' };

exit 0;

