{El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

progrma ej3p2;
const 
    valorAlto = 9999;
type 
    producto = record
        cod: integer;
        nombre: string[15];
        precio: real;
        stockAct: integer;
        stockMin: integer;
    end;

    venta = record 
        cod: integer;
        cantVendida: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

procedure listar (var mae: maestro; var txt: text);
var
    regM: producto;
begin
    Assign (txt,'stock_minimo.txt');
    rewrite (txt);
    reset (mae);
    while (not eof (mae)) do begin
        read (mae, regM);
        if (regM.stockAct < regM.stockMin) then
            writeln (txt, regM.cod,' ', regM.precio,' ',regM.stockAct,' ', regM.stockMin,' ',regM.nombre);
    end;
    close (txt);
    close (mae);
end;
procedure actualizar (var mae: maestro; var det: detalle);
var
    regM: producto;
    regD: venta;
begin
    reset (mae);
    reset (det);
    while (not eof (det)) do begin
        read (det, regD);
        read (mae, regM);
        while (regM.cod <> regD.cod) do
            read(mae, regM);
        while (regM.cod = regD.cod) do begin
            regM.stockAct:= regM.stockAct - regD.cantVendida;
            read (det, regD);
        end;
        seek (mae, fiePos(mae) - 1);
        write (mae, regM);
    end;
    close (mae);
    close (det);
end;

procedure importarDetalle (var det: detalle);
var
    txt: text;
    v: venta;
begin
    Assign (txt,'ventas.txt');
    reset (txt);
    rewrite (det);
    while (not eof (txt)) do begin
        read (txt, v.cod, v.cantVendida);
        write (det, v);
    end;
    close (det);
    close (txt);
end;

procedure importarMaestro (var mae: maestro);
var
    txt: text;
    p: producto;
begin
    Assign (txt,'maestro.txt');
    reset (txt);
    rewrite (mae);
    while (not eof (txt)) do begin
        read (txt, p.cod, p.precio, p.stockAct, p.stockMin, p.nombre);
        write (mae, p);
    end;
    close (txt);
    close (mae);
end;

var 
    mae: maestro;
    det: detalle;
    Assign (txt);
    opc: integer;
    ok: boolean;
begin
    Assign (mae,'maestro');
    Assign (det, 'detalle');
    importarMaestro (mae);
    importarDetalle (det);
    ok:= false;
    while (ok = false) do begin
        writeln ('Ingrese el numero de opcion que desea realizar');
        writeln ('Ingrese el 1 si desea realizar una actualizacion maestro-detalle');
        writeln ('Ingrese el 2 si desea listar el maestro en un archivod e texto');
        writeln ('Ingrese el 3 si desea cortar el programa');
        readln (opc);
        case (opc) of 
            1: actualizar (mae, det);
            2: listar (mae, txt);
            3: ok:= true;
        end;
    end;
end.