#!/usr/bin/perl

package X;

use lib qw ( ./t );
use Test;

use Class::MakeMethods::Template::Hash (
  'string --get_concat' => 'x',
  'string --get_concat' => {'name' => 'y', 'join' => "\t"},
);

sub new { bless {}, shift; }

my $o = new X;

TEST { 1 };
TEST { $o->x eq "" };
TEST { $o->x('foo') };
TEST { $o->x eq 'foo' };
TEST { $o->x('bar') };
TEST { $o->x eq 'foobar' };
TEST { ! defined $o->clear_x };
TEST { $o->x eq "" };

TEST { $o->y eq "" };
TEST { $o->y ('one') };
TEST { $o->y eq 'one' };
TEST { $o->y ('two') };
TEST { $o->y eq "one\ttwo" };

exit 0;

