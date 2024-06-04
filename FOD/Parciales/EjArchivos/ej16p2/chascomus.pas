{Una concesionaria de motos de la Ciudad de Chascomús, posee un archivo con información
de las motos que posee a la venta. De cada moto se registra: código, nombre, descripción,
modelo, marca y stock actual. Mensualmente se reciben 10 archivos detalles con
información de las ventas de cada uno de los 10 empleados que trabajan. De cada archivo
detalle se dispone de la siguiente información: código de moto, precio y fecha de la venta.
Se debe realizar un proceso que actualice el stock del archivo maestro desde los archivos
detalles. Además se debe informar cuál fue la moto más vendida.
NOTA: Todos los archivos están ordenados por código de la moto y el archivo maestro debe
ser recorrido sólo una vez y en forma simultánea con los detalles.
}

program motos;
const 
    valorAlto = 9999;
    dimF = 3;
type    
    motos = record
        cod: integer;
        nombre: string [15];
        descripcion: string[30];
        modelo: string[15];
        marca: string [15];
        stock: integer;
    end;

    maestro = file of motos;

    ventas = record
        cod: integer;
        precio: real;
        fecha: string[10];
    end;

    detalle = file of ventas;

    vector = array [1.. dimF] of detalle;
    vecReg = array [1..dimF] of ventas;

    procedure leer (var det: detalle; var ven: ventas);
    begin
        if (not eof (det)) then 
            read (det, ven)
        else
            ven.cod:= valorAlto;
    end;

    procedure minimo (var v: vector; var vecRD: vecReg; var min: ventas);
    var
        pos, i: integer;
    begin
        for i:= 1 to dimF do begin
            if (vecRD[i].cod < min.cod) then begin
                min:= vecRD[i];
                pos:= i;
            end;
        end;
        if (min.cod <> valorAlto) then
            leer (v[pos], vecRD[pos]);
    end;

    procedure actualizar (var mae: maestro; var v: vector);
    var
        min: ventas;
        vecRD: vecReg;
        i, stock, max: integer;
        m: motos;
        modeloMax: string[15];
    begin
        max:= -1;
        reset (mae);
        read (mae, m);
        for i:= 1 to dimF do begin
            reset (v[i]);
            leer (v[i], vecRD[i]);
        end;
        minimo (v, vecRD, min);
        while (min.cod <> valorAlto) do begin
            while (min.cod <> m.cod) do 
                read (mae, m);
            stock:= 0;
            while ((min.cod <> valorAlto) and (min.cod = m.cod)) do begin
                stock:= stock + 1;
                minimo (v, vecRD, min);
            end;
            m.stock:= m.stock - stock;
            if (stock > max) thn begin
                max:= stock;
                modeloMax:= m.modelo;
            end;
            seek (mae, filePos(mae) - 1);
            write (mae, m);
            if (not eof (mae)) then
                read (mae, m);
        end;
        close (mae);
        for i:= 1 to dimF do
            close (v[i]);
        writeln ('La moto mas vendida fue: ',modeloMax);
    end;

    procedure importar (det: detalle);
    var
        txt: text;
        ven: ventas;
        nombre: string[15];
    begin
        writeln ('Ingrese el nombre del detalle del vendedor');
        readln (nombre);
        Assign (txt, nombre);
        Assign (det, 'detalle');
        rewrite (det);
        reset (txt);
        while (not eof (txt)) do begin
            readln(txt, ven.cod, ven.precio, ven.fecha);
            write (det, ven);
        end;
        close (det);
        close (txt);
    end;

    procedure importarDetalles (var v: vector);
    var
        i: integer;
    begin
        for i:= 1 to dimF do
            importar (v[i]);
    end;

    procedure importarMaestro (var mae: maestro);
    var
        txt: text;
        m: motos;
    begin
        Assign (txt,'motos.txt');
        reset (txt);
        rewrite (mae);
        while (not eof (txt)) do begin
            readln (txt, m.cod, m.nombre);
            readln (txt, m.descripcion);
            readln (txt, m.modelo);
            readln (txt, m.stock, m.marca);
            write (mae, m);
        end;
        close (txt);
        close (mae);
    end;

var
    mae: maestro;
    v: vector;
begin
    Assign (mae, 'maestro');
    importarMaestro (mae);
    importarDetalles (v);
    actualizar (mae, v);
end.
