package Class::MakeMethods::Template::Scalar;

use Class::MakeMethods::Template::Generic;
@ISA = qw( Class::MakeMethods::Template::Generic );

use strict;
require 5.00;
use Carp;

sub generic {
  {
    '-import' => { 
      'Template::Generic:generic' => '*' 
    },
    'code_expr' => { 
      _VALUE_ => '(${_SELF_})',
    },
    'params' => {
    }
  }
}

sub new {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
    },
    'interface' => {
      default		=> 'with_methods',
      with_values	=> 'with_values',
      with_methods	=> 'with_methods', 	
      with_init		=> 'with_init',
      instance_with_methods => 'instance_with_methods', 	
      new_and_method_init   => { '*'=>'new_with_init', 'init'=>'method_init'},
      copy	    	=> 'shallow_copy',
    },
    'behavior' => {
      'with_methods' => q{
	  my $scalar = undef;
	  $self = bless \$scalar, _SELF_CLASS_;
          
	  _CALL_METHODS_FROM_HASH_
	  
	  return $self;
	},
      'with_init' => q{
	  my $scalar = undef;
	  $self = bless \$scalar, _SELF_CLASS_;
          
	  my $init_method = $m_info->{'init_method'} || 'init';
	  $self->$init_method( @_ );
          
	  return $self;
	},
    }
  }
}

sub scalar {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
      'Template::Generic:scalar' => '*', 
    },
  }
}

sub string {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
      'Template::Generic:string' => '*',
    },
  }
}

sub number {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
      'Template::Generic:number' => '*',
    },
  }
}

sub boolean {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
      'Template::Generic:boolean' => '*',
    },
  }
}


sub code {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
      'Template::Generic:code' => '*', 
    },
  }
}

sub bits {
  {
    '-import' => { 
      'Template::Scalar:generic' => '*',
      'Template::Generic:bits' => '*', 
    },
  }
}

1;
