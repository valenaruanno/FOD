{7) Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
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
casos activos (las localidades pueden o no haber sido actualizadas).}

program ej7p2.pas;
const 
    valorAlto = 9999;
type
    informe = record
        localidad: integer;
        cepa: integer;
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;

    minis = record
        localidad: integer;
        nombre: string[15];
        codCepa: integer;
        nomCepa: integer;
        activos: integer;
        nuevos: integer;
        recuperados: integer;
        fallecidos: integer;
    end;

    detalle = file of informe;
    maestro = file of minis;

    procedure leer (var det: detalle; var regD: informe);
    begin
        if (not eof (det)) then
            read (det, regD)
        else
            regD.localidad:= valorAlto;
    end;

    procedure minimo (var regD1, regD2, regD3, min: informe);
    begin
        if ((regD1 <= regD2) and (regD1 <= regD3)) then begin
            min:= regD1;
            leer (det1, regD1);
        end
        else
        begin
            if (regD2 <= regD3) then begin
                min:= regD2;
                leer(det2, regD2);
            end
            else
            begin
                min:= regD3;
                leer(det3, regD3);
            end;
        end;    
    end;

    procedure implementar (var mae: maestro; var det1, det2, det3: detalle; var regD1, regD2, regD3, min: informe; var regM: minis;);
    var
    begin
        reset(mae);
        reset (det1);
        reset (det2);
        reset (det3);
        reset (mae);
        leer (det1, regD1);
        leer (det2, regD2);
        leer (det3, regD3);
        minimo (regD1, regD2, regD3, min);
        while (min.localidad <> valorAlto) do begin
            read (mae, regM);
            while (regM.localidad <> min.localidad) do
                read(mae, regM);
            while (regM.localidad = min.localidad) do begin
                regM.fallecidos:= regM.fallecidos + min.fallecidos;
                regM.recuperados:= regM.recuperados + min.recuperados;
                regM.activos:= min.activos;
                regM.nuevos:= min.nuevos;
                minimo (regD1, regD2, regD3, min);
            end;
            seek (mae, filePos(mae) -1);
            write (mae, regM);
        end;
        close (det1);
        close (det2);
        close (det3);
        close (mae);
    end;

var 
    det1, det2, det3: detalle;
    mae: maestro;
    regD1, regD2, regD3, min: informe;
    regM: minis;
begin
    Assign (mae, 'maestro');
    Assign (det1, 'det1');
    Assign (det2,'det2');
    Assign (det3, 'det3');
    implementar (mae, det1, det2, det3, regD1, regD2, regD3, min, regM);
end.


