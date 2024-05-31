{Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.}

program indumentaria;
type 
    str30 = string[30];
    str10 = string[10];

    prendas = record 
        cod: integer;
        descripcion: str30;
        colores: str30;
        tipoPrenda: str10;
        stock: integer;
        precio: real;
    end;

    maestro = file of prendas;

    detalle = file of integer;

    procedure imprimirNuevo (var nuevo: maestro);
    var
        aux: prendas;
    begin
        while (not eof (nuevo)) do begin
            read (nuevo, aux);
            writeln ('El codigo de la prenda es ',aux.cod,', la descripcion es: ',aux.descripcion,', los colores disponibles son: ',aux.colores,', el tipo de prenda es: ',aux.tipoPrenda,', su stok es: ',aux.stock,' y el precio es $',aux.precio:0:2,'.');
        end;    
    end;

    procedure altas (var mae, nuevo, det2: maestro);
    var
        aux, d2: prendas;
        pos: integer;
    begin
        rewrite (nuevo);
        reset (mae);
        reset (det2);
        read (mae, aux);
        while (not eof (det2)) do begin
            read (det2, d2);
            if (aux.stock = 0) then begin
                seek (mae, fileSize (mae) + 1);
                write (mae, d2);
                write (nuevo, d2);
            end
            else begin
                pos:= aux.cod * -1;
                seek (mae, pos);
                read (mae, aux);
                seek (mae, pos);
                write (mae, d2);
                write (nuevo, d2);
                seek (mae, 0);
                write (mae, aux);
            end;
        end;
        close (nuevo);
        close (mae);
        close (det2);
    end;

    procedure bajas (var mae: maestro; var det: detalle);
    var
        aux, aux2: prendas;
        d, pos: integer;
    begin
        reset (mae); 
        reset (det);
        writeln ('Levante los archivos para realizar las bajas');
        while (not eof (det)) do begin
            read (det, d);
            writeln ('Leo el detalle');
            read (mae, aux);
            while (not eof (mae)) do begin
                aux2:= aux;
                writeln ('Lo busco en el maestro');
                while ((not eof (mae)) and (d <> aux.cod)) do 
                    read (mae, aux);
                if (d = aux.cod) then begin
                    seek (mae, filePos(mae) - 1);
                    pos:= filePos (mae);
                    aux.stock:= pos * -1;
                    write (mae, aux2);
                    seek (mae, 0);
                    write (mae, aux);
                    writeln ('Baja realizada');
                end;
                seek (mae, pos + 1);
            end;
        end;
        close (mae);
        close (det);
    end;

    procedure importarDetalle (var det: detalle);
    var
        txt: text;
        c: integer;
    begin
        Assign (txt,'detalleBajas.txt');
        reset (txt);
        rewrite(det);
        while (not eof (txt)) do begin
            readln (txt, c);
            write (det, c);
        end;
        writeln ('Importe el detalle');
        close (det);
        close (txt);    
    end;

    procedure importarMaestro (var mae: maestro);
    var
        txt: text;
        p: prendas;
    begin
        Assign (txt,'maestro.txt');
        reset (txt);
        rewrite (mae);
        while (not eof (txt)) do begin
            readln (txt, p.cod, p.descripcion);
            readln (txt, p.stock, p.colores);
            readln (txt, p.precio, p.tipoPrenda);
            write (mae, p);
        end;
        writeln ('Importe el maestro');
        close (txt);
        close (mae);
    end;

    var 
        mae,nuevo,det2: maestro;
        det: detalle;
    begin
        Assign (mae, 'maestro');
        Assign (det, 'detalle');
        Assign (det2, 'prendasNuevaTemporada');
		writeln ('Realice las asignaciones');
        importarMaestro (mae);
        importarDetalle (det);
        importarMaestro (det2);

        bajas (mae, det);
        Assign (nuevo, 'nuevoMaestro');
        altas (mae, nuevo, det2);
        imprimirNuevo (nuevo);
    end.
