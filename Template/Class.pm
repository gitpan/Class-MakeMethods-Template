package Class::MakeMethods::Template::Class;

use Class::MakeMethods::Template::Generic;
BEGIN { @ISA = qw( Class::MakeMethods::Template::Generic ); }

use strict;
require 5.0;
use Carp;

=head1 NAME

B<Class::MakeMethods::Template::Class> - Associate information with a package

=head1 SYNOPSIS

  package MyObject;
  use Class::MakeMethods::Template::Class (
    scalar          => [ 'foo' ]
  );
  
  package main;
  
  MyObject->foo('bar')
  print MyObject->foo();

=head1 DESCRIPTION

These meta-methods provide access to class-specific values. They are similar to Static, except that each subclass has separate values.

=cut

sub generic {
  {
    '-import' => { 
      'Template::Generic:generic' => '*' 
    },
    'modifier' => {
    },
  }
}

########################################################################

=head2 Class:scalar

Creates methods to handle a scalar variable in the declaring package.

See the documentation on C<Generic:scalar> for interfaces and behaviors.

=cut

sub scalar {
  {
    '-import' => { 
      'Template::Class:generic' => '*',
      'Template::Generic:scalar' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '_ATTR_{data}->{_SELF_CLASS_}',
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::Class:generic' => '*',
      'Template::Generic:string' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '_ATTR_{data}->{_SELF_CLASS_}',
    },
  }
}

sub number {
  {
    '-import' => { 
      'Template::Class:generic' => '*',
      'Template::Generic:number' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '_ATTR_{data}->{_SELF_CLASS_}',
    },
  }
}

sub boolean {
  {
    '-import' => { 
      'Template::Class:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '_ATTR_{data}->{_SELF_CLASS_}',
    },
  }
}

########################################################################

=head2 Class:array

Creates methods to handle a array variable in the declaring package.

See the documentation on C<Generic:array> for interfaces and behaviors.

=cut

sub array {
  {
    '-import' => { 
      'Template::Class:generic' => '*',
      'Template::Generic:array' => '*',
    },
    'modifier' => {
      '-all' => q{ _REF_VALUE_ or @{_ATTR_{data}->{_SELF_CLASS_}} = (); * },
    },
    'code_expr' => {
      '_VALUE_' => '\@{_ATTR_{data}->{_SELF_CLASS_}}',
    },
  } 
}

########################################################################

=head2 Class:hash

Creates methods to handle a hash variable in the declaring package.

See the documentation on C<Generic:hash> for interfaces and behaviors.

=cut

sub hash {
  {
    '-import' => { 
      'Template::Class:generic' => '*',
      'Template::Generic:hash' => '*',
    },
    'modifier' => {
      '-all' => q{ _REF_VALUE_ or %{_ATTR_{data}->{_SELF_CLASS_}} = (); * },
    },
    'code_expr' => {
      '_VALUE_' => '\%{_ATTR_{data}->{_SELF_CLASS_}}',
    },
  } 
}

1;
