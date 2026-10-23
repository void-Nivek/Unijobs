


program interactive_V3;

uses crt,math,sysutils;


type
   
    residente = record 
        
        nome,escolaridade, bairro: string[100];
        idade: integer;
        sexo: string[1];
        renda,aux_renda,aux_idade: real;
        
        end;


var
    DataBase: file of residente;
    external_data: file of integer;
    
    registros: Array Of residente;

    i,Tpessoas,primarias,secundarias,universitarios,outros,criancas,adolescentes,jovens,idosos,sexoM,espaco:integer;
    media_renda,media_idade: real;
    sair: boolean;

function escolher_sexo: string; forward;
function interagir(const opcoes: array of string): integer; forward;    { funcao responsavel por tornar o menu interrativo, permitindo navegacao intuitiva e visual}
function menu_nivel_escolar: string; forward;                           {FUNCAO RESPONSAVEL POR SELECIONAR O NIVEL DE ESCOLARIDADE DE CADA INDIVIDUO CADASTRADO}
procedure ler_str(var palavra : string); forward;                       {PROCEDIMENTO RESPONSAVEL POR OBRIGAR O USUARIO A INSERIR SOMENTE CARACTERES DO ABECEDARIO}
procedure ler_int(var numero : integer); forward;                       {PROCEDIMENTO RESPONSAVEL POR OBRIGAR O USUARIO A INSERIR APENAS NUMEROS INTEIROS}
procedure ler_real(var numero : real); forward;                         {PROCEDIMENTO RESPONSAVEL POR OBRIGAR O USUARIO A INSERIR APENAS NUMEROS REAIS}
procedure pesquisar; forward;                                           {funcao responsavel pela pesquisa de casas}
procedure aumentar_espaco; forward;                                     {este procedimento aumenta o tamanho da array sempre que necessario}
procedure media; forward;                                               
procedure mediana; forward;
procedure desvio_padrao; forward;                                       {procedimento responsavel por calcular o desvio padrao}
procedure registrar; forward;                                           {este procedimento registra os dados das casas}
procedure menu_principal; forward;                                      {responsavel por apresentar o menu}
procedure show_data; forward;
procedure proporcao; forward;
procedure proporcaoP; forward;
procedure armazenar; forward;
procedure sincronizar_residente(posicao : integer); forward ;
procedure sincronizar_dados; forward;
procedure zerar_dados; forward;
procedure inicializar; forward;


procedure armazenar;
begin
if Tpessoas > 0 then begin
reset(database);
Seek(Database,filesize(Database));
write(database,registros[Tpessoas - 1]);
close(database);

reset(external_data);
write(external_data,Tpessoas,Primarias,secundarias,universitarios,outros,criancas,adolescentes,jovens,idosos,sexoM,espaco);
close(external_data);
end;
end;




procedure sincronizar_residente( posicao : integer);
var
aux_res : residente;

begin
reset(database);
for i:= 0 to posicao do
    read(database,aux_res);
close(database);

registros[posicao].nome := aux_res.nome;
registros[posicao].idade := aux_res.idade;
registros[posicao].sexo := aux_res.sexo;
registros[posicao].renda := aux_res.renda;
registros[posicao].bairro := aux_res.bairro;
registros[posicao].escolaridade := aux_res.escolaridade;
registros[posicao].aux_renda := aux_res.aux_renda;
registros[posicao].aux_idade := aux_res.aux_idade;

end;

procedure zerar_dados;
begin
reset(external_data);
for i := 1 to 11 do
write(external_data,0);
end;

procedure sincronizar_dados;
begin
reset(external_data);
read(external_data,Tpessoas); 
read(external_data,Primarias);
read(external_data,secundarias);
read(external_data,universitarios);
read(external_data,outros); 
read(external_data,criancas);
read(external_data,adolescentes);
read(external_data,jovens);
read(external_data,idosos);
read(external_data,sexoM);
read(external_data,espaco);
close(external_data);

end;


procedure proporcaop;
begin
with registros[tpessoas] do
begin
	if sexo='M' then sexoM:=sexoM + 1;
	
	if (idade >= 0) and (idade <=10 ) then
		criancas := criancas + 1 ;

	if (idade >= 11) and (idade <=17) then
		adolescentes := adolescentes + 1 ;

	
	if (idade >= 18) and (idade <=45) then
		jovens := jovens + 1;

		
	if (idade >= 46) then
		idosos := idosos + 1;
	
	if escolaridade = 'Primaria' then
		primarias := primarias + 1; 

	if escolaridade = 'Secundaria' then
		secundarias := secundarias + 1;

	if escolaridade = 'Universitario' then
		universitarios := universitarios + 1;	

	if escolaridade = 'outros' then
		outros := outros + 1;
end;

	
end;


procedure proporcao;
var
	perc_SexM,perc_SexF,Pidosos,perc_jovens,perc_cria,Pprimaria,perc_sec,perc_univrst:real;
begin
if Tpessoas >= 1 then begin
perc_SexM:=(sexoM/Tpessoas)*100;
perc_SexF:=100-perc_SexM;
perc_jovens:=(jovens/Tpessoas)*100;
Pidosos:=(idosos/Tpessoas)*100;
perc_cria:=(criancas/Tpessoas)*100;
Pprimaria:=(primarias/Tpessoas)*100;
perc_sec:=(secundarias/Tpessoas)*100;
perc_univrst:=(universitarios/Tpessoas)*100;

end;
writeln(' ------------proporcao dos generos-------------- ');
writeln('A proporcao de homens:',perc_SexM:0:1,'%');
writeln('A proporcao de Mulheres:',perc_SexF:0:1,'%');
writeln(' ------------proporcao das faixas etarias-------- ');
writeln('A proporcao de criancas:',perc_cria:0:1,'%');
writeln('A proporcao de jovens:',perc_jovens:0:1,'%');
writeln('A proporcao de idosos:',Pidosos:0:1,'%');
writeln(' ------------proporcao das escolaridades--------- ');
writeln('A proporcao de nivel primario:',Pprimaria:0:1,'%');
writeln('A proporcao de nivel secundario:',perc_sec:0:1,'%');
writeln('A proporcao de nivel universitario:',perc_univrst:0:1,'%');

end;	


procedure ler_str(var palavra : string );
var
    valida : boolean;
    aux_str: string ;
begin
repeat
valida := true ;
readln(aux_str);
for i := 1 to length(aux_str) do
    IF (aux_str[i] in ['0'..'9']) or (length(aux_str) = 0) then
        valida := false;

if valida=FALSE then writeln('invalido: nao devem haver numeros e ou ausencia de caracteres..tente novamente');
until valida=true;
palavra := aux_str;
end;

procedure ler_int(var numero :integer);
var
    letra: string;
    error_code: integer;
begin
repeat
readln(letra);
val(letra , numero, error_code);                                         {VAL SERVE PARA CONVERTER UM CARACTER NUMERICO PARA UM TIPO NUMERICO}
if (error_code <> 0) or (numero < 0 ) then
    writeln('   apenas numeros nao negativos sao permitidos..tente novamente');
until (error_code = 0) and (numero >= 0) ;
    

end;

procedure ler_real(var numero :real);
var
    letra: string;
   error_code: integer;
begin
repeat
readln(letra);
val(letra , numero, error_code);
if (error_code <> 0) or (numero < 0) then
    writeln('   apenas numeros nao negativos sao permitidos..tente novamente');
until (error_code = 0) and (numero >= 0) ;
    

end;


function escolher_sexo: string ;
var
    opcoes_sexo : array[0..1] of string;
begin

    opcoes_sexo[0] := 'Femenino'; opcoes_sexo[1] := 'Masculino';

case interagir(opcoes_sexo) of
1: escolher_sexo := 'F' ;
2: escolher_sexo := 'M' ;
end;

end;



{--sub-rotina para aumentar o tamanho da array Tpessoas}
procedure aumentar_espaco;
begin
setlength(registros,Tpessoas + 10);
espaco:= 10;
end;

procedure desvio_padrao;
var
soma_global_renda,soma_global_idade : real;
d_padrao_idade: REAL;
d_padrao_renda: REAL;

