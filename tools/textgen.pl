
my $password = randomPassword(8);
open(BOOTROM, $ARGV[0]); # open for input
binmode(BOOTROM);
my $counter=1,$duh=1;
my (@ROM, $data);
while ((read BOOTROM, $data, 1) != 0) {if($counter>=19){print "\njmp 4\n$password".$duh.":\njmp $password".($duh+1);$duh++;$counter=0; }
	if($data eq '~~'){print "\nsleep 1";}else{print "\nmov a,".(ord($data)-1)."\ninc a\nmov [sp],a\noutput\n";}
  $counter++;
}

print "\n$password".$duh.":";



sub randomPassword {
my $password;
my $_rand;

my $password_length = $_[0];
    if (!$password_length) {
        $password_length = 10;
    }

my @chars = split(" ",
    "a b c d e f g h i j k l m n o
    p q r s t u v w x y z");

srand;

for (my $i=0; $i <= $password_length ;$i++) {
    $_rand = int(rand 41);
    $password .= $chars[$_rand];
}
return $password;}

