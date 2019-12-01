use POSIX;

$sum = 0;

while (<>) {
    $fuelReq = (floor($_ / 3) - 2);
    $fuelSum = $fuelReq;


    while ($fuelReq > 0) {
        $fuelReq = (floor($fuelReq / 3) - 2);

        if ($fuelReq > 0) {
            $fuelSum += $fuelReq;
        }
    }

    $sum += floor($fuelSum);
}

print $sum . "\n";
