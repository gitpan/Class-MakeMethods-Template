#!/usr/bin/perl

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Static (
  'code' => [ qw / a b / ],
  'code' => 'c'
);

sub foo { "foo" };
sub bar { $_[0] };

TEST { 1 };
TEST { X->a(\&foo) };
TEST { X->a eq 'foo' };
TEST { X->b(\&bar) };
TEST { X->b('xxx') eq 'xxx' };
TEST { X->c(sub { "baz" } ) };
TEST { X->c eq 'baz' };

exit 0;

