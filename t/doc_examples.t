#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package MyObject;

use Class::MakeMethods::Template::Hash (
    new             => [ 'new' ],
    'scalar'        => [ 'foo', 'bar' ]
);

package main;

my $obj;
TEST { $obj = MyObject->new( foo => "Foozle", bar => "Bozzle" ) };
TEST { $obj->foo() eq "Foozle" };
TEST { $obj->bar("Bamboozle") };

