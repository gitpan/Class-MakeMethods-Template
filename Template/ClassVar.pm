package Class::MakeMethods::Template::ClassVar;

use Class::MakeMethods::Template::Generic;
BEGIN { @ISA = qw( Class::MakeMethods::Template::Generic ); }

use strict;
require 5.0;
use Carp;

=head1 NAME

B<Class::MakeMethods::Template::ClassVar> - Static methods with subclass variation

=head1 SYNOPSIS

  package MyObject;
  use Class::MakeMethods::Template::ClassVar (
    scalar          => [ 'foo' ]
  );
  
  package main;

  MyObject->foo('bar')
  print MyObject->foo();

  $MyObject::foo = 'bazillion';
  print MyObject->foo();

=head1 DESCRIPTION

These meta-methods provide access to package (class global) variables,
with the package determined at run-time.

This is basically the same as the PackageVar meta-methods, except
that PackageVar methods find the named variable in the package that
defines the method, while ClassVar methods use the package the object
is blessed into. As a result, subclasses will each store a distinct
value for a ClassVar method, but will share the same value for a
PackageVar or Static method.

B<Common Parameters>: The following parameters are defined for ClassVar meta-methods.

=over 4

=item variable

The name of the variable to store the value in. Defaults to the same name as the method.

=back

=cut

sub generic {
  {
    '-import' => { 
      'Template::Generic:generic' => '*' 
    },
    'params' => { 
      'variable' => '*' 
    },
    'modifier' => {
      '-all' => [ q{ no strict; * } ],
    },
  }
}

########################################################################

=head2 scalar

Creates methods to handle a scalar variable in the package of an instance.

See the documentation on C<Generic:scalar> for interfaces and behaviors.

=cut

sub scalar {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:scalar' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '${_SELF_CLASS_."::"._ATTR_{variable}}',
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:string' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '${_SELF_CLASS_."::"._ATTR_{variable}}',
    },
  }
}

sub number {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:number' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '${_SELF_CLASS_."::"._ATTR_{variable}}',
    },
  }
}

sub boolean {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '${_SELF_CLASS_."::"._ATTR_{variable}}',
    },
  }
}

sub object {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:object' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '${_SELF_CLASS_."::"._ATTR_{variable}}',
    },
  }
}

sub instance {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:instance' => '*',
    },
    'code_expr' => {
      '_VALUE_' => '${_SELF_CLASS_."::"._ATTR_{variable}}',
    },
  }
}

########################################################################

=head2 array

Creates methods to handle a array variable in the package of an instance.

See the documentation on C<Generic:array> for interfaces and behaviors.

=cut

sub array {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:array' => '*',
    },
    'modifier' => {
      '-all' => q{ no strict; _ENSURE_REF_VALUE_; * },
    },
    'code_expr' => {
      '_ENSURE_REF_VALUE_' => q{ 
	_REF_VALUE_ or @{_SELF_CLASS_."::"._ATTR_{variable}} = (); 
      },
      '_VALUE_' => '(\@{_SELF_CLASS_."::"._ATTR_{variable}})',
    },
  } 
}

########################################################################

=head2 hash

Creates methods to handle a hash variable in the package of an instance.

See the documentation on C<Generic:hash> for interfaces and behaviors.

=cut

sub hash {
  {
    '-import' => { 
      'Template::ClassVar:generic' => '*',
      'Template::Generic:hash' => '*',
    },
    'modifier' => {
      '-all' => q{ no strict; _ENSURE_REF_VALUE_; * },
    },
    'code_expr' => {
      '_ENSURE_REF_VALUE_' => q{ 
	_REF_VALUE_ or %{_SELF_CLASS_."::"._ATTR_{variable}} = (); 
      },
      '_VALUE_' => '(\%{_SELF_CLASS_."::"._ATTR_{variable}})',
    },
  } 
}

########################################################################

=head2 vars

This rewrite rule converts package variable names into ClassVar methods of the equivalent data type.

Here's an example declaration:

  package MyClass;
  
  use Class::MakeMethods::Template::ClassVar (
    vars => '$VERSION @ISA'
  );

MyClass now has methods that get and set the contents of its $MyClass::VERSION and @MyClass::ISA package variables:

  MyClass->VERSION( 2.4 );
  MyClass->push_ISA( 'Exporter' );

Subclasses can use these methods to adjust their own variables:

  package MySubclass;
  MySubclass->MyClass::push_ISA( 'MyClass' );
  MySubclass->VERSION( 1.0 );

=cut

sub vars { 
  my $mm_class = shift;
  my @rewrite = map [ "Template::ClassVar:$_" ], qw( scalar array hash );
  my %rewrite = ( '$' => 0, '@' => 1, '%' => 2 );
  while (@_) {
    my $name = shift;
    my $data = shift;
    $data =~ s/\A(.)//;
    push @{ $rewrite[ $rewrite{ $1 } ] }, { 'name'=>$name, 'variable'=>$data };
  }
  return @rewrite;
}

1;
