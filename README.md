RRDTool_Icecast_Stats
=====================

Icecast current listener stats using RRDTool

Perl CPAN-Modules
-----------------

You have to install the following Perl modules using your package manager or cpan

- LWP::Simple
- HTML::Parser
- RRDTool::OO ;

Creating the RR-Database
------------------------

    rrdtool create rrdtool/stream.rrd --step=60 \
      DS:listener:GAUGE:100:0:999       \
      RRA:LAST:0.5:1:20160              \
      RRA:AVERAGE:0.9:60:1488           \
      RRA:AVERAGE:0.99:1440:775         \
      RRA:MAX:0.9:60:1488               \
      RRA:MAX:0.99:1440:775

Configuring the parser script
----------------------

In read_streamdata.pl customize the settings for

- STREAM_SERVER_URL
- STREAM_TITLE
- RRD_FILE

Plotting an image
-----------------

    mkdir htdocs/stats

    rrdtool graph htdocs/stats/stream_12h.png --disable-rrdtool-tag -w 800 -h 250 --end now --start end-12h \
      DEF:last_listener=rrdtool/stream.rrd:listener:LAST       \
      DEF:average_listener=rrdtool/stream.rrd:listener:AVERAGE \
      CDEF:trend=last_listener,1800,TRENDNAN           \
      SHIFT:trend:-900                                 \
      AREA:trend#acacff:"Current listener - Trend"     \
      AREA:last_listener#999999cc:"Current listener"   \
      LINE1:average_listener#000000cc:"Average listener / hour"

You can put this in a shell script or a cron job
