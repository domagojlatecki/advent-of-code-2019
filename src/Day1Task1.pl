use POSIX;

$sum = 0;

while (<>) {
    $sum += floor($_ / 3) - 2;
}

print $sum . "\n";
