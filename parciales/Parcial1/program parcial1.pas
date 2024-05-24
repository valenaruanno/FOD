program parcial1;
type
	rangoD = 1..31;
	rangoM = 1..12;
	info = record
		anio: integer;
		mes: rangoM;
		dia: rangoD;
		idUsuario: integer;
		tiempoAcceso: real;
	end;
	archivo = file of info;
	
	procedure buscar(var arch: archivo; anio: integer; var ok: boolean);
	var
		idAct: integer;
		mesAct: rangoM;
		diaAct: rangoD;
		totalTiempoUsuario, totalTiempo: real;
		i: info;
	begin
		reset (arch);
		while (not eof(arch)) do begin
			read (arch,i);
			if (i.anio <> anio) then
				read (arch, i)
			else begin
				ok:= true;
				writeln ('Anio : ',anio);
				mesAct:= i.mes;
				writeln ('	Mes : ',i.mes);
				while ((not eof(arch)) and (i.mes = mesAct)) do begin
					diaAct:= i.dia;
					totalTiempo:= 0;
					while ((not eof (arch) and (i.dia = diaAct))) do begin
						writeln ('		Dia : ',i.dia);
						idAct:= i.idUsuario;
						totalTiempoUsuario:= 0;
						while((not eof (arch) and (idAct = i.idUsuario))) do begin
							totalTiempo:= totalTiempo + i.tiempoAcceso;
							totalTiempoUsuario:= totalTiempoUsuario + i.tiempoAcceso;
							read(arch, i);
						end;
						writeln ('			IdUsuario : ',idAct, '. Tiempo total de acceso en el dia ',diaAct,' mes ',mesAct,': ',totalTiempoUsuario:0:2);
					end;
					writeln ('		Tiempo total de acceso en el dia ',diaAct,' mes ',mesAct,': ',totalTiempo:0:2);
				end;
			end;
		end;
		close(arch);
	end;
	
	procedure importarArchivo (var arch: archivo);
	var
		txt: text;
		i: info;
	begin
		Assign (txt, 'informacion.txt');
		reset(txt);
		rewrite (arch);
		while (not eof (txt)) do begin
			readln (txt, i.anio, i.mes, i.dia, i.idUsuario, i.tiempoAcceso);
			write (arch, i);
		end;
		close (arch);
		close (txt);
	end;
var
	anio: integer;
	arch: archivo;
	nombre: string[20];
	ok: boolean;
begin
	ok:= false;
	writeln ('Ingrese el nombre del archivo que dispone de la informacion');
	readln(nombre);
	Assign (arch,nombre);
	importarArchivo (arch);
	writeln ('Ingrese el anio del cual desea obtener la informacion');
	readln(anio);
	buscar(arch, anio, ok);
	if (ok = false) then
		writeln ('Anio no encontrado');
end.
