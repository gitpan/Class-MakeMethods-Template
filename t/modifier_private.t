#!/usr/bin/perl

use lib qw ( ./t );
use Test;

package X;

use Class::MakeMethods::Template::Hash ( 
  'new --with_values' => 'new',
  'scalar' => 'a',
  'scalar --protected' => 'b',
  'scalar --private' => 'c',
  'scalar --private --protected --public' => 'd',
  'scalar --protected e --public --private' => 'f',
  'scalar --get_private_set' => 'g',
);

sub x_incr_b {
  my $self = shift; $self->b( $self->b + 1 )
}

sub x_incr_c {
  my $self = shift; $self->c( $self->c + 1 )
}

sub x_incr_e {
  my $self = shift; $self->c( $self->c + 1 )
}

sub x_incr_g {
  my $self = shift; $self->g( $self->g + 1 )
}

package Y;
@ISA = 'X';

sub y_incr_b {
  my $self = shift; $self->b( $self->b + 1 )
}

sub y_incr_c {
  my $self = shift; $self->c( $self->c + 1 )
}

sub y_incr_e {
  my $self = shift; $self->e( $self->e + 1 )
}

sub y_incr_g {
  my $self = shift; $self->g( $self->g + 1 )
}

package main;

TEST { 1 };

my $o = X->new( a=>1 , b=>2, c=>3, d=>4, e=>5, g=>21 );
my $o2 = Y->new( a=>1 , b=>2, c=>3, d=>4, e=>5, g=>21 );

# public
TEST { $o->a(1) };

# public / subclass
TEST { $o2->a(1) };


# protected
TEST { ! eval { $o->b(1); 1 } };
TEST { $o->x_incr_b() };

# protected / subclass
TEST { ! eval { $o2->b(1); 1 } };
TEST { $o2->x_incr_b() };
TEST { $o2->y_incr_b() };


# private
TEST { ! eval { $o->c(1); 1 } };
TEST { $o->x_incr_c() };

# private / subclass
TEST { ! eval { $o2->c(1); 1 } };
TEST { $o2->x_incr_c() };
TEST { ! eval { $o2->y_incr_c(); 1 } };


# public
TEST { $o2->d() };


# protected
TEST { ! eval { $o->e(1); 1 } };
TEST { $o->x_incr_e() };

# protected / subclass
TEST { ! eval { $o2->e(1); 1 } };
TEST { $o2->x_incr_e() };
TEST { $o2->y_incr_e() };

# private
TEST { ! eval { $o->f(1); 1 } };

# private / subclass
TEST { ! eval { $o2->f(1); 1 } };


# private_set
TEST { $o->g() };
TEST { ! eval { $o->g(1); 1 } };
TEST { $o->x_incr_g() };

# private_set / subclass
TEST { $o2->g() };
TEST { ! eval { $o2->g(1); 1 } };
TEST { $o2->x_incr_g() };
TEST { ! eval { $o2->y_incr_g(1); 1 } };

