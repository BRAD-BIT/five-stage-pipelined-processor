<?php
function extending($num,$len)
{
	while(strlen($num)!=$len)$num="0{$num}";
	return $num;
}
$row = 1;
if (($handle = fopen("F:\www\Pro\Project\Design\ControlUnitSignalsDesign.csv", "r")) !== FALSE) {
    while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
		if($row<=2){$row++;continue;}
        $num = count($data);
        //echo "$num fields in line $row: <br/>";
        $row++;
		$data[06]=extending($data[06],4);
		$data[11]=extending($data[11],2);
		$line="";
        for ($c=0; $c < $num; $c++) 
		{
			if($c==0){//echo $data[$c]."<br>";
			continue;}
			if(strlen(trim($data[$c]))==0){ $line.="0";continue;}
            $line.=$data[$c];
        }
		while(strlen($line)!=24)$line.="0";
		echo "{$line}<br>";
    }
    fclose($handle);
}
?>