#!/usr/bin/perl

use JSON;
use Encode;

$file_log = $ARGV[0];
$file_conf = $ARGV[1];

$json = new JSON;

#$json = $json->allow_nonref([$enable]);
$json = $json->relaxed([$enable]);
$json = $json->max_depth([$maximum_nesting_depth]);

open (FILE, $file_log) or die("Unable to open file log!! " .$file_log . "\n");
#open (CONFIG, $file_conf) or die ("Unable to open file config!! ". $file_conf . "\n");

open (CSV, ">>text");

while (<FILE>)
{
    chomp;
    my $line = $_;
    print "Parsing line: $counter\n";
    $counter + 1;

    my ($url, $res_txt) = $line =~ /URL:(.*),RES_TXT:(.*),<EOH>/;
    my ($url, $res_txt) = ($1,$2); 

    my $obj = $json->utf8(1)->decode($res_txt); 
    
    # if (ref($obj) eq "HASH") {
    #     print "r is a reference to a hash.\n";
    # }

    if($url =~ /.*\/(.*)\.json/){
        my $event = $1;
    
        if(ref($obj) eq "ARRAY") {

            print CSV "$event,";

            foreach my $non_entity(@$obj){

                foreach my $entity (@{$non_entity->{entities}->{user_mentions}})
                {
                    print CSV 
                    $entity->{name} . " " . $entity->{id} . " " . $entity->{screen_name} . " ";                            
                }

                print CSV $non_entity->{coordinates} ." " .
                $non_entity->{created_at} . " " .
                $non_entity->{favorited} . " " . 
                $non_entity->{text} . " " .
                $non_entity->{id} . " " .
                $non_entity->{geo} . " " .
                $non_entity->{in_reply_to_user_id} . " " .
                $non_entity->{place} . " " .
                $non_entity->{in_reply_to_screen_name} . " " .
                $non_entity->{name} . " " .
                $non_entity->{screen_name} . " " .
                $non_entity->{statuses_count} . " " .
                $non_entity->{listed_count} . " " .

                $non_entity->{user}->{name} . " " .
                $non_entity->{user}->{created_at} . " " .
                $non_entity->{user}->{profile_image_url} . " " .
                $non_entity->{user}->{location} . " " .
                $non_entity->{user}->{url} . " " .
                $non_entity->{user}->{favourites_count} . " " .
                $non_entity->{user}->{protected} . " " .
                $non_entity->{user}->{id} . " " .
                $non_entity->{user}->{followers_count} . " " .
                $non_entity->{user}->{time_zone} . " " .
                $non_entity->{user}->{description} . " " .
                $non_entity->{user}->{statuses_count} . " " .
                $non_entity->{user}->{friends_count} . " " .
                $non_entity->{user}->{screen_name} . " " .

                $non_entity->{status}->{text} . " " .
                $non_entity->{status}->{place}->{name} . " " .
                $non_entity->{status}->{place}->{country_code} . " " .
                $non_entity->{status}->{place}->{country} . " " ;
            } 
        }
        else {
                print CSV $non_entity->{coordinates} ." " .
                $non_entity->{created_at} . " " .
                $non_entity->{favorited} . " " . 
                $non_entity->{text} . " " .
                $non_entity->{id} . " " .
                $non_entity->{geo} . " " .
                $non_entity->{in_reply_to_user_id} . " " .
                $non_entity->{place} . " " .
                $non_entity->{in_reply_to_screen_name} . " " .
                $non_entity->{name} . " " .
                $non_entity->{screen_name} . " " .
                $non_entity->{statuses_count} . " " .
                $non_entity->{listed_count} . " " .

                $non_entity->{user}->{name} . " " .
                $non_entity->{user}->{created_at} . " " .
                $non_entity->{user}->{profile_image_url} . " " .
                $non_entity->{user}->{location} . " " .
                $non_entity->{user}->{url} . " " .
                $non_entity->{user}->{favourites_count} . " " .
                $non_entity->{user}->{protected} . " " .
                $non_entity->{user}->{id} . " " .
                $non_entity->{user}->{followers_count} . " " .
                $non_entity->{user}->{time_zone} . " " .
                $non_entity->{user}->{description} . " " .
                $non_entity->{user}->{statuses_count} . " " .
                $non_entity->{user}->{friends_count} . " " .
                $non_entity->{user}->{screen_name} . " " .

                $non_entity->{status}->{text} . " " .
                $non_entity->{status}->{place}->{name} . " " .
                $non_entity->{status}->{place}->{country_code} . " " .
                $non_entity->{status}->{place}->{country} . " " ;            
        }
        print CSV "\n";
    }
}

close (CSV);
close (FILE);
exit;

