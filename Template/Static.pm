package Class::MakeMethods::Template::Static;

use Class::MakeMethods::Template::Generic;
@ISA = qw( Class::MakeMethods::Template::Generic );

use strict;
require 5.0;

=head1 NAME

B<Class::MakeMethods::Template::Static> - Method that are not instance-dependent

=head1 SYNOPSIS

  package MyObject;
  use Class::MakeMethods::Template::Static (
    scalar          => [ 'foo' ]
  );
  
  package main;

  MyObject->foo('bar')
  print MyObject->foo();

=head1 DESCRIPTION

These meta-methods access values that are shared across all instances
of your object in your process. For example, a hash_scalar meta-method
will be able to store a different value for each hash instance you
call it on, but a static_scalar meta-method will return the same
value for any instance it's called on, and setting it from any
instance will change the value that all other instances see.

B<Common Parameters>: The following parameters are defined for Static meta-methods.

=over 4

=item data

The shared value.

=back

=cut

sub generic {
  {
    '-import' => { 
      'Template::Generic:generic' => '*' 
    },
    'code_expr' => { 
      _VALUE_ => '_ATTR_{data}',
    },
    'params' => {
      'data' => undef, 
    }
  }
}

########################################################################

=head2 Template::Static:scalar

Creates accessor methods each of which shares a single scalar value.

See the documentation on C<Generic:scalar> for interfaces and behaviors.

=cut

sub scalar {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:scalar' => '*', 
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:string' => '*',
    },
  }
}

sub number {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:number' => '*',
    },
  }
}

sub boolean {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
  }
}

sub object {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:object' => '*',
    },
  }
}

sub array_of_objects {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:array_of_objects' => '*',
    },
  }
}

########################################################################

=head2 Template::Static:array

Creates accessor methods, each of which shares a single array-ref value.

See the documentation on C<Generic:array> for interfaces and behaviors.

=cut

sub array {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:array' => '*', 
    },
  }
}

########################################################################

=head2 Template::Static:hash

Creates accessor methods, each of which shares a single hash-ref value.

See the documentation on C<Generic:hash> for interfaces and behaviors.

=cut

sub hash {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:hash' => '*',
    },
  } 
}

########################################################################

=head2 Template::Static:tiedhash

A variant of Template::Static:hash which initializes the hash by tieing it to a caller-specified package.

See the documentation on C<Generic:tiedhash> for interfaces and
behaviors, and for I<required> additional parameters.

=cut

sub tiedhash {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:tiedhash' => '*',
    },
  } 
}

########################################################################

=head2 Template::Static:hash_of_arrays

Creates accessor methods, each of which shares a reference to a single hash of array-refs.

See the documentation on C<Generic:hash_of_arrays> for interfaces and behaviors.

=cut

sub hash_of_arrays {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:hash_of_arrays' => '*',
    },
  }
}

########################################################################

=head2 Template::Static:code

Creates methods which contain an subroutine reference.

See the documentation on C<Generic:code> for interfaces, behaviors, and parameters.

=cut

sub code {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:code' => '*', 
    },
  }
}

########################################################################


=head2 Template::Static:instance

Creates methods to handle a single instance of the calling class.

See the documentation on C<Generic:instance> for interfaces and behaviors.

=cut

sub instance {
  {
    '-import' => { 
      'Template::Static:generic' => '*',
      'Template::Generic:instance' => '*',
    },
  } 
}

=head1  SEE ALSO

Class::MakeMethods

=cut

1;
