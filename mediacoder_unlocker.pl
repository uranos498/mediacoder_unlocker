#!perl -w
# Updated by Uranos498 to comply with new question in Donation Box
#my $var = "Hello World";
#for(my $i=0; $i<length($var); $i++){
#        print "".substr($var, $i, 1)."\n";
#}
#http://olivier.kraif.u-grenoble3.fr/files/Tutoriel.Regex.html
#What is the 4st letter of the word "transcoding"? 
use strict;

use Win32::GuiTest qw(:ALL);
#use Win32::GuiTest qw(GetCursorPos);
# my @coordo = GetCursorPos();

my $mediacoderWindowsDonationId;

# wait for donation box
START:

print "Wait for donation box...\n";
do {
  $mediacoderWindowsDonationId = 0;
  $mediacoderWindowsDonationId = detectDonationWindow();
  sleep(2);
} while (not $mediacoderWindowsDonationId) ;

# donation box found
print "Find donation window (id : $mediacoderWindowsDonationId)\n";

# try to answer question
my $char_result = computeCharElement($mediacoderWindowsDonationId);
if ($char_result eq '') {
  die "Could not find question\n";
} else {
  print "Result is $char_result\n";
}

#cursor position
my @coordo = GetCursorPos();
my @coords = GetWindowRect($mediacoderWindowsDonationId);

# set focus on window
SetFocus($mediacoderWindowsDonationId);
# send mouse to result box
MouseMoveAbsPix($coords[0] + 375, $coords[1] + 252);
# click
SendLButtonDown(); SendLButtonUp();
# send result
SendKeys($char_result);
# send mouse to continue button
MouseMoveAbsPix($coords[0] + 353, $coords[1] + 283);
# click
SendLButtonDown(); SendLButtonUp();

#return cursor to initial position
MouseMoveAbsPix(@coordo);
# loop
sleep(10);
goto START;

################################################################################################################
sub detectDonationWindow {
  foreach (FindWindowLike(undef, "Continue in ")) {
   my $text = GetWindowText($_);  #___
   printf "GetWindowText($_) : $text\n"; #___
    return $_;
  }
  return;
}


sub computeCharElement {
  my $windowId = shift;
  print "WindowId is  : '$windowId'\n";
  my @children = GetChildWindows($windowId);

  foreach (@children) {
    print "Chilren is  : '$_'\n";
    my $text = WMGetText($_);
    print "Result for '$_' : '$text'\n" ;   #___
	#What is the 4st letter of the word "transcoding"?
	#if ($text =~ /Let's do a simple math: ([^=]+)=/i) {
    if ($text =~ /What is the (\d\d?)st letter of the word "([A-Za-z]+)"?/i) {
	 print "question is : '$text'\n";
     print "Position is : '$1'\n";
	 print "Word is : '$2'\n";
      #my $n = eval($1);
	  print "Position2 is : '$1'\n";
	  my $char = substr($2,$1-1,1);
	  print "Char is : '$char'\n";
      return $char;
    }
  }
  return '';
}
