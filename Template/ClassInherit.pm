=head1 NAME

B<Class::MakeMethods::Template::ClassInherit> - Overridable class data

=head1 SYNOPSIS

  package MyClass;

  use Class::MakeMethods( 'Template::ClassInherit:scalar' => 'foo' );
  # We now have an accessor method for an "inheritable" scalar value
  
  package main;
  
  MyClass->foo( 'Foozle' );   # Set a class-wide value
  print MyClass->foo();	      # Retrieve class-wide value
  ...
  
  package MySubClass;
  @ISA = 'MyClass';
  
  print MySubClass->foo();    # Intially same as superclass,
  MySubClass->foo('Foobar');  # but overridable per subclass/

=head1 DESCRIPTION

The MakeMethods subclass provides accessor methods that search an inheritance tree to find a value. This allows you to set a shared or default value for a given class, and optionally override it in a subclass.

=cut

########################################################################

package Class::MakeMethods::Template::ClassInherit;

use Class::MakeMethods::Template::Generic;
BEGIN { @ISA = qw( Class::MakeMethods::Template::Generic ); }

use strict;
require 5.0;
use Carp;

sub generic {
  {
    '-import' => { 
      'Template::Generic:generic' => '*' 
    },
    'modifier' => {
      '-all' => [ q{ 
	_INIT_VALUE_CLASS_
	*
      } ],
    },
    'code_expr' => {
      '_VALUE_CLASS_' => '$_value_class',
      '_INIT_VALUE_CLASS_' => q{ 
	my _VALUE_CLASS_;
	for ( my @_INC_search = _SELF_CLASS_; scalar @_INC_search; ) {
	  _VALUE_CLASS_ = shift @_INC_search;
	  last if ( exists _ATTR_{data}->{_VALUE_CLASS_} );
	  no strict 'refs';
	  unshift @_INC_search, @{"_VALUE_CLASS_\::ISA"};
	}
      },
      '_VALUE_' => '_ATTR_{data}->{_VALUE_CLASS_}',
      '_GET_VALUE_' => q{ _ATTR_{data}->{_VALUE_CLASS_} },
      '_SET_VALUE_{}' => q{ ( _VALUE_CLASS_ = _SELF_CLASS_ and _ATTR_{data}->{_VALUE_CLASS_} = * ) },
    },
  }
}

########################################################################

=head2 ClassInherit:scalar

Creates methods to handle a scalar variable in the declaring package.

See the documentation on C<Generic:scalar> for interfaces and behaviors.

=cut

sub scalar {
  {
    '-import' => [
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:scalar' => '*',
    ],
  }
}

sub string {
  {
    '-import' => [
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:string' => '*',
    ],
  }
}

sub number {
  {
    '-import' => [
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:number' => '*',
    ],
  }
}

sub boolean {
  {
    '-import' => [
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:boolean' => '*',
    ],
  }
}

########################################################################

=head2 ClassInherit:array

Creates methods to handle a array variable in the declaring package.

See the documentation on C<Generic:array> for interfaces and behaviors.

=cut

sub array {
  {
    '-import' => { 
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:array' => '*',
    },
    'modifier' => {
      '-all' => [ q{ _VALUE_ ||= []; * } ],
    },
    'code_expr' => {
      '_VALUE_' => '\@{_ATTR_{data}->{_SELF_CLASS_}}',
    },
  } 
}

########################################################################

=head2 ClassInherit:hash

Creates methods to handle a hash variable in the declaring package.

See the documentation on C<Generic:hash> for interfaces and behaviors.

=cut

sub hash {
  {
    '-import' => { 
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:hash' => '*',
    },
    'modifier' => {
      '-all' => [ q{ _VALUE_ ||= {}; * } ],
    },
    'code_expr' => {
      '_VALUE_' => '\%{_ATTR_{data}->{_SELF_CLASS_}}',
    },
  } 
}

########################################################################

sub object {
  {
    '-import' => [
      'Template::ClassInherit:generic' => '*',
      'Template::Generic:object' => '*',
    ],
  }
}

########################################################################

=head1 SEE ALSO

If you just need scalar accessors, see L<Class::Data::Inheritable> for a very elegant and efficient implementation.

See L<Class::MakeMethods::Template::Generic> for information about the various accessor interfaces subclassed herein.

See L<Class::MakeMethods::ReadMe> for distribution and support information.


=head1 LICENSE

This module is free software. It may be used, redistributed and/or
modified under the same terms as Perl.

Copyright (c) 2001 Evolution Online Systems, Inc.

Developed by:

  M. Simon Cavalletto, Evolution Online Systems, simonm@evolution.com

=cut

########################################################################

1;
