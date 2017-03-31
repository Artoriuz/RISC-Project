//This doesn't even compile, it's not meant to be used as code, it's just here to exemplify what happens in the datapath logic. 
int main(void){
	PC=0; Rin=0; Rout=0; Entrada; R00 = R01 = R10 = R11 = 0; 
	>receber instrução
	
	while(){
		decoding=1;
		char str [4]; 
		fscanf(RegInstructions, "%s", str);
		for (i=0;i<2;i++){
			char straux [1];
			straux=str(i);
			switch(straux){
				case 0: instruction = 0000; break;
				case 1: instruction = 0001; break;
				case 2: instruction = 0010; break; 
				case 3: instruction = 0011; break;
				case 4: instruction = 0100; break;
				case 5: instruction = 0101; break;
				case 6: instruction = 0110; break;
				case 7: instruction = 0111; break;
				case 8: instruction = 1000; break;
				case 9: instruction = 1001; break;
				case A: instruction = 1010; break;
				case B: instruction = 1011; break;
				case C: instruction = 1100; break;
				case D: instruction = 1101; break;
				case E: instruction = 1110; break;
				case F: instruction = 1111; break;
			}
		}
		while(decoding==1){
			PC=PC+1;
			switch(instruction){
				case 0010:
					//MOV
					Rx=Ry; //Rx e Ry são registradores internos distintos 
					break;
				case 0011:
					//MVI
					Rx=Rin; //Rx é um registrador interno e Rin o de entrada
					break;		
				case 0100:
					//ADD
					Rx=Rx+Ry; //Rx e Ry são registradores internos distintos
					break;
				case 0101:
					//SUB
					Rx=Rx-Ry; //Rx e Ry são registradores internos distintos					
					break;
				case 1100:
					//IN
					Rin=Entrada; //Rin é um registrador de entrada;
					break;
				case 1101:
					//OUT
					Rout=Rx;  //Rx é um registrador interno e Rout o de saída
					break;
			}
		}
	}
		