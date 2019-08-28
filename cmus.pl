#!/usr/bin/perl -w
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#	simple cmus now playing script for irssi
#	
use strict;
use Irssi;
my %IRSSI = (
    authors     => 'Haui',
    contact     => 'haui45@web.de',
    name        => 'cmuscp',
    description => 'Irssi cmus now playing script',
    license     => 'GPL',
	version		=> 0.1
);

my @array;
my %info;
my $string;

#uncomment this, if you're sure of having cmus installed
which cmus or die "fatal...cmus executable not found!";
which cmus-remote or die "fatal...cmus-remote executable not found!";
which mp3info or die "mp3info is required in order to gather the bitrate for mp3-files";

sub irssi_stuff {
	# server - the active server in window
	# witem - the active window item (eg. channel, query)
	#         or undef if the window is empty
	my ($data, $server, $witem) = @_;
	if ($data) {
		help();
		return ;
	} 
	if ((my $ret = cmus()) != 0){
		return;
	}
	$string =~ s#`#'#g;
	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to server");
		return;
	}
	elsif ($witem && ($witem->{type} eq "CHANNEL" ||
			$witem->{type} eq "QUERY")) {
		# there's query/channel active in window
		$witem->command("ME $string");
	} else {
		#print songinfo even if you're viewing the server-window
		Irssi::print("No active channel/query in window");
		Irssi::print("cmus $string");
	}    
}
sub sectotime{
	my $secs = shift;
	my $time =sprintf("%02d:%02d", int ($secs / 60), int($secs % 60));
	return $time;
}
# retrieve infos about the currently played song by parsing `cmus-remote -Q` & write it to %info
sub cmus {
	#check if cmus is running
	if (checkplaying() == 1) {
		return 1;
	}

	@array = `cmus-remote -Q`;
	my %buzzwords = (
		'^status\s+'	=>	"state",
		'^file\s+'		=>	"file",
		'^tag title\s+'	=>	"title", 
		'^tag artist\s+'=>	"artist", 
		'^tag album\s+'	=>	"album", 
		'^duration\s+'	=>	"total",
		'^position\s+'	=>	"current",
		'^set repeat\s+'=>	"repeat",
		'^set shuffle\s+'=>	"shuffle"
	);
	foreach my $line(@array){
		foreach my $buzzword(keys %buzzwords){
			if($line =~ m/$buzzword/){
				$info{$buzzwords{$buzzword}} = $line;
				$info{$buzzwords{$buzzword}} =~ s/$buzzword//;
				chomp $info{$buzzwords{$buzzword}};
				last;
			}
		}
	}
	$info{'current'} = sectotime($info{'current'});
	# it's an internetstream
	if ($info{"file"} =~ m/^http:\/\//){
		stream();
		return;
	}else {
		$info{'bitrate'} = qx/ mp3info -p '%r' \Q$info{'file'}/;
		$info{'bitrate'} .= "Kbps";
		$info{'rate'} = qx/ mp3info -p '%Q' \Q$info{'file'}/;
		$info{'rate'} = sprintf("%.1f KHz", $info{'rate'}/1000);
		$info{'total'} = sectotime($info{'total'});
		$info{"type"} = qx/file \Q$info{'file'}/;  #filetype
		my $tmp = -s $info{'file'};
		$info{"size"} = sprintf("%.2f MB", ((($tmp) / 1024) / 1024)) ;

		if ($info{'type'} =~ /mp3/i){
			$info{'type'} = "mp3";
		}
		elsif ($info{'type'} =~ /ogg/i){
			$info{'type'} = "ogg";
		}
		elsif ($info{'type'} =~ /wav/i){
			$info{'type'} = "wav";
		}
		elsif ($info{'type'} =~ /wma/i){
			$info{'type'} = "wma";
		}
		else{ 
			$info{'type'} = "unknown";
		}
	}

	$string = "is currently playing: $info{'artist'} - $info{'title'} on \"$info{'album'}\" | [$info{'current'}/$info{'total'}] " . 
			"| [$info{'bitrate'}] | [$info{'rate'}] | [$info{'size'}] | [$info{'type'}]" ;
	
}
sub checkplaying{
	if (checkrunning() == 1){
		return 1;
	}
	if (system('cmus-remote -Q  | grep -q "^status playing"') != 0){
		Irssi::print "cmus isn't playing...try /cmusplay";
		return 1;
	}
	return 0;
}


