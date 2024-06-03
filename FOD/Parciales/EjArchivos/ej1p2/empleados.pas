{Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program empresa;
type
    comision = record 
        cod: integer;
        nombre: string[15];
        monto: real;
    end;

    maestro = file of comision;

    procedure compacto (var mae, nuevo: maestro);
    var
        c, act: comision;
    begin
        rewrite (nuevo);
        reset (mae);
        read (mae, c);
        while (not eof (mae)) do begin
            act:= c; 
            while ((not eof (mae)) and (c.cod = act.cod)) do begin
                act.monto:= act.monto + c.monto;
                read (mae, c);
            end;
            write (nuevo, act);
        end;
        close (nuevo);
        close (mae);
    end;

    procedure importarMae (var mae: maestro);
    var
        txt: text;
        c: comision;
    begin
        Assign (txt, 'maestro.txt');
        rewrite (mae);
        reset (txt):
        while (not eof (txt)) do begin
            readln (txt, c.cod, c.monto, c.nombre);
            write (mae, c);
        end;
        close (txt);
        close (mae);
    end;

var 
    mae, nuevo: maestro;
begin
    Assign (mae, 'maestro');
    Assign (nuevo, 'NuevoMaestro');
    importarMae (mae);
    compacto (mae, nuevo);
end.