use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'		=> 'Class::MakeMethods::Template',
    'VERSION_FROM'	=> 'Template.pm', 
    'PREREQ_PM'		=> {
      Class::MakeMethods => 1.003,
    }, 
    ($] >= 5.005 ? (
      ABSTRACT_FROM => 'Template.pm', 
      AUTHOR     => 'Matthew Simon Cavalletto <simonm@cavalletto.org>',
    ) : ()),
);
sub MY::postamble { q{

docs : README CHANGES TODO GUIDE

README: Template/ReadMe.pod
	pod2text Template/ReadMe.pod > README

CHANGES: Template/Changes.pod
	pod2text Template/Changes.pod > CHANGES

TODO: Template/ToDo.pod
	pod2text Template/ToDo.pod > TODO

GUIDE: Template.pm
	pod2text Template.pm > GUIDE

cleanmanifest:
	make realclean; rm MANIFEST ; perl Makefile.PL; touch MANIFEST; make manifest

}; }
