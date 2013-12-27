use 5.010;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Date::Holidays::CZ',
    AUTHOR           => q{Nathan Cutler <presnypreklad@gmail.com>},
    VERSION_FROM     => 'CZ.pm',
    ABSTRACT_FROM    => 'CZ.pm',
    LICENSE          => 'Artistic_2_0',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.010,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Exporter'   => 0,
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Exporter'         => 0,
        'Date::Simple'     => 0,
        'Date::Easter'     => 0,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Date-Holidays-CZ-*' },
);
