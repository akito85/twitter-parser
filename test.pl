#!/usr/bin/perl

open (FILE, 'text');

while (<FILE>)
{
	my $line = $_;
	while ($line =~ /([a-z])x,/g)
	{
		print "bla $1", pos $1,"\n";
	}
}


 #   $x = "cat dog house"; # 3 words
 #   while ($x =~ /(\w+)/g) {
 #       print "Word is $1, ends at position ", pos $x, "\n";
 #   }