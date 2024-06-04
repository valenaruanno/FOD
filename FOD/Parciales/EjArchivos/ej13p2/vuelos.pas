{Una compañía aérea dispone de un archivo maestro donde guarda información sobre sus
próximos vuelos. En dicho archivo se tiene almacenado el destino, fecha, hora de salida y la
cantidad de asientos disponibles. La empresa recibe todos los días dos archivos detalles
para actualizar el archivo maestro. En dichos archivos se tiene destino, fecha, hora de salida
y cantidad de asientos comprados. Se sabe que los archivos están ordenados por destino
más fecha y hora de salida, y que en los detalles pueden venir 0, 1 ó más registros por cada
uno del maestro. Se pide realizar los módulos necesarios para:
a. Actualizar el archivo maestro sabiendo que no se registró ninguna venta de pasaje
sin asiento disponible.
b. Generar una lista con aquellos vuelos (destino y fecha y hora de salida) que
tengan menos de una cantidad específica de asientos disponibles. La misma debe
ser ingresada por teclado.
NOTA: El archivo maestro y los archivos detalles sólo pueden recorrerse una vez.}

program vuelo;
const 
    valorAlto = 'zzz';
type 
    vuelos = record
        destino: string[15];
        fecha: string[15];
        hora: string[15];
        asientos: integer;
    end;

    arch = file of vuelos;

    procedure importar (var archivo: arch);
    var
        txt: text;
        v: vuelos;
        nombre: string[15];
    begin
        readln (nombre);
        Assign (txt, nombre);
        reset (txt);
        rewrite (archivo);
        while (not eof (txt)) do begin
            readln (txt, v.asientos, v.destino);
            readln (txt, v.fecha);
            readln (txt, v.hora);
            write (archivo, v);
        end;
        writeln ('Archivo importado');
        close (txt);
        close(archivo);
    end;

    procedure leer (var det: arch; var regD: vuelos);
    begin
        if (not eof (det)) then
            read (det, regD)
        else 
            regD.destino:= valorAlto;
        writeln ('lei');
    end;

    procedure minimo (var det1, det2: arch; var regD1, regD2, min: vuelos);
    begin
        if (regD1.destino < regD2.destino) then begin
            min:= regD1;
            leer (det1, regD1);
        end 
        else begin
            min:= regD2;
            leer (det2, regD2);
        end;
    end;

    procedure actualizarYLista (var mae, det1, det2: arch; var nuevo: text);
    var
        regD1, regD2, regM, min: vuelos;
        cant, minDisp: integer;
    begin
        rewrite (nuevo);
        reset (mae);
        reset (det1);
        reset (det2);
        writeln ('Ingrese la cantidad de asientos dfisponibles minimos requeridos para no formar parte del nuevo archivo');
        readln (minDisp);
        leer (det1, regD1);
        leer (det2, regD2);
        minimo (det1, det2, regD1, regD2, min);
        while (min.destino <> valorAlto) do begin
            read (mae, regM);
            while ((not eof (mae)) and (min.destino <> regM.destino)) do begin
                read (mae, regM);
            end;
            cant:= 0;
            while ((not eof (mae)) and (min.destino = regM.destino) and (min.fecha = regM.fecha) and (min.hora = regM.hora)) do begin
                cant:= cant + min.asientos;
                minimo (det1, det2, regD1, regD2, min);
            end;
            regM.asientos:= regM.asientos - cant;
            if (regM.asientos < minDisp) then
                writeln (nuevo, regM.destino,' ',regM.asientos);
                writeln (nuevo, regM.hora);
                writeln (nuevo, regM.fecha);
            seek (mae, filePos(mae) - 1);
            write (mae, regM);
        end;
        close (mae);
        close (det1);
        close (det2);    
        close (nuevo);
    end;

var 
    mae, det1, det2: arch;
    nuevo: text;
begin
    Assign (mae,'maestro');
    Assign (det1,'detalle1');
    Assign (det2,'detalle2');
    writeln ('Ingrese el nombre del archivo maestro');
    importar (mae);
    writeln ('Ingrese el nombre del primer archivo detalle');
    importar (det1);
    writeln ('Ingrese el nombre del primer archivo detalle');
    importar (det2);
    writeln ('Fueron importados todos los archivos');
    Assign (nuevo,'nuevo.txt');
    actualizarYLista (mae, det1, det2, nuevo);
end.
