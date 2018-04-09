#!/usr/bin/env perl

use constant STREAM_SERVER_URL => "http://streaming.fueralle.org:8000" ;
use constant STREAM_TITLE => "Radio Corax MP3 Stream" ;
use constant RRD_FILE => "./stream.rrd" ;
use LWP::Simple ;
use HTML::Parser ;
use RRDTool::OO ;

$listener = "U" ;

$station_dataspace = 0 ;
$listener_dataspace = 0 ;

$counter = 0 ;

$icecast_xml = get(STREAM_SERVER_URL) ;
#die "Couldn't reach stream server" unless defined $icecast_xml ; # Unknown -> RRDTool ergaenzen

$parser = HTML::Parser->new(api_version => 3, text_h => [ 'text_trigger', "text"]) ;
$parser->parse($icecast_xml) ;

sub text_trigger {

  $counter++ ;

  return unless ( $_[0] =~ /\S+/ ) ;  # Don't check empty strings

  if ( $_[0]  eq STREAM_TITLE ) { # Icecast serves multiple streams. Is this our radio station?
    $station_dataspace = 1 ;
    return ;
  }

  if ( ($_[0] eq "Listeners (current):") &&  ($station_dataspace) ) { # Current listeners is what we are looking for
    $listener_dataspace = $counter ;
    return ;
  }

  if ( ($_[0] =~ /\d+/) && ($listener_dataspace) && ($counter-$listener_dataspace < 3)) { # The digits less then three text-events later represents listeners
    $listener = $_[0] ;

    $station_dataspace = 0 ;  # We have done, so we are out of scope
    $listener_dataspace = 0 ;
  }
}

$rrd = RRDTool::OO->new(file => RRD_FILE) ;
die "Couldn't open RR-Database\n" unless defined $rrd ;

$rrd->update($listener) ;

#print "$listener\n" ;

