#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods;

Class::MakeMethods->import( 'Template::Hash:new --with_values' => 'new' );

Class::MakeMethods->import( 'Template::Hash:scalar' => 'b' );
Class::MakeMethods->import( '::Class::MakeMethods::Template::Hash:scalar' => 'b2' );
Class::MakeMethods->import( -MakerClass=>'Template::Hash', 'scalar' => 'c' );
Class::MakeMethods::Template::Hash->import( 'scalar' => 'd' );

Class::MakeMethods->import( 'Template::Hash:scalar' => 'e' );
Class::MakeMethods->import( 'Template::Hash:scalar' => [ 'f' ] );
Class::MakeMethods->import( 'Template::Hash:scalar' => { 'name' => 'g' } );
Class::MakeMethods->import( 'Template::Hash:scalar' => [ { 'name' => 'h' } ] );
Class::MakeMethods->import( 'Template::Hash:scalar' => [ 'i', { 'info'=>"foo" } ] );

package main;

TEST { 1 };

my $o = X->new;

TEST { $o->b(1) };
TEST { $o->c(1) };
TEST { $o->d(1) };

TEST { $o->e(1) };
TEST { $o->f(1) };
TEST { $o->g(1) };
TEST { $o->h(1) };
TEST { $o->i(1) };

