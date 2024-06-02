{Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).
}

program sistema;
const
    valorAlto = 9999;
    dimF = 2;
type
    info = record 
        codLoc: integer;
        codCepa: integer;
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;

    detalle = file of info;

    minis = record
        codLoc: integer;
        nombreLoc: string[15];
        codCepa: integer;
        nombreCepa: string[15];
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;

    maestro = file of minis;

    vector = array [1..dimF] of detalle;
    vectorR = array [1..dimF] of info;

    procedure leer (var det: detalle; var regD: info);
    begin
        if (not eof (det)) then begin
            read (det, regD);
        end
        else 
            regD.codLoc:= valorAlto;
    end;

    procedure minimo (var v: vector; var vecRI: vectorR; var min: info);
    var
        i, pos: integer;
    begin
        for i:= 1 to dimF do begin
            if (vecRI[i] < min) then begin
                min:= vecRI[i];
                pos:= i;
            end;
        end;
        if (min.codLoc <> valorAlto) then
            leer (v[pos], vecRI[pos]);
    end;

    procedure actualizar (var mae: maestro; var v: vector);
    var
        vecRI: vecotrR;
        m, act: minis;
        min: info;
        i: integer;
    begin
        reset (mae);
        read (mae, m);
        for i:= 1 to dimF do begin
            reset (v[i]);
            leer (v[i], vecRI[i]);
        end;
        minimo (v, vecRI, min);
        while (min.codLoc <> valorAlto) do begin
            act.codLoc:= min.codLoc;
            while (min.codLoc = act.codLoc) do begin
                act.codCepa:= min.codCepa;
                act.recuperados:= 0;
                act.fallecidos:= 0;
                while ((min.codLoc = codLocAct) and (min.codCepa = act.codCepa)) do begin
                    act.activos:= min.activos;
                    act.nuevos:= min.nuevos;
                    act.recuperados:= act.recuperados + min.recuperados;
                    act.fallecidos:= act.fallecidos + min.fallecidos;
                    minimo (v, vecRI, min);
                end;
                while ((m.codLoc <> act.codLoc)and (m.codCepa <> act.codCepa)) do begin
                    read (mae, m);
                    if ((m.codLoc <> min.codLoc) and (m.activos > 50)) then
                        writeln ('La localidad ',m.nombreLoc,' tiene un total de ',m.activos,' casos activos.');
                end;
                act.nombreLoc:= m.nombreLoc;
                act.nomCepa:= m.nombreCepa;
                seek (mae, filePos (mae) - 1);
                write (mae);
                if (not eof (mae)) then
                    read (mae, m);
            end;
        end;
        close (mae);
        for i:= 1 to dimF do
            close (v[i]);
    end;

    procedure importar (var det: detalle);
    var
        txt: text;
        nombre: string[10];
        i: info;
    begin
        writeln (Ingrese un nombre para asociarle al detalle);
        readln (nombre);
        Assign (det, nombre);
        Assign (txt,'detalle.txt');
        reset (txt);
        rewrite (det);
        while (not eof (txt)) do begin
            readln (txt, i.codLoc, i.codCepa, i.activos, i.nuevos, i.recuperados, i.fallecidos);
            writeln (det, i);
        end;
        close (txt);
        close (det);
    end;

    procedure importarDetalles (var v: vector);
    var
        det: detalle;
        i: integer;
    begin
        for i:= 1 to dimF do 
            importar (v[i]);
    end;

    procedure importarMaestro (var mae: maestro);
    var
        txt: text;
        m: minis;
    begin
        Assign (txt,'maestro.txt');
        reset (txt);
        rewrite (mae);
        while (not eof (txt)) do begin
            readln (txt, m.codLoc, m.nombreLoc);
            readln (m.codCepa, m.nombreCepa);
            readln (m.activos, m.nuevos, m.recuperados, m.fallecidos);
            write (mae, m);
        end;
        close (mae);
        close (txt);
    end;

var 
    mae: maestro;
    v: vector;
begin
    Assign (mae,'maestro');
    importarMaestro (mae);
    importarDetalles (v);
    actualizar (mae, v);
end.