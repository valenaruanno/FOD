{Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.}

program ej8p2;
type
    cliente = record
        cod: integer;
        nombre: string[10];
    end;
    ventas = record
        cli: cliente;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    maestro = file of ventas;

    procedure informar (var mae: maestro);
    var 
        codAct, inioAct, mesAct, total, totEmpresa, totMes: integer;
        v: ventas;
    begin
        reset (mae);
        totEmpresa:= 0;
        while (not eof (mae)) do begin
            read (mae, v);
            codAct:= v.cli.cod;
            anioAct:= v.anio;
            total:= 0;
            writeln ('El cliente con codigo ',v.cli.cod,', cuyo nombre es ',v.cli.nombre,' posee el siguiente reporte:');
            writeln ('  Año: ',v.anio);
            while ((not eof (mae)) and (anioAct = v.anio)) do begin
                mesAct:= v.mes;
                totMes:= 0;
                writeln ('      Mes ',v.mesAct,': ');
                while ((not eof (mae)) and (anioAct = v.anio) and (mesAct = v.mes)) do begin
                    totMes:= totMes + v.monto;
                    read (mae, v);
                end;
                write (totMes:0:2);
                total:= total + totMes;
            end;
            writeln ('El cliente gasto en el año un total de ', total:0:2);
            totEmpresa:= totEmpresa + total;
        end;
        writeln ('El monto total de ventas obtenido por la empresa es de ', totEmpresa:0:2);
        close (mae);
    end;

    procedure importar (var mae: maestro);
    var
        txt: text;
        v: ventas;
    begin
        Assign (txt,'maestro.txt');
        reset (txt);
        rewrite (mae);
        while (not eof (txt)) do begin
            readln (txt, v.cli.cod, v.cli.nombre);
            readln (txt, v.anio, v.mes, v.dia, v.monto);
            write (mae, v);
        end;
        close (txt);
        close (mae);
    end;

var 
    mae: maestro;
begin
    Assign (mae, 'maestro');
    importar (mae);
    informar (mae);
end.
