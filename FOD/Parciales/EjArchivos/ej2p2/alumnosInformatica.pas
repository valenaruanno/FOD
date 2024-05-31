program informatica;
const 
    valorAlto = 9999;
type
    str10 = string[10];
    alumno = record
       cod: integer;
       apellido: str10;
       nombre: str10;
       cantSinFinal: integer;
       cantConFinal: integer;
    end;

    aluDet = record
        cod: integer;
        ok: integer;
    end;

    maestro = file of alumno;
    detalle = file of aluDet;

    procedure listar (var mae: maestro);
    var
        txt: text;
        a: alumno;
    begin
        Assign (txt,'listado.txt');
        rewrite (txt);
        reset(mae);
        while (not eof (mae)) do begin
            read (mae, a);
            if (a.cantConFinal > a.cantSinFinal) then begin
                writeln (txt, a.cod,' ', a.apellido,' ', a.nombre,' ',a.cantSinFinal,' ',a.cantConFinal);
            end;
        end;
        close (mae);
        close (txt);
    end;

    procedure leer (var det: detalle; var regD: aluDet);
    begin
        if (not eof (det)) then
            read (det, regD)
        else
            regD.cod:= valorAlto;
    end;

    procedure actualizar(var mae: maestro; var  det: detalle);
    var
        regD: aluDet;
        a: alumno;
    begin
        reset (mae);
        writeln ('abro el maestro');
        reset (det);
        writeln ('abro el detalle');
        leer (det, regD);
        writeln ('leo un registro detalle');
        while (regD. cod<> valorAlto) do begin
            read (mae, a);
            while (a.cod <> regD.cod) do
                read (mae, a);
                writeln ('leo un registro maestro');
            while (a.cod = regD.cod) do begin
                if (regD.ok = 1) then begin
                    a.cantConFinal:= a.cantConFinal + 1;
                    a.cantSinFinal:= a.cantSinFinal - 1;
                end
                else
					a.cantSinFinal:= a.cantSinFinal + 1;
                leer (det,regD);
                writeln ('leo un registro detalle');
            end;
            seek (mae, filePos (mae) - 1);
            write (mae, a);
            writeln ('Actualizo el maestro');
        end;
        writeln ('Termino la actualizacion');
        close (det);
        close (mae);
    end;

    procedure importarDetalle (var det: detalle);
    var
        a: aluDet;
        nombre: string;
        txt: text;
    begin
        writeln ('Ingrese la ruta del archivo detalle');
        readln (nombre);
        Assign (txt, nombre);
        reset (txt);
        rewrite (det);
        while (not eof (txt)) do begin
            read (txt, a.cod, a.ok);
            write (det, a);
        end;
        close (det);
        close (txt);    
    end;

    procedure importarMaestro (var mae: maestro);
    var
        a: alumno;
        nombre: string;
        txt: text;
    begin
        writeln ('Ingrese la ruta del archivo maestro');
        readln (nombre);
        Assign (txt, nombre);
        reset (txt);
        rewrite (mae);
        while (not eof (txt)) do begin
            readln (txt, a.cod, a.cantSinFinal, a.cantConFinal, a.apellido, a.nombre);
            write (mae, a);
        end;
        close (mae);
        close (txt);    
    end;

var 
    mae: maestro;
    det: detalle;
    opc: integer;
begin
    Assign (det, 'det');
    Assign (mae, 'mae');
    
    importarMaestro (mae);
    importarDetalle (det);

    writeln ('Ingrese un 1 si quiere actualizar el archivo maestro, un 2 si quiere listar en un archivo de texto o 3 si quiere cortar el programa');
    readln (opc);
    while (opc <> 3) do begin
        case (opc) of
            1: actualizar(mae, det);
            2: begin
                listar (mae);
            end;
        end;
        writeln ('Ingrese un 1 si quiere actualizar el archivo maestro, un 2 si quiere listar en un archivo de texto o 3 si quiere cortar el programa');
        readln (opc);
    end;
end. 
