#!/usr/bin/perl

use JSON;
use Encode;

$file_log = $ARGV[0];
$file_conf = $ARGV[1];

$json = new JSON;

$json = $json->allow_nonref([$enable]);
$json = $json->relaxed([$enable]);
$json = $json->max_depth([$maximum_nesting_depth]);

open (FILE, $file_log) or die("Unable to open file log!! " .$file_log . "\n");
#open (CONFIG, $file_conf) or die ("Unable to open file config!! ". $file_conf . "\n");

while (<FILE>)
{
    chomp;
    my $line = $_;
    print "Parsing line: $counter\n";
    $counter + 1;

    my ($url, $res_txt) = $line =~ /URL:(.*),RES_TXT:(.*),<EOH>/;
    my ($url, $res_txt) = ($1,$2);   

    my $obj = $json->utf8(1)->decode($res_txt); 

    if($url = ~/.*\/(.*)\.json/){
        my $event = $1;

        if ($event eq 'user_timeline'){ 

            for my $user_timeline (@$obj)
            {   
                print $user_timeline->{id} . "\n";
                print $user_timeline->{user}{name} . "\n";
                print $user_timeline->{screen_name} . "\n"; 
                print $user_timeline->{text} . "\n";
            }   

            # uncomment this if you want to hardcorely regex

            # my $created_at = $res_txt =~ /.*created_at":.{2}(.*?)",/;
            # my $created_at = $1;
            # print "created_at: " . $created_at . "\n";

            # my $id = $res_txt = ~/"id":.?([\d]+),/;
            # my $id = $1;
            # print "id: " . $id . "\n";

            # my $name = $res_txt = ~/"name":.{2}(.*?)",/;
            # my $name = $1;
            # print "name: " . $name . "\n";

            # while ($res_txt =~ /"name":[\s]"(.*?)",/g)
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

            print "====================================================\n";
        }
        elsif ($event eq 'update')
        {
            my $update = $obj;
                print $update->{coordinates} . " ";
                print $update->{created_at} . " ";
                print $update->{favorited} . " ";
                print $update->{id} . " ";

                        # here go the entities
                        # hash tags e.g. #dafuq! #ohgodwhy #bitchplease #notbad
                        foreach my $entity (@{$update->{entities}->{hashtags}})
                            {
                                print $entity->{text} . "\n";
                            }

                        foreach my $entity (@{$update->{entities}->{user_mentions}})
                        {
                            print $entity->{name} . "\n";
                            print $entity->{id} . "\n";
                            print $entity->{screen_name} . "\n";
                        }

                print $update->{text} . " ";
                print $update->{in_reply_to_user_id_str} . " ";
                print $update->{retweet_count} . " ";
                print $update->{retweeted} . " ";
                print $update->{source} . " ";
                print $update->{in_reply_to_screen_name} . " ";

                    print $update->{user}->{id} . " ";
                    print $update->{user}->{name} . " ";
                    print $update->{user}->{screen_name} . " ";
                    print $update->{user}->{time_zone} . "\n";

                print $update->{place} . " ";
                print $update->{in_reply_to_status_id} . " \n";

            print "====================================================\n";
        }
        elsif ($event eq 'mentions')
        {
            # null value wont be printed
            # one mention loop
            foreach my $mention(@$obj){
                print $mention->{coordinates} . "\n";
                print $mention->{favorited} . "\n";
                print $mention->{created_at} . "\n";

                        foreach my $entity (@{$mention->{entities}->{user_mentions}})
                        {
                            print $entity->{name} . "\n";
                            print $entity->{id} . "\n";
                            print $entity->{screen_name} . "\n";
                        }
                
                print $mention->{text} . "\n";
                print $mention->{id} . "\n";
                print $mention->{geo} . "\n";
                print $mention->{in_reply_to_user_id} . "\n";
                print $mention->{place} . "\n";
                print $mention->{in_reply_to_screen_name} . "\n";

                    print $mention->{user}->{name} . "\n";
                    print $mention->{user}->{created_at} . "\n";
                    print $mention->{user}->{profile_image_url} . "\n";
                    print $mention->{user}->{location} . "\n";
                    print $mention->{user}->{url} . "\n";
                    print $mention->{user}->{favourites_count} . "\n";
                    print $mention->{user}->{protected} . "\n";
                    print $mention->{user}->{id} . "\n";
                    print $mention->{user}->{followers_count} . "\n";
                    print $mention->{user}->{time_zone} . "\n";
                    print $mention->{user}->{description} . "\n";
                    print $mention->{user}->{statuses_count} . "\n";
                    print $mention->{user}->{friends_count} . "\n";
                    print $mention->{user}->{screen_name} . "\n";

                print $mention->{source} . "\n";
                print $mention->{in_reply_to_status_id} . "\n";

                print "+-+-+-+-+-+-+-+-+-+END OF MENTION+-+-+-+-+-+-+-+-+-+\n"
            }

            # while ($res_txt =~ /"coordinates":\s(.*),/g)
            # {
            #       print $1 . "\n";
            # }

            # while ($res_txt =~ /"created_at":\s(.*?),/g)
            # {
            #     print $1 . "\n";
            # }

            # while ($res_txt =~ /"name":\s"(.*?)",/g)
            # {
            #     print $1 . "\n";
            # }

            # while ($res_txt =~ /"screen_name":\s"(.*?)",/g)

            print "====================================================\n";

        }
    }
}

close (FILE);
exit;