begin
soma_global_idade := 0;
soma_global_renda := 0; 

if tpessoas > 1 then begin {verificando se ha mais de um residente}

        for i := 0 to Tpessoas -1 do  
        begin
            soma_global_idade := soma_global_idade + ((registros[i].idade - media_idade)*(registros[i].idade - media_idade));
            soma_global_renda := soma_global_renda + ((registros[i].renda - media_renda)*(registros[i].renda- media_renda));
        end;

    soma_global_idade := soma_global_idade/(Tpessoas - 1);
    soma_global_renda := soma_global_renda/(Tpessoas - 1);
    d_padrao_idade := sqrt(soma_global_idade);
    d_padrao_renda := sqrt(soma_global_renda);
    writeln('Desvio padrao das idades :',(d_padrao_idade):0:2);
    writeln('Desvio padrao das rendas :',(d_padrao_renda):0:2); 
    end


    else writeln('Dados insuficientes para o desvio padrao');

end;


procedure media;
var
   soma_idade,soma_renda: real;
    
begin

if Tpessoas > 0 then 

begin

soma_idade := 0 ;
soma_renda := 0 ;

for i := 0 to Tpessoas-1 do
    begin
        with registros[i] do
        begin
            soma_idade := soma_idade + idade ; 
            soma_renda := soma_renda + renda ;
        end;
    end;
 
media_renda := (soma_renda/Tpessoas) ;    
media_idade := (soma_idade/Tpessoas) ;



writeln('media das idades :',(media_idade):0:2);
writeln('media das rendas :',(media_renda):0:2);

end;
end;



procedure mediana;
var
trocas,trocas2,indice: integer;
mediana_idade,mediana_renda,aux: real;

begin
 {verificando se ha casas registradas}
    if Tpessoas > 0 then 
    begin
    
        repeat
        
        trocas := 0 ;
        trocas2 := 0 ;
        for i := 0 to (Tpessoas - 2) do
    begin 
                    {colocando as idades e rendas auxiliares  em rool}
              
                        if registros[i].aux_idade > registros[i+1].aux_idade then
                        begin
                        aux := registros[i].aux_idade ;
                        registros[i].aux_idade := registros[i+1].aux_idade ;
                        registros[i+1].aux_idade := aux ;
                        trocas := trocas + 1 ;
                        end;

             
                    if registros[i].aux_renda > registros[i+1].aux_renda then
                        begin
                        aux := registros[i].aux_renda;
                        registros[i].aux_renda := registros[i+1].aux_renda;                      
                        registros[i+1].aux_renda := aux ;
                        trocas2 := trocas2 + 1 ;
                        end; 
                        
                                   
                        
        end;  

    until (trocas = 0) and (trocas2 = 0) ;

    {verificando se o total de residencias e par}

    if (Tpessoas mod 2)  = 0 then 
    begin
        indice:= (Tpessoas div 2) - 1  ;

        mediana_idade:= (registros[indice].aux_idade + registros[indice + 1 ].aux_idade) / 2 ;
    
        mediana_renda:= (registros[indice].aux_renda + registros[indice + 1].aux_renda) / 2 ;
    end
    
    else 
    begin
        indice:= ((Tpessoas + 1 ) div 2) -1 ;

        mediana_idade := registros[indice].aux_idade ;

        mediana_renda := registros[indice].aux_renda ;
    end;

writeln('Mediana das idades :', (mediana_idade):0:2);
writeln('Mediana das rendas :', (mediana_renda):0:2);
end
else writeln('Dados isuficientes para mediana' );
end;






function menu_nivel_escolar: string ; {submenu de escolha de nivel escolar }
	
    	var
	    	opcoes_nivel_escolar: array [0..3] of string;

	    begin
		    {atribuindo os niveis disponiveis}
		    opcoes_nivel_escolar[0]:= 'Primaria';
		    opcoes_nivel_escolar[1]:= 'Secundaria';
		    opcoes_nivel_escolar[2]:= 'Universitario';
		    opcoes_nivel_escolar[3]:= 'outro';


		    clrscr;
		    writeln('___________________________________NIVEL ESCOLAR__________________________________');
		    writeln;
		    writeln;

    
            case interagir(opcoes_nivel_escolar) of
            
                1: menu_nivel_escolar:= opcoes_nivel_escolar[0];
                2: menu_nivel_escolar:= opcoes_nivel_escolar[1];
                3: menu_nivel_escolar:= opcoes_nivel_escolar[2];
                4: menu_nivel_escolar:= opcoes_nivel_escolar[3];
                end;
        end;



