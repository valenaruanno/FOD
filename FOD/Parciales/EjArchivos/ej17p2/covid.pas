{Se cuenta con un archivo con información de los casos de COVID-19 registrados en los
diferentes hospitales de la Provincia de Buenos Aires cada día. Dicho archivo contiene: código
de localidad, nombre de localidad, código de municipio, nombre de municipio, código de hospital,
nombre de hospital, fecha y cantidad de casos positivos detectados. El archivo está ordenado
por localidad, luego por municipio y luego por hospital.
Escriba la definición de las estructuras de datos necesarias y un procedimiento que haga un
listado con el siguiente formato:
Nombre: Localidad 1
Nombre: Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
NombreHospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad 1
-----------------------------------------------------------------------------------------
Nombre Localidad N
Nombre Municipio 1
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio 1
…………………………………………………………………….
Nombre Municipio N
Nombre Hospital 1……………..Cantidad de casos Hospital 1
……………………..
Nombre Hospital N…………….Cantidad de casos Hospital N
Cantidad de casos Municipio N
Cantidad de casos Localidad N
Cantidad de casos Totales en la Provincia
Además del informe en pantalla anterior, es necesario exportar a un archivo de texto la siguiente
información: nombre de localidad, nombre de municipio y cantidad de casos del municipio, para
aquellos municipios cuya cantidad de casos supere los 1500. El formato del archivo de texto
deberá ser el adecuado para recuperar la información con la menor cantidad de lecturas
posibles.
NOTA: El archivo debe recorrerse solo una vez}
program municipios;
const
	valorAlto = 9999;
type
    str15 = string[15];
    hospitales = record
        codLoc: integer;
        nombreLoc: str15;
        codMuni: integer;
        nombreMuni: str15;
        codHosp: integer;
        nombreHosp: str15;
        fecha: str15;
        cantCasos: integer;
    end;

    maestro = file of hospitales;

	procedure leer (var mae: maestro; var h: hospitales);
	begin
		if (not eof (mae)) then
			read (mae, h)
		else
			h.codLoc:= valorAlto;
	end;
	
    procedure informe (var mae: maestro; var txt:text);
    var
        locAct, muniAct, hospAct: str15;
        cantHosp, cantLoc, cantMuni, total: integer;
        h: hospitales;
    begin
        reset (mae);
        rewrite(txt);
        total:= 0;
        leer (mae, h);
        while (h.codLoc <> valorAlto) do begin
            locAct:= h.nombreLoc;
            cantLoc:= 0;
            writeln ('Localidad: ',locAct);
            while ((h.codLoc <> valorAlto) and (locAct = h.nombreLoc)) do begin
                muniAct:= h.nombreMuni;
                cantMuni:= 0;
                writeln ('	Municipalidad: ',muniAct);
                while ((h.codLoc <> valorAlto) and (locAct = h.nombreLoc) and (muniAct = h.nombreMuni)) do begin
                    hospAct:= h.nombreHosp;
                    cantHosp:= 0;
                    writeln ('		Hospital: ',hospAct);
                    while ((h.codLoc <> valorAlto) and (locAct = h.nombreLoc) and (muniAct = h.nombreMuni) and (hospAct = h.nombreHosp)) do begin
                        cantHosp:= cantHosp + h.cantCasos;
                        leer (mae, h);
                    end;
                    writeln ('			Cantidad de casos del hospital ',hospAct,': ', cantHosp);
                    cantMuni:= cantMuni + cantHosp;
                end;
                writeln ('	Cantidad de casos municipio ',muniAct,': ', cantMuni);
                cantLoc:= cantLoc + cantMuni;
                if (cantMuni > 100) then
                    write (txt, locAct,' ',muniAct,' ',cantMuni);
            end;
            writeln ('Cantidad de casos de la localidad ',locAct,': ',cantLoc);
            total:= total + cantLoc;
        end;
        writeln ('La cantidad de casos totales de la provincia de Buenos Aires es: ', total);
        close (mae);
        close (txt);
    end;

    procedure importarMaestro (var mae: maestro);
    var
        h: hospitales;
        txt: text;
    begin
        Assign (txt,'hospitales.txt');
        rewrite (mae);
        reset (txt);
        while (not eof (txt)) do begin
            readln (txt, h.codLoc, h.nombreLoc);
            readln (txt, h.codMuni, h.nombreMuni);
            readln (txt, h.codHosp, h.nombreHosp);
            readln (txt, h.cantCasos, h.fecha);
            write (mae, h);
        end;
        close (mae);
        close (txt);
    end;

var
    mae: maestro;
    txt: text;
begin
    Assign (mae,'maestro');
    Assign (txt,'Informe');
    importarMaestro (mae);
    informe (mae, txt);
end.
