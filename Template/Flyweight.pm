package Class::MakeMethods::Template::Flyweight;

use Class::MakeMethods::Template::Generic;
@ISA = qw( Class::MakeMethods::Template::Generic );

use strict;
require 5.0;

=head1 NAME

B<Class::MakeMethods::Template::Flyweight> - Method interfaces for flyweight objects

=head1 SYNOPSIS

  package MyObject;
  use Class::MakeMethods::Template::Flyweight (
    new             => [ 'new' ]
    scalar          => [ 'foo', 'bar' ]
  );
  
  package main;

  my $obj = MyObject->new( foo => "Foozle", bar => "Bozzle" );
  print $obj->foo();		# Prints Foozle
  $obj->bar("Bamboozle"); 	# Sets $obj->{bar}

=head1 DESCRIPTION

Supports the Generic object constructor and accessors meta-method
types, but uses scalar refs as the underlying implementation type,
with member data stored in external indices.

Each method stores the values associated with various objects in
an hash keyed by the object's stringified identity. Since that hash
is accessible only from the generated closures, it is impossible
for foreign code to manipulate those values except through the
method interface. (Caveat: the _flyweight_class_info class method
currently exposes the meta-method information; this method should
become private RSN.) A DESTROY method is installed to call the
_destroy_flyweight_info method, removing data for expired objects
from the various hashes, or you can call the _destroy_flyweight_info
method from your own DESTROY method.

B<Common Parameters>: The following parameters are defined for
Flyweight meta-methods.

=over 4

=item data

An auto-vivified reference to a hash to be used to store the values
for each object.

=back

Note that using Flyweight meta-methods causes the installation of
a DESTROY method in the calling class, which deallocates data for
each instance when it is discarded.

NOTE: This needs some more work to properly handle inheritance.

=cut

my %ClassInfo;
my %Data;

sub generic {
  {
    '-import' => { 
      'Template::Generic:generic' => '*' 
    },
    'code_expr' => { 
      '_VALUE_' => '_ATTR_{data}->{_SELF_}',
    },
    'behavior' => {
      -register => [ sub {
	my $m_info = shift;
	my $class_info = ( $ClassInfo{$m_info->{target_class}} ||= [] );
	return (
	  _flyweight_class_info => sub { @$class_info },
	  _destroy_flyweight_info => \&_destroy_flyweight_info,
	  'DESTROY' => sub { ( $_[0] )->_destroy_flyweight_info },
	);
      } ],
    }
  }
}

sub _destroy_flyweight_info {
  my $self = shift;
  foreach ( $self->_flyweight_class_info() ) {
    delete $_->{data}->{$self};
  }
}

########################################################################

=head2 new

Creates a new scalar ref object.

See the documentation on C<Scalar:new> for interfaces and behaviors.

=cut

sub new {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Scalar:new' => '*',
    },
  }
}

########################################################################

=head2 scalar

Creates flyweight accessor methods which will store a scalar value for each instance.

See the documentation on C<Generic:scalar> for interfaces and behaviors.

=cut

sub scalar {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:scalar' => '*', 
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:string' => '*',
    },
  }
}

sub number {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:number' => '*',
    },
  }
}

sub boolean {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
  }
}

########################################################################

=head2 boolean_index

  boolean_index => [ qw / foo bar baz / ]

Like Flyweight:boolean, boolean_index creates x, set_x, and clear_x
methods. However, it also defines a class method find_x which returns
a list of the objects which presently have the x-flag set to
true. 

Note that to free items from memory, you must clear these bits!

=cut

sub boolean_index {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
    'interface' => {
      default => { 
	  '*'=>'get_set', 'set_*'=>'set_true', 'clear_*'=>'set_false',
	  'find_*'=>'find_true', 
      },
    },
    'behavior' => {
      '-init' => [ sub { 
	my $m_info = $_[0]; 
	defined $m_info->{data} or $m_info->{data} = {};
	return;
      } ],
      'set_true' => q{ _SET_VALUE_{ _SELF_ } },
      'set_false' => q{ delete _VALUE_; 0 },
      'find_true' => q{
	  values %{ _ATTR_{data} };
	},
    },
  }
}

sub string_index {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:string_index' => '*',
    },
    'interface' => {
      default => { 
	  '*'=>'get_set', 'set_*'=>'set_true', 'clear_*'=>'set_false',
	  'find_*'=>'find_true', 
      },
    },
    'code_expr' => { 
      _INDEX_HASH_ => '_ATTR_{data}',
      _GET_FROM_INDEX_ => q{ 
	  if (defined ( my $old_v = _GET_VALUE_ ) ) {
	    delete _ATTR_{'data'}{ $old_v };
	  }
	},
      _REMOVE_FROM_INDEX_ => q{ 
	  if (defined ( my $old_v = _GET_FROM_INDEX_ ) ) {
	    delete _ATTR_{'data'}{ $old_v };
	  }
	},
      _ADD_TO_INDEX_{} => q{ 
	  if (defined ( my $new_value = _GET_VALUE_ ) ) {
	    if ( my $old_item = _ATTR_{'data'}{$new_value} ) {
	      # There's already an object stored under that value so we
	      # need to unset it's value.
	      # And maybe issue a warning? Or croak?
	      my $m_name = _ATTR_{'name'};
	      $old_item->$m_name( undef );
	    }
	    
	    # Put ourself in the index under that value
	    _ATTR_{'data'}{ * } = _SELF_;
	  }
	},
    },
    'behavior' => {
      '-init' => [ sub { 
	my $m_info = $_[0]; 
	defined $m_info->{data} or $m_info->{data} = {};
	return;
      } ],
      'get' => q{ 
	  return _GET_FROM_INDEX_; 
	},
      'set' => q{ 
	  my $new_value = shift;
	  
	  _REMOVE_FROM_INDEX_
	  
	  _ADD_TO_INDEX_{ $new_value }
	},
      'clear' => q{
	  _REMOVE_FROM_INDEX_
	},
    },
  }
}

########################################################################

=head2 array

Creates flyweight accessor methods which will store an array-ref value for each instance.

See the documentation on C<Generic:array> for interfaces and behaviors.

=cut

sub array {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:array' => '*', 
    },
  }
}

########################################################################

=head2 hash

Creates flyweight accessor methods which will store a hash-ref value for each instance.

See the documentation on C<Generic:hash> for interfaces and behaviors.

=cut

sub hash {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:hash' => '*',
    },
  } 
}

########################################################################

=head2 code

Creates flyweight accessor methods which will store a subroutine reference for each instance.

See the documentation on C<Generic:code> for interfaces, behaviors, and parameters.

=cut

sub code {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:code' => '*', 
    },
  }
}

########################################################################

=head2 bits

NEEDS TESTING

=cut

sub bits {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:bits' => '*', 
    },
  }
}

########################################################################

=head2 instance

NEEDS TESTING

=cut

sub instance {
  {
    '-import' => { 
      'Template::Flyweight:generic' => '*',
      'Template::Generic:instance' => '*',
    },
  } 
}

1;
