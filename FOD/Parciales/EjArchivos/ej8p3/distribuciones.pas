{Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.}

progrma ejercicio;
type 
    distribuciones= record
        nombre: string[15];
        lanzamiento: integer;
        version: integer;
        cantDesarroladores: integer;
        descripcion: string [15];
    end;
    
    maestro = file of distribuciones;
 
    function existeDistribucion (var mae: maestro; nombre: string[15]): boolean;
    var
        esta: boolean;
        d: distribuciones;
    begin
        reset (mae);
        esta:= false;
        while (not eof (mae)) do begin
            read(mae, d);
            if (d.nombre = nombre) then
                esta:= true;
        end;
        close (mae);
        existeDistribucion:= esta;
    end;
    
    procedure BajaDistribución (var mae: maestro);
    var
        regM, cabezera, pos: distribuciones;
        ok, encontrado: boolean;
        nombre: string[15];
    begin   
        writeln ('Ingrese el nombre de la distribucion que desea eliminar');
        readln (nombre);
        ok:= existeDistribucion (mae, nombre);
        if (ok = true) then begin
            reset (mae);
            encontrado := false;
            read (mae, cabezera);
            while (encontrado = false) do begin
                read (mae, pos);
                if (pos.nombre = nombre) then
                    encontrado:= true;
            end;
            seek (mae, filePos(mae) - 1);
            write (mae, cabezera);
            pos.cantDesarrolladores: pos.cantDesarrolladores * -1;
            seek (mae, 0);
            write (mae, pos);
            close (mae);
            writeln ('Registro eliminado');
        end
        else
            writeln ('Distribucion no existente');
    end;
    
    procedure leer (var regM: distribuciones);
    begin
        writeln ('Insertar el nombre de la distribucion');
        readln (regM.nombre);
        writeln ('Insertar el año de lanzamiento de la distribucion');
        readln (regM.lanzamiento);
        writeln ('Insertar la version de la distribucion');
        readln (regM.version);
        writeln ('Insertar la cantidad de desarrolladores que trabajaron en la distribucion');
        readln (regM.cantDesarrolladores);
        writeln ('Insertar la descripcion de la distribucion');
        readln (regM.descripcion);
    end;
    
    procedure AltaDistribución (var mae: maestro);
    var 
        d, regM: distribuciones;
        ok: boolean;
    begin
        leer (regM);
        ok:= existeDistribucion (mae, regM.nombre);
        if (ok = false) then begin
            reset (mae);
            read (mae, d);
            if (d.cantDesarrolladores = 0) then begin
                seek (mae, fileSize (mae));
                write (mae, regM);
            end
            else begin
                seek (mae, d.cantDesarrolladores * -1);
                read (mae, d);
                seek (mae, filePos (mae) - 1);
                write (mae, regD);
                seek (mae, 0);
                write (mae, d);
            end;
            close (mae);
            writeln ('Alta realizada correctamente');
        end
        else
            writeln ('Ya existe la distribucion');
    end;
    
    procedure importarMestro (var mae: maestro);
    var 
        txt: text;
        d: distribucion;
    begin
        Assign (txt,'maestro.txt');
        rewrite (mae);
        reset (txt);
        while (not eof (txt)) do begin
            readln (txt, d.lanzamiento, d.nombre);
            readln (txt, d.version, d.cantDesarrolladores, d.descripcion);
            write (mae, d);
        end;
        close (mae);
        close (txt);
    end;
    
var
    mae: maestro;
begin
    Assign (mae, 'maestro');
    importarMestro (mae);
    AltaDistribución (mae);
    BajaDistribución (mae);
end.
