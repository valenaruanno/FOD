program parcial2;
type
    producto = record
        cod: integer;
        nombre: string[15];
        descripcion: string[60];
        precioCompra: real;
        precioVenta: real;
        ubicacion: integer;
    end;

    archivo = file of producto;

    procedure importarArchivo (var arch: archivo);
    var
        p: producto;
        txt: Text;
    begin
        Assign (txt, 'productos.txt');
        reset (txt);
        rewrite(arch);
        while (not eof(txt)) do begin
            readln(txt, p.cod, p.nombre);
            readln(txt, p.descripcion);
            readln(txt, p.precioCompra, p.precioVenta, p.ubicacion);
            write (arch,p);
        end;
        close(arch);
        close(txt);
    end;
    function existeProducto (var arch: archivo; cod: integer): boolean;
    var
        p: producto;
        esta: boolean;
    begin
        esta:= false;
        reset (arch);
        while ((not eof (arch)) and (esta = false)) do begin
            read (arch, p);
            if (p.cod = cod) then
                esta:= true;
        end;
        close(arch);
        existeProducto:= esta;
    end;

    procedure agregarProducto (var arch: archivo);
    var
        p, a: producto;
        ok: boolean;
        pos: integer;
    begin
        writeln ('Ingrese el codigo del producto a agregar');
        readln(p.cod);
        reset (arch);
        ok:= existeProducto (arch, p.cod);
        if (ok = false) then begin
            reset (arch);
            writeln ('Ingrese el nombre del producto');
            readln(p.nombre);
            writeln ('Ingrese la descripcion del producto');
            readln(p.descripcion);
            writeln ('Ingrese el precio de compra del producto');
            readln(p.precioCompra);
            writeln ('Ingrese el precio de venta del producto');
            readln(p.precioVenta);
            writeln ('Ingrese la ubicacion del producto');
            readln(p.ubicacion);
            read (arch, a);
            if (a.cod = 0) then begin
                seek (arch, fileSize (arch));
                write (arch, p);
            end
            else begin
                pos:= a.cod * -1;
                seek (arch, pos);
                read (arch, a);
                seek (arch, filePos(arch) - 1);
                write (arch, p);
                seek (arch, 0);
                write (arch, a);
            end;
            close (arch);
            writeln ('producto agregado');
        end
        else
            writeln('El producto ya existe');
    end;

    procedure eliminarProducto(var arch: archivo);
    var
        cod: integer;
        p, e: producto;
        ok: boolean;
    begin
        writeln ('Ingrese el codigo del producto a eliminar');
        readln(cod);
        ok:= existeProducto (arch, cod);
        if (ok) then begin
            reset(arch);
            read (arch, p);
            e:= p;
            while ((not eof (arch)) and (ok = true)) do begin
                read (arch, p);
                if (p.cod = cod) then begin
                    seek (arch, filePos (arch) - 1);
                    p.cod:=  filePos(arch) * -1;
                    write(arch, e);
                    seek (arch, 0);
                    write (arch, p);
                end;
            end;
            close(arch);
            writeln ('Producto eliminado correctamente');
        end
        else
            writeln ('El producto que quieres eliminar no se encuentra el archivo');
    end;
    
    procedure imprimirArchivo (var arch: archivo);
    var
		p: producto;
	begin
		reset(arch);
		while (not eof (arch)) do begin
			read (arch, p);
			writeln('Codigo: ',p.cod,', nombre: ',p.nombre,', descripcion: ', p.descripcion,', precio compra: ',p.precioCompra:0:2,', precio venta: ',p.precioVenta:0:2,', ubicacion: ',p.ubicacion);
		end;
		close(arch);
	end;
var
    arch: archivo;
    nombre: string[30];
begin
    nombre:= 'productosSuper';
    Assign (arch, nombre);
    importarArchivo (arch);
    agregarProducto (arch);
    eliminarProducto (arch);
    imprimirArchivo (arch);
end.
