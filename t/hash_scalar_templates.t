#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash (
  new => 'new',
  'scalar' => [
    -interface =>{ 'get_*' => 'get', 'set_*' => 'set_return' }, qw/ d e /,
    -interface => 'eiffel'        => 'g',
    -interface => 'java'          => 'h',
    -interface => 'with_clear'    => 'i',
    -interface => 'noclear'       => 'f',
  ]
);

package main;

my $o = new X;

TEST { 1 };

TEST { ! $o->can ('d') };			# 12
TEST { ! $o->can ('clear_e') };			# 13
TEST { ! defined $o->get_d };			# 14
TEST { ! defined $o->set_d ('foo') };		# 15
TEST { $o->get_d eq 'foo' };			# 16
TEST { ! defined $o->set_d (undef) };		# 17
TEST { ! defined $o->get_d };			# 18

TEST { $o->can ('f') and ! $o->can ('clear_f') and
	 ! $o->can ('set_f') and ! $o->can ('get_f') };

TEST { $o->can ('g') and ! $o->can ('clear_g') and
	 $o->can ('set_g') and ! $o->can ('get_g') };
TEST { ! $o->can ('h') and ! $o->can ('clear_h') and
	 $o->can ('seth') and $o->can ('geth') };
TEST { $o->can ('i') and $o->can ('clear_i') and
	 ! $o->can ('set_i') and ! $o->can ('get_i') };

exit 0;