{--sub-rotina para registro de casas--}
procedure registrar;
begin
with registros[Tpessoas] do  
    begin
       
        write('nome: '); ler_str(nome);
        write('idade: '); ler_int(idade); aux_idade:= idade;
        write('bairro: '); readln(bairro); {DEBUG nao definitivo, o ideal seria que o usuario escolhese opcoes predefinidas de bairro}
        write('renda: '); ler_real(renda); aux_renda:= renda;
        escolaridade:= menu_nivel_escolar;
        sexo := escolher_sexo;
	    proporcaoP;
   	    Tpessoas:= Tpessoas + 1;
        espaco:= espaco - 1;
        if espaco < 1 then aumentar_espaco;
        writeln('REGISTRADA COM SUCESO!');
        readln;        
    end;

end;


procedure pesquisar;{ metodos de pesquisa }
var
opcoes_pesquisar: array [0..4] of string;
aux_int,escolha,achados: integer;
existe: boolean;
aux_str : string;
S_minimo, S_maximo , auxiliar : real;

procedure verificar;
begin
	repeat
writeln('Digite o salario minimo e Maximo, Respectivamente');

readln(S_minimo, S_maximo);

if S_minimo > S_maximo then begin auxiliar:=S_minimo; S_minimo:=S_maximo; S_maximo:=auxiliar; end;

if (S_minimo < 0) or (S_maximo < 0) then writeln('os salarios nao podem ser negativos');
until  (S_minimo > 0) or (S_maximo > 0);

end;


procedure atualizar;
begin
    achados := achados + 1;
    existe := true;
end;

begin
            opcoes_pesquisar[0]:= 'pesquisar por nome';
		    opcoes_pesquisar[1]:= 'pesquisar por bairro';
		    opcoes_pesquisar[2]:= 'pesquisar por idades';
		    opcoes_pesquisar[3]:= 'pesquisar por sexos';
		    opcoes_pesquisar[4]:= 'pesquisar por faixa salarial';

clrscr;

	        writeln('_________________________________METODO DE PESQUISA___________________________________'); {area dos cabecalhos do submenu}
	    	writeln;



achados := 0;
escolha := interagir(opcoes_pesquisar);
case escolha of          {LEITURA E VALIDACAO}
1:begin write('nome :');  ler_str(aux_str); end;  
2:begin write('bairro:'); readln(aux_str); end;
3:begin write('idade:');  ler_int(aux_int); end;
4:aux_str := escolher_sexo;
5: begin
verificar;
end;

end;

clrscr;
for i := 0 to Tpessoas -1 do
    begin
    existe := false;    
    with registros[i] do
        begin

        if (escolha = 1) then 
            if (aux_str = nome) then 
                atualizar;              {ATUALIZAR INCREMENTA ACHADOS EM UMA UNIDADE} 

        if (escolha = 2) then 
                if (aux_str = bairro) then
                    atualizar;

        if (escolha = 3) then
                if (aux_int = idade) then 
                atualizar;

        if (escolha = 4) then
             if (aux_str = sexo) then
                atualizar;
 	if (escolha = 5 ) then if (renda >=S_minimo) and (renda <= S_maximo ) then atualizar;

        if existe then
            begin
                textcolor(blue);
                writeln('---------------------------------------------------------------___',achados,'___---------------------------------------------------------------------');
                textcolor(white);
                writeln;
                writeln('nome:',nome);
                writeln('bairro:',bairro);
                writeln('idade:',idade);
                writeln('sexo:',sexo);
                writeln('renda:',renda:2:2,'MT');
                writeln;
            end;
              
        end;    
    end;          
    
    if (achados <= 0) then 
      writeln('o dado nao consta da base de dados: '); 
    