sub checkrunning {
	if (system("cmus-remote -Q &> /dev/null") != 0){
		Irssi::print "cmus ist not running...";
		return 1;
	}
	return 0;
}

sub stream {
	$string = "is currently playing: $info{'artist'} - $info{'title'} | [$info{'current'}] " . 
			"| [$info{'file'}] | [Streaming...]" ;
}

sub next {
	if (checkrunning() == 1){
		return;
	}
	system("cmus-remote -n");
	return 0;
}

sub prev {
	if (checkrunning() == 1) {
		return;
	}
	system("cmus-remote -n");
	return 0;
}

sub shuffle {
	my ($data, $server, $witem) = @_;
	if (checkplaying() == 1){
		return;
	}
	system("cmus-remote -S");
	cmus();
	return unless (defined ($info{'shuffle'}));
	if (!$server || !$server->{connected}) {
		Irssi::print ("Shuffle: $info{'shuffle'}");
	}
	elsif ($witem && ($witem->{type} eq "CHANNEL" ||
			$witem->{type} eq "QUERY")) {
		# there's query/channel active in window
		$witem->command("echo Shuffle: $info{'shuffle'}");
	}
	else{
		Irssi::print ("Shuffle: $info{'shuffle'}");
	}

	return 0;
}

sub stop {
	if (checkplaying() == 1){
		return;
	}
	system("cmus-remote -s");
	return 0;
}

sub play {
	if (checkrunning() == 1) {
		return;
	}
	system("cmus-remote -p");
	return 0;
}

sub repeat {
	my ($data, $server, $witem) = @_;
	if (cmus() == 1){
		Irssi::print "cmus is not running";
		return;
	}
	system("cmus-remote -R");
	cmus();
	return unless (defined ($info{'repeat'}));
	if (!$server || !$server->{connected}) {
		Irssi::print ("Repeat: $info{'repeat'}");
	}
	elsif ($witem && ($witem->{type} eq "CHANNEL" ||
			$witem->{type} eq "QUERY")) {
		# there's query/channel active in window
		$witem->command("echo Repeat: $info{'repeat'}");
	}
	else{
		Irssi::print ("Repeat: $info{'repeat'}");
	}
	return 0;

}
sub help {
	Irssi::print(" cmus help: \n" . 
			" /cmusnp    -  prints the song currently played by cmus in the current channel/query\n" .
			" /cmusnext      -  next song\n" .
			" /cmusprev      -  previous song\n" .
			" /cmusshuffle   -  Turns shuffle on/off \n" .
			" /cmusrepeat    -  Turns repeat on/off \n" .
			" /cmusplay      -  Play... \n" .
			" /cmuspause     -  Pause the current song\n" .
			" /cmusstop      -  Stop cmus \n" .
			" /cmusnp help   -  Display this help \n" 
);
	return;
}
Irssi::command_bind('cmusnp', 'irssi_stuff');
Irssi::command_bind('cmus', 'irssi_stuff');
Irssi::command_bind('cmusnext', 'next');
Irssi::command_bind('cmusprev', 'prev');
Irssi::command_bind('cmusshuffle', 'shuffle');
Irssi::command_bind('cmusrepeat', 'repeat');
Irssi::command_bind('cmusplay', 'play');
Irssi::command_bind('cmusstart', 'start');
Irssi::command_bind('cmuspause', 'stop');
Irssi::command_bind('cmusstop', 'stop');
Irssi::command_bind('cmusnp help', 'help');
