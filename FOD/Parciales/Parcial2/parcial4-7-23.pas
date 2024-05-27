program parcial;
type
    str15 = string [15];

    partido = record
        cod: integer;
        nombre: str15;
        anio: integer;
        codTorneo: integer;
        codEquipoRival: integer;
        golesFavor: integer;
        golesContra: integer;
        puntos: integer;
    end;

    archivo = file of partido;

    procedure informe(var arch: archivo);
    var
        anioAct, codTorneoAct, codEquipoAct, totalFavor, totalContra, cantGanados, cantEmpatados, cantPerdidos, cantPuntos, max: integer;
        p: partido;
        nombreAct, nombre: str15;
    begin
        reset (arch);
        read(arch, p);
        while (not eof (arch)) do begin
            anioAct:= p.anio;
            writeln ('Anio ', anioAct);
            while ((not eof (arch)) and (anioAct = p.anio)) do begin
                codTorneoAct:= p.codTorneo;
                max:= -1;
                writeln ('	Cod torneo ', codTorneoAct);
                while ((not eof (arch)) and (codTorneoAct = p.codTorneo)) do begin
                    codEquipoAct:= p.cod;
                    nombreAct:= p.nombre;
                    writeln ('		Cod equipo ', codEquipoAct,', nombre ', p.nombre);
                    totalFavor:= 0;
                    totalContra:= 0;
                    cantGanados:= 0;
                    cantEmpatados:= 0;
                    cantPerdidos:= 0;
                    cantPuntos:= 0;
                    while ((not eof (arch)) and (codEquipoAct = p.cod)) do begin
                        totalFavor:= totalFavor + p.golesFavor;
                        totalContra:= totalContra + p.golesContra;
                        if (p.puntos = 3) then
                            cantGanados:= cantGanados + 1
                        else begin
                            if (p.puntos = 1) then  
                                cantEmpatados:= cantEmpatados + 1
                            else
                                cantPerdidos:= cantPerdidos + 1;
                        end;
                        cantPuntos:= cantPuntos + p.puntos;
                        read (arch, p);
                    end;
                    writeln ('			Cantidad goles a favor equipo ',codEquipoAct,': ', totalFavor);
                    writeln ('			Cantidad goles en contra equipo ',codEquipoAct,': ', totalContra);  
                    writeln ('			Diferencia de goles equipo ',codEquipoAct,': ', (totalFavor - totalContra));  
                    writeln ('			Cantidad partidos ganados equipo ',codEquipoAct,': ', cantGanados);  
                    writeln ('			Cantidad partidos empatados equipo ',codEquipoAct,': ', cantEmpatados);  
                    writeln ('			Cantidad partidos perdidos equipo ',codEquipoAct,': ', cantPerdidos);  
                    writeln ('			Cantidad de puntos ganados por el equipo ',codEquipoAct,' en el torneo: ', cantPuntos);  
                    if (cantPuntos > max) then begin
                        max:= cantPuntos;
                        nombre:= nombreAct;
                    end;
                end;
                writeln ('	El equipo ', nombre, ' fue campeon del torneo ',codTorneoAct,' del anio ',AnioAct);
            end;
        end;
        close(arch);
    end;

    procedure importarArchivo(var arch: archivo);
    var
        txt: text;
        p: partido;
    begin
        Assign (txt, 'partidos.txt');
        reset(txt);
        rewrite (arch);
        while (not eof (txt)) do begin
            readln(txt, p.cod, p.anio, p.codTorneo);
            readln (txt, p.codEquipoRival, p.golesFavor, p.golesContra, p.puntos);
            readln (txt, p.nombre);
            write (arch, p)
        end;
        close(txt);
        close (arch);
    end;

var
    nombre: str15;
    arch: archivo;
begin
    writeln('Ingrese el nombre del archivo de partidos');
    readln(nombre);
    Assign (arch, nombre);
    importarArchivo(arch);
    informe(arch);
end.
