#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash (
  new     => 'new',
  number  => [ 'c', { 'interface' => { 
    -base => 'counter', '*_incr_func' => '-self_closure incr'
  } } ],
);

package main;

TEST { 1 };

my $o = X->new();

my $single_incr = $o->c_incr_func();
my $double_incr = $o->c_incr_func(2);

TEST { $single_incr and $double_incr };

TEST { $o->c() == 0 };
TEST { $o->c(123) };
TEST { $o->c() == 123 };

TEST { &$single_incr() == 124 };
TEST { $o->c() == 124 };
TEST { &$single_incr() == 125 };
TEST { &$double_incr() == 127 };
TEST { &$double_incr() == 129 };
TEST { $o->c() == 129 };

exit 0;

