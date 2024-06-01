{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia}

program ej4;
const 
    valorAlto = 'zzz';
type
    datos = record 
        nombre: string[15];
        cantAlfa: integer;
        encuestados: integer;
    end;

    maestro = file of datos;

    info = record
        nombre: string[15];
        codLoc: integer;
        cantAlfa: integer;
        encuestados: integer;
    end;

    detalle = file of info;

    procedure leer (var det: detalle; var regD: info);
    begin
        if (not eof (det)) then
            read (det, regD)
        else 
            regD.nombre:= valorAlto;
    end;
    
    procedure minimo (var regD1, regD2, min: info; var det1, det2: detalle);
    begin
        if (regD1 < regD2) then begin
            min:= regD1;
            leer (det1, regD1);
        end
        else
        begin
            min:= regD2;
            leer (det2, regD2);
        end;
    end;

    procedure actualizacion (var mae: maestro; var det1, det2: detalle);
    var
        regD1, regD2, min: info;
        regM: datos;
    begin
        reset (mae);
        reset (det1);
        reset (det2);
        leer (det1, regD1);
        leer (det2, regD2);
        minimo (regD1, regD2, min, det1, det2);
        while (min.nombre <> valorAlto) do begin
            read (mae, regM);
            while (min.nombre <> regM.nombre) do 
                read (mae, regM);
            while (regM.nombre = min.nombre) do begin
                regM.cantAlfa:= regM.cantAlfa + min.cantAlfa;
                regM.encuestados:= regM.encuestados + min.encuestados;
                minimo (regD1, regD2, min, det1, det2);
            end;
            seek (mae, filePos(mae) - 1);
            write (mae, regM);
        end;
        close (mae);
        close (det1);
        close (det2);
    end;

    procedure importarDet (var det: detalle);
    var
        txt: text;
        i: info;
    begin
        Assign (txt, 'detalle.txt');
        rewrite (det);
        reset (txt);    
        while (not eof (txt)) do begin
            read (txt, i.codLoc, i.cantAlfa, i.encuestados, i.nombre);
            write (det, i);
        end;
        close (det);
        close (txt);    
    end;

    procedure importarMae (var mae: maestro);
    var 
        txt: text;
        d: datos;
    begin
        Assign (txt, 'maestro.txt');
        rewrite (mae);
        reset (txt);
        while (not eof (txt)) do begin
            read (txt, d.cantAlfa, d.encuenstados, d.nombre);
            write (mae, d);
        end;
        close (mae);
        close (txt);
    end;
var 
    det1, det2: detalle;
    mae: maestro;
begin
    Assign (mae,'maestro');
    Assign (det1,'det1');
    Assign (det2,'det2');
    importarMae (mae);
    importarDet (det1);
    importarDet (det2);
    actualizacion (mae, det1, det2);
end.