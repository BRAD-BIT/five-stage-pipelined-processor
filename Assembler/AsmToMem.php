<?php

	function binary($num,$len)
	{
		$num=decbin($num);
		while(strlen($num)!=$len)$num="0{$num}";
		return $num;
	}
	function extending($num,$len)
	{
		while(strlen($num)!=$len)$num="{$num}0";
		return $num;
	}
	function inst_parameters($line)
	{
		$line=str_replace("R","",$line);
		$parameters=explode(',',explode('#',substr($line,strpos($line," "),1000))[0]);
		return $parameters;
	}
	function convert($line)
	{
		$line=strtoupper($line);
		$parameters=inst_parameters($line);
		$inst=trim(explode(' ',$line)[0]);
		$encoded_line=array();
		$line=explode('#',$line)[0];
		if(strlen(trim($line))==0)return $encoded_line;
		switch ($inst) {
			case 'NOP':
				array_push($encoded_line,extending('00000',16));
				break;
			case 'MOV':
				array_push($encoded_line,extending('00001'.binary($parameters[1],3).binary($parameters[0],3),16));
				break;
			case 'ADD':
				array_push($encoded_line,extending('00010'.binary($parameters[2],3).binary($parameters[0],3).binary($parameters[1],3),16));
				break;
			case 'SUB':
				array_push($encoded_line,extending('00011'.binary($parameters[2],3).binary($parameters[0],3).binary($parameters[1],3),16));
				break;
			case 'AND':
				array_push($encoded_line,extending('00100'.binary($parameters[2],3).binary($parameters[0],3).binary($parameters[1],3),16));
				break;
			case 'OR':
				array_push($encoded_line,extending('00101'.binary($parameters[2],3).binary($parameters[0],3).binary($parameters[1],3),16));
				break;
			case 'RLC':
				array_push($encoded_line,extending('00110'.binary($parameters[0],3),16));
				break;
			case 'RRC':
				array_push($encoded_line,extending('00111'.binary($parameters[0],3),16));
				break;
			case 'SHL':
				array_push($encoded_line,extending('01000'.binary($parameters[0],3).binary($parameters[1],4),16));
				break;
			case 'SHR':
				array_push($encoded_line,extending('01001'.binary($parameters[0],3).binary($parameters[1],4),16));
				break;
			case 'SETC':
				array_push($encoded_line,extending('01010',16));
				break;
			case 'CLRC':
				array_push($encoded_line,extending('01011',16));
				break;
			case 'PUSH':
				array_push($encoded_line,extending('01100'.binary($parameters[0],3),16));
				break;
			case 'POP':
				array_push($encoded_line,extending('01101'.binary($parameters[0],3),16));
				break;
			case 'OUT':
				array_push($encoded_line,extending('01110'.binary($parameters[0],3),16));
				break;
			case 'IN':
				array_push($encoded_line,extending('01111'.binary($parameters[0],3),16));
				break;
			case 'NOT':
				array_push($encoded_line,extending('10000'.binary($parameters[0],3),16));
				break;
			case 'NEG':
				array_push($encoded_line,extending('10001'.binary($parameters[0],3),16));
				break;
			case 'INC':
				array_push($encoded_line,extending('10010'.binary($parameters[0],3),16));
				break;
			case 'DEC':
				array_push($encoded_line,extending('10011'.binary($parameters[0],3),16));
				break;
			case 'JZ':
				array_push($encoded_line,extending('10100'.binary($parameters[0],3),16));
				break;
			case 'JN':
				array_push($encoded_line,extending('10101'.binary($parameters[0],3),16));
				break;
			case 'JC':
				array_push($encoded_line,extending('10110'.binary($parameters[0],3),16));
				break;
			case 'JMP':
				array_push($encoded_line,extending('10111'.binary($parameters[0],3),16));
				break;
			case 'CALL':
				array_push($encoded_line,extending('11000'.binary($parameters[0],3),16));
				break;
			case 'RET':
				array_push($encoded_line,extending('11001',16));
				break;
			case 'RTI':
				array_push($encoded_line,extending('11010',16));
				break;
			case 'LDM':
				array_push($encoded_line,extending('11011'.binary($parameters[0],3),16));				
				array_push($encoded_line,binary($parameters[1],16));
				break;
			case 'LDD':
				array_push($encoded_line,extending('11100'.binary($parameters[0],3),16));		
				array_push($encoded_line,binary($parameters[1],16));
				break;
			case 'STD':
				array_push($encoded_line,extending('11101'.binary($parameters[0],3),16));
				array_push($encoded_line,binary($parameters[1],16));
				break;
		}
		return $encoded_line;
	}
	$codes=scandir("F:\www\Pro\Project\Assembler\codes");
	for($fc=2;$fc<count($codes);$fc++)
	{
		$name=explode('.',$codes[$fc])[0];
		$fe=fopen("F:\\www\\Pro\\Project\\Vhdl\\EncodedCodes\\{$name}.mem",'w+');
		$f=fopen("F:\\www\\Pro\\Project\\Assembler\codes\\{$codes[$fc]}",'r');
		$code_lines=0;
		$SkipNext=0;
		while(!feof($f)) 
		{
			$line=fgets($f);
			$line = preg_replace('!\s+!', ' ', $line);
			if($SkipNext==1){$SkipNext=0;continue;}
			$encoded_line=convert($line);
			$code_lines+=count($encoded_line);
			if(count($encoded_line)==0)continue;
			fwrite($fe,$encoded_line[0].PHP_EOL);
			if(count($encoded_line)==2){fwrite($fe,$encoded_line[1].PHP_EOL);$SkipNext=1;}
			
		}
		for($i=$code_lines;$i<1024;$i++)
			fwrite($fe,"0000000000000000".PHP_EOL);
		file_put_contents("F:\\www\\Pro\\Project\\Vhdl\\{$name}.do",str_replace("#.mem","{$name}.mem",file_get_contents("F:\www\Pro\Project\Vhdl\Initialize\TempleteDo.do")));
	}
	
?>