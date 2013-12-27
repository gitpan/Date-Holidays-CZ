package Date::Holidays::CZ;

use 5.010;
use strict;
use warnings FATAL => 'all';

=encoding utf8

=head1 NAME

Date::Holidays::CZ - determine Czech Republic bank holidays

=head1 VERSION

Version 0.02

=cut

our $VERSION = '0.02';

=head1 SYNOPSIS

   use Date::Holidays::CZ;
   my ($year, $month, $day) = (localtime)[ 5, 4, 3 ];
       
   $year  += 1900;
   $month += 1;
   print "Woohoo" if is_holiday( $year, $month, $day );

   my $hashref;
   $hashref = cz_holidays(2014);        # full listing for 2014
   $hashref = cz_holidays(2014, 4);     # just for April, 2014
   $hashref = cz_holidays(2014, 4, 8);  # just for April 8, 2014

=head1 DESCRIPTION

In its current, primitive form, this module provides a simple way to
get information on Czech Republic bank holidays. The information it
provides was current at the time the module was written (c. 2013).

Someday, it would nice to develop the module into conformity with the
C<Date::Holidays> paradigm -- i.e. into an "OOP Adapter". First, though,
I will have to figure out what an "OOP Adapter" is!

=head1 DEPENDENCIES

Date::Holidays::CZ depends on the following two modules:

=over 8

=item * C<Date::Simple>

=item * C<Date::Easter>

=back

=cut


use Date::Simple;
use Date::Easter;


=head1 CZECH REPUBLIC BANK HOLIDAYS

=head2 Fixed and variable

With one exception, the dates of all Czech Republic bank holidays are fixed. The exception is Easter
Monday. 

=head2 Listings 

=head3 English translation

The dates and names (in English translation) of all Czech Republic
bank holidays as of the time of this writing are as follows:

=over 8

=item B<Jan 01> -- Restoration Day of the Independent Czech State

=item B<Apr XY> -- Easter Monday

=item B<May 01> -- Labor Day

=item B<May 08> -- Liberation Day

=item B<Jul 05> -- Saints Cyril and Methodius Day

=item B<Jul 06> -- Jan Hus Day

=item B<Sep 28> -- Feast of St. Wenceslas (Czech Statehood Day)

=item B<Oct 28> -- Independent Czechoslovak State Day

=item B<Nov 17> -- Struggle for Freedom and Democracy Day

=item B<Dec 24> -- Christmas Eve

=item B<Dec 25> -- Christmas Day

=item B<Dec 26> -- Feast of St. Stephen

=back

=head3 Czech original

The dates and names (in the original Czech) of all Czech Republic
bank holidays as of the time of this writing are as follows:

=over 8

=item B<Jan 01> -- Den obnovy samostatného českého státu

=item B<Apr XY> -- Velikonoční pondělí

=item B<May 01> -- Svátek práce

=item B<May 08> -- Den vítězství

=item B<Jul 05> -- Den slovanských věrozvěstů Cyrila a Metoděje

=item B<Jul 06> -- Den upálení mistra Jana Husa

=item B<Sep 28> -- Den české státnosti

=item B<Oct 28> -- Den vzniku samostatného československého státu

=item B<Nov 17> -- Den boje za svobodu a demokracii

=item B<Dec 24> -- Štědrý den

=item B<Dec 25> -- 1. svátek vánoční

=item B<Dec 26> -- 2. svátek vánoční

=back

=head1 EXPORT

This module contains two functions that can be exported:

=over 8

=item * is_cz_holiday

=item * cz_holidays

=back

=cut


use parent qw(Exporter);
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(is_cz_holiday cz_holidays);


=pod 

=head1 CONSTANTS

The Czech holiday names are stored within the Date::Holidays::CZ module source code in private
variables. Since these variables are never changed, they can be thought of as constants.

=cut

