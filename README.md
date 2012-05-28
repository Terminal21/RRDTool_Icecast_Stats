RRDTool_Icecast_Stats
=====================

Icecast current listener stats using RRDTool

Perl CPAN-Modules
-----------------

You have to install the following Perl modules using our package manager or cpan

- LWP::Simple
- HTML::Parser
- RRDTool::OO ;

Creating the RR-Database
------------------------

> rrdtool create stream.rrd --step=60 \
>   DS:listener:GAUGE:100:0:999       \
>   RRA:LAST:0.5:1:20160              \
>   RRA:AVERAGE:0.9:60:1488           \
>   RRA:AVERAGE:0.99:1440:775         \
>   RRA:MAX:0.9:60:1488               \
>   RRA:MAX:0.99:1440:775

Configuring the script
----------------------

In read_streamdata.pl customize the settings for

- STREAM_SERVER_URL
- STREAM_TITLE
- RRD_FILE
