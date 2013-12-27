#!perl -T
use 5.010;
use strict;
use warnings FATAL => 'all';
use Test::More;
use Date::Holidays::CZ qw(is_cz_holiday cz_holidays);

plan tests => 7;

ok(is_cz_holiday(2013, 12, 24), "Christmas Eve 2013");

ok(is_cz_holiday(2013, 4, 1), "Easter Monday 2013");

ok( ! is_cz_holiday(2013, 5, 3), "May 3, 2013");

my ($h, $q);

$h = cz_holidays(2013);
$q = scalar keys %$h;
ok($q == 12, "Right number of elements in 2013 holidays hash");

$h = cz_holidays(2013, 4);
$q = scalar keys %$h;
ok($q == 1, "Right number of elements in 2013-APR holidays hash");

$h = cz_holidays(2013, 4, 1);
$q = scalar keys %$h;
ok($q == 1, "Right number of elements in 2013-APR-1 holidays hash");

$h = cz_holidays(2013, 4, 2);
$q = scalar keys %$h;
ok($q == 0, "Right number of elements in 2013-APR-2 holidays hash");

