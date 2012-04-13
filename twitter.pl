#!/usr/bin/perl

use JSON;
use Encode;

$json = new JSON;
$json = $json->allow_nonref([$enable]);
$json = $json->relaxed([$enable]);
$json = $json->max_depth([$maximum_nesting_depth]);

$file_log = $ARGV[0];
$file_conf = $ARGV[1];


open (FILE, $file_log) or die("Unable to open file log!! " .$file_log . "\n");
#open (CONFIG, $file_conf) or die ("Unable to open file config!! ". $file_conf . "\n");

while (<FILE>)
{
    chomp;
    my $line = $_;
    print "Parsing line: $counter\n";
    $counter + 1;

    my ($url, $res_txt) = $line =~/URL:(.*),RES_TXT:(.*)/;
    my ($url, $res_txt) = ($1,$2);
    
    #print $res_txt;

    my $obj = $json->utf8(1)->decode($res_txt);    

    if($url = ~/.*\/(.*)\.json/){
        my $event = $1;

        if ($event eq 'user_timeline'){
            print $event . "\n";

            for my $user_timeline (@$obj)
            {   
                print $user_timeline->{id} . "\n";
                print $user_timeline->{user}{name} . "\n";
                print $user_timeline->{screen_name} . "\n"; 
                print $user_timeline->{text} . "\n";
            }    

            # my $created_at = $res_txt = ~/.*created_at":.{2}(.*?)",/;
            # my $created_at = $1;
            # print "created_at: " . $created_at . "\n";

            # my $id = $res_txt = ~/"id":.?([\d]+),/;
            # my $id = $1;
            # print "id: " . $id . "\n";

            # my $name = $res_txt = ~/"name":.{2}(.*?)",/;
            # my $name = $1;
            # print "name: " . $name . "\n";

            # while ($res_txt = ~/"name":[\s]"(.*?)",/)
            # {
            #     print $1 . "\n";
            # }

            # my $screen_name = $res_txt = ~/.*screen_name":.{2}(.*)",/;
            # my $screen_name = $1;
            # print "screen_name: " . $screen_name . "\n";

            # my $time_zone = $res_txt = ~/.*time_zone":.{2}(.*?)",/;
            # my $time_zone = $1;
            # print "time_zone: " . $time_zone . "\n";

            # my $friends_count = $res_txt = ~/.*friends_count":[\s|\S]([\d]+),/;
            # my $friends_count = $1;
            # print "friends_count: " . $friends_count . "\n";

            # my $followers_count = $res_txt = ~/.*followers_count":[\s|\S]([\d]+),/;
            # my $followers_count = $1;
            # print "followers_count: " . $followers_count . "\n";

            # my $place = $res_txt = ~/.*place":.?(.*),/;
            # my $place = $1;
            # print "place: " . $place . "\n";

            # my $location = $res_txt = ~/.*location":.{2}(.*,[\s|\S][\w]*)",/;
            # my $location = $1;
            # print "location: " . $location . "\n";

            # my $text = $res_txt = ~/.*text":.{2}(.*?)",/;
            # my $text = $1;
            # print "text: " . $text ."\n";

            # my $expanded_url = $res_txt = ~/.*expanded_url":[\s|\S]"(.*?)",/;
            # my $expanded_url = $1;
            # print "expanded_url: " . $expanded_url . "\n";

            # my $url = $res_txt = ~/.*"url":[\s|\S]"(.*?)",/;
            # my $url = $1;
            # print "url: " . $url . "\n";

            # my $retweet_count = $res_txt = ~/.*retweet_count":[\s|\S]([\d|\w]*),/;
            # my $retweet_count = $1;
            # print "retweet_count: " . $retweet_count . "\n";

            # my $retweeted = $res_txt = ~/.*retweeted":[\s|\S]([\d|\w]*),/;
            # my $retweeted = $1;      
            # print "retweeted: " . $retweeted . "\n";
            
        }
        elsif ($event eq 'update')
        {
            print $event . "\n\n\n";
            print $obj->{text} . "\n";
            print $obj->{id} . "\n";
            print $obj->{source} . "\n";

        }
        elsif ($event eq 'mentions')
        {
            print $event . "\n\n\n";

            for my $mentions (@$obj)
            {   
                print $mentions->{id} . "\n";
                print $mentions->{user}{name} . "\n";
                print $mentions->{text} . "\n";
                print $mentions->{entities}{user_mentions} . "\n";
            } 

            print "\n\n\n\n";

        }
    }
}

close (FILE);
exit;

