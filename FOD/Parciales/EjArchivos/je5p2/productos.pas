{Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.
}

program productos;
const 
    valorAlto = 9999;
    dimF = 3;
type
    producto = record 
        cod: integer;
        nombre: string[10];
        descripcion: string[30];
        stockDisp: integer;
        stockMin: integer;
        precio: real;
    end;

    maestro = file of producto;

    proDet = record
        cod: integer;
        cantVendida: integer;
    end;

    detalle = file of proDet;
    vector = array [1..dimF] of detalle;
    vectorPro = array [1..dimF] of proDet;


    procedure leer (var det: detalle; var p: proDet);
    begin
        if (not eof (det)) then
            read (det, p)
        else
            p.cod:= valorAlto;
    end;

    procedure minimo (var v: vector; var regV: vectorpro; var min: proDet);
    var
        i, pos: integer;
    begin
        for i:= 1 to dimF do begin
            if (regV[i].cod <= min.cod) then begin
                min:= regV[i];
                pos:= i;
            end;
        end;
        if (min.cod <> valorAlto) then
            leer (v[pos], regV[pos]);
    end;

    procedure actualizar (var mae: maestro; var txt: text; v: vector);
    var
        regV: vectorPro;
        min: proDet;
        p: producto;
        i, cant, cod: integer;
    begin
        rewrite (txt);
        reset (mae);
        read (mae, p);
        for i:= 1 to dimF do begin
			writeln ('Voy a leer un detalle');
            reset (v[i]);
            writeln ('Levante el detalle');
            leer (v[i], regV[i]);
            writeln ('Detalle leido');
        end;
		writeln('Lei todos los detalles');
        minimo (v, regV, min);
        writeln('Busque el minimo');
        while (min.cod <> valorAlto) do begin
            cod:= min.cod;
            cant:= 0;
            while (min.cod = cod) do begin
                cant:= cant + min.cantVendida;
                minimo (v, regV, min);
            end;
            while (min.cod <> cod) do 
                read (mae, p);
            p.stockDisp:= p.stockDisp - cant;
            if (p.stockDisp < p.stockMin) then 
                writeln (txt, p.nombre, ' ', p.descripcion, ' ', p.stockDisp,' ', p.precio);
            seek (mae, filePos (mae) - 1);
            write (mae, p);
            if (not eof (mae)) then
                read (mae, p);
        end;
        close (txt);
        close (mae);
        for i:= 1 to dimF do
            close (v[i]);
    end;

    procedure importarDetalle (var det: detalle);
    var
        nombre: string[15];
        p: proDet;
        txt: text;
    begin
        writeln ('Ingrese el nombre del detalle.txt de la sucursal');
        readln (nombre);
        Assign (det, 'detalle');
        Assign (txt, nombre);
        rewrite (det);
        reset (txt);
        while (not eof (txt)) do begin
            readln (txt, p.cod, p.cantVendida);
            write (det, p);
        end;
        writeln('Importe el detalle');
        close (txt);
        close (det);
    end;

    procedure cargarDetalles (var v: vector);
    var
        i: integer;
    begin
        for i:= 1 to dimF do 
            importarDetalle (v[i]);
        writeln('Detalles importados');
    end;

    procedure importarMaestro(var mae: maestro);
    var 
        txt: text;
        p: producto;
    begin
        Assign (txt,'productos.txt');
        reset (txt);
        rewrite (mae);
        while (not eof (txt)) do begin
            readln (txt, p.cod, p.nombre);
            readln (txt, p.stockDisp, p.descripcion);
            readln (txt, p.stockMin, p.precio);
            write (mae, p);
        end;
        close (txt);
        close (mae);
    end;

var 
    mae: maestro;
    v: vector;
    txt: text;
begin
    Assign (mae, 'maestro');
    Assign (txt,'informe');
    importarMaestro(mae);
    cargarDetalles (v);
    actualizar (mae, txt, v);
end.