# Fixed-date holidays {'MMDD' => 'NAME'}
my $FIX = {'0101' => 'Den obnovy samostatného českého státu',
           '0501' => 'Svátek práce',
	   '0508' => 'Den vítězství',
           '0705' => 'Den slovanských věrozvěstů Cyrila a Metoděje',
           '0706' => 'Den upálení mistra Jana Husa',
           '0928' => 'Den české státnosti',
           '1028' => 'Den vzniku samostatného československého státu',
           '1117' => 'Den boje za svobodu a demokracii',
           '1224' => 'Štědrý den',
           '1225' => '1. svátek vánoční',
           '1226' => '2. svátek vánoční'
	  };

# The only variable-date holiday is Easter Monday -- we deal with that separately
my $EM = 'Velikonoční pondělí';

=head1 SUBROUTINES/METHODS

=head2 C<is_cz_holiday>

Takes three named arguments:

=over 8

=item * C<year>, four-digit number

=item * C<month>, 1-12, two-digit number

=item * C<day>, 1-31, two-digit number

=back

=cut

sub is_cz_holiday {
   # returns: name of holiday (true) or 0 (false)

   my ($year, $month, $day) = @_;

   my $k = sprintf "%02d%02d", $month, $day;
   if (exists $FIX->{$k}) {
      # this is a fixed-date holiday
      return $FIX->{$k};
   }

   # Date::Simple overloads the '-' (subtraction) operation for
   # Date::Simple objects. If the difference between the given date
   # and Easter Sunday is +1, then the given date is Easter Monday.
   my $diff = Date::Simple->new($year, $month, $day) - Date::Simple->new($year, easter($year));
   if ( $diff == 1 ) {
      return $EM;
   }

   # In all other cases
   return 0;
}


=head2 C<cz_holidays>

Takes one to three arguments: C<year> (four-digit number), C<month> (1-12, two-digit number),
and C<day> (1-31, two-digit number).  Returns a reference to a hash in which
the keys are 'MMDD' (month and day, concatenated) and the values are
the names of all the various bank holidays that fall within the year, month, or day 
indicated by the arguments.

=cut

sub cz_holidays {

   my ($year, $month, $day) = @_;

   # Easter Monday is the day after Easter
   my $easter = Date::Simple->new($year, easter($year));
   my $em = $easter + 1;

   # Easter Key ($ek) is a string in the form 'MMDD'
   my $ek = sprintf "%02d%02d", $em->month, $em->day;

   # $h is a reference to a hash containing the results
   my $h;

   if ( ! $month ) { 

      #print "DEBUG: only year given\n";
      $h = {%$FIX};
      $h->{$ek} = $EM;

   } elsif ( ! $day ) { 

      #print "DEBUG: only year and month given\n";
      my $m = sprintf "%02d", $month;
      foreach my $k (keys %$FIX) {
         $h->{$k} = $FIX->{$k} if $k =~ m/\A$m/;
      }
      $h->{$ek} = $EM if $ek =~ m/\A$m/;

   } else { 

      #print "DEBUG: year, month, and day given\n";
      my $k = sprintf "%02d%02d", $month, $day;
      $h->{$k} = $FIX->{$k} if exists $FIX->{$k};
      $h->{$ek} = $EM if $ek == $k;

   }

   return $h;
}

=head1 AUTHOR

Nathan Cutler, C<< <presnypreklad at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-date-holidays-cz at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Date-Holidays-CZ>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Date::Holidays::CZ


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Date-Holidays-CZ>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Date-Holidays-CZ>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Date-Holidays-CZ>

=item * Search CPAN

L<http://search.cpan.org/dist/Date-Holidays-CZ/>

=back


=head1 ACKNOWLEDGEMENTS

Inspired by Date::Holidays::DK


=head1 LICENSE AND COPYRIGHT

Copyright 2013-2014 SUSE LLC
Author: Nathan Cutler

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Date::Holidays::CZ


=head1 AUTHOR

C<< Nathan Cutler <presnypreklad@gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2013-2014 SUSE LLC

C<Date::Holidays::CZ> is released under the Artistic License, as
specified by the Artistic file in the standard Perl distribution
(L<http://dev.perl.org/licenses/artistic.html>)

=cut