readln;       
end;




procedure menu_principal; {subprograma para gestao dos menus e submenus}
var
	opcoes_menu: array [0..2] of string; {o array das opcoes do menu principal}


begin

	opcoes_menu[0]:='registrar casa';
	opcoes_menu[1]:='pesquisar casa';
	opcoes_menu[2]:='SAIR';

    
    window(screenwidth div 2 , 1 ,screenwidth, screenheight);
    textbackground(red);
	clrscr;

    writeln('GESTAO RESDENCIAL');
    writeln;

	case interagir(opcoes_menu) of 
    1:registrar;
	2:pesquisar;
    3:sair := true;
	end;

end;



function interagir( const opcoes: array of string): integer;    {a funcao interragir retorna um inteiro, que representa a opcao escolhida pelo usuario}


const
    {OS CARACTERES ESPECIAS PARA AS RESPECTIVAS TECLAS}
    UP = #72 ;	
	DOWN = #80 ;
	ENTER = #13 ;
	ESC = #27 ;

var
	key: char;
	i,posicao,posyf,posyi,posxi,inicio,limite: integer;
    { key : representa a tecla clicada
      posicao : representa a curente opcao }
        

{procedimento responsavel por colorir uma linha com a escolhida cor}
procedure pintar(linha: integer; cor: byte);	
begin
	gotoxy(posxi,posyi + linha);
	textcolor(cor);
	write(opcoes[linha]);

end;

begin

	inicio:= low(opcoes) ; { o primeiro indice do array}
	limite:= high(opcoes) ; { o tamanho maximo do array das opcoes}

	{armazenando as primeiras cordenadas do cursor}
    posyi := wherey; posxi := wherex;


	for i:= inicio TO limite do

		begin
		writeln(opcoes[i]);	   {escrevendo  opcoes} 
		end;

	{armazenando as cordenadas finais do cursor}
	posyf:= wherey; 

	posicao:= 0 ;		   { a posicao da primeira opcao, que convenientemente concide com o indice do array}
	pintar(posicao,blue) ; {destacando a primeira opcao}
	

	REPEAT

	key:= readkey;
	if key = #0 then
	begin
		key:= readkey;
		if (key = DOWN) then  { caso o usuario prima a seta baixo, a curente linha sera descolorida e a abaixo colorida }
		
		begin
		pintar(posicao,white);
		posicao:= posicao + 1;
		if posicao > limite then posicao:= inicio;
		pintar(posicao,blue);
		end
		
        else if (key = UP) then  {caso o usuario prima a tcla cima, a currente linha sera descolorida e a acima colorida}

		begin
		pintar(posicao,white);
		posicao:= posicao - 1;
		if posicao < inicio then posicao:= limite ;	
		pintar(posicao,blue);

		end;



	end;
	
	UNTIL key = ENTER ;

textcolor(white);
gotoxy(1,posyf + 4); clrscr; {saindo de forma limpa}	
interagir:= posicao + 1 ; { retornando a posicao escolhida no final do procedimento}

end;



procedure show_data;


begin

    textbackground(blue);
    window(1 , 1 ,screenwidth div 2, screenheight);
    clrscr;
    writeln;
    writeln('numero total de pessoas cadastradas : ',Tpessoas);
    media;
    mediana;
    desvio_padrao;
    Proporcao;


end;

procedure inicializar;
begin
assign(database,'SistemaINE.data');
assign(external_data,'estados.data');

if not fileexists('estados.data') then begin
rewrite(external_data);
close(external_data);
zerar_dados;
setlength(registros,10);
espaco := 10;
sexoM := 0;
Tpessoas := 0;
end
else begin
    sincronizar_dados;
    setlength(registros,Tpessoas +10);
    espaco := 10;
end;
if not fileexists('SistemaINE.data') then begin
    rewrite(database); close(database); end
else 
    IF tPESSOAs > 0 then
    for i := 0 to Tpessoas -1 do
        sincronizar_residente(i);

end;

BEGIN
clrscr;
textbackground(red);
clrscr;
inicializar;
repeat
show_data;
menu_principal;
armazenar;
until (sair = true);
END.



