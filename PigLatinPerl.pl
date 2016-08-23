my $f;
my $filename = $ARGV[0];
unless ($filename) {
    print "Enter filename:\n";
    $filename = <STDIN>;
    chomp $filename;
}
open($f, $filename) or die $!;
while ( my $line = <$f> ) {
	my @strings = split(/[\s\n\t\r]+/,$line);
	foreach $string (@strings){
		my $y = "";
		if($string =~ /^[aeiou]/){
			$y = "yay";
		}else{
			$y = "ay";
		}
		$string =~ s/(\w*?(?=[aeiou]))([aeiou]\w*)/\2\1$y\n/;
		$string =~ s/0//;
		$string =~ s/[\t\n\r]+/ /;
		print ($string)," ";
		
	}
}
close $fh;
print "\ndone\n";