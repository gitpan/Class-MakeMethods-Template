#!/usr/bin/perl

#########################################################################
# Based on an example in "Object Oriented Perl" by Damian Conway        #
# Copyright (C) 1999 by Manning Publications Co. All Rights Reserved.   #
# Original source taken from: http://www.manning.com/Conway/source.html #
#########################################################################

package Bit::String;

use strict;

use Class::MakeMethods::Template::Scalar (
  'new --with_init' => { name=> 'new', init_method=> 'bit_list' },
  'bits' => { name=> 'foo', 'interface'=> {
    'bit_list'=>'bit_list',	
    'get' => 'bit_pos_get', 'set'=>'bit_pos_set', 'bitcount'=>'bits_size',
    }},
);

sub complement {
  my $self = shift;
  my $complement = ~ $$self;
  bless \$complement, ref($self);
}

sub print_me {
  my $self = shift;
  my $out = '';
  for ( my $i = 0; $i < $self->bitcount(); $i ++ ) {
    $out .= $self->get($i);
    $out .= ' ' unless ( $i +1 ) % 8;
    $out .= "\n" unless ( $i +1 ) % 64;
  }
  $out .= "\n";
  return $out;
}

package main;
use lib qw ( ./t );
use Test;

TEST { 1 };

my $is_lucky;
TEST { $is_lucky = Bit::String->new(1,0,1,0,0,0,1,0,1) };

TEST { $is_lucky->print_me() eq "10100010 10000000 \n" };
TEST { ! $is_lucky->get(12) };
TEST { $is_lucky->get(6) };
TEST { ! $is_lucky->set(6,0) };
TEST { ! $is_lucky->get(6) };
TEST { $is_lucky->print_me() eq "10100000 10000000 \n" };

TEST { $is_lucky->complement()->print_me() eq "01011111 01111111 \n" };
TEST { $is_lucky->complement()->get( 6 ) };
