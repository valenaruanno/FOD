program dinosaurios;
type
    recordDinos = record
        cod: integer;
        tipo: string[10];
        altura: real;
        pesoProm: real;
        descripcion: string[30];
        zona: integer;
    end;

    tArchDinos = file of recordDinos;

    function existe (var a: tArchDinos; cod: integer): boolean;
    var
        d: recordDinos;
        ok: boolean;
    begin
        ok:= false;
        reset (a);
        while ((not eof (a)) and (not ok)) do begin
            read (a, d);
            if (d.cod = cod) then
                ok:= true;
        end;
        close (a);
        existe:= ok;
    end;

    procedure eliminar (var a: tArchDinos; cod: integer; var ok: boolean);
    var
        d, aux: recordDinos;
    begin
        ok:= existe (a, cod);
        if (ok) then begin
            reset (a);
            read (a, d);
            aux:= d;
            while ((not eof (a)) and (d.cod <> cod)) do
                read (a,d);
            seek (a, filePos(a) - 1);
            write (a, aux);
            seek (a, 0);
            d.cod:= d.cod * -1;
            write (a, d);
            writeln ('Dinosaurio eliminado correctamente');
            close (a);
        end
        else
            writeln ('El dinosaurio con codigo proporcionado no se encuentra dentro del archivo');
    end;

    procedure agregarDinosaurios (var a: tArchDinos; registro: recordDinos);
    var
        r: recordDinos;
        pos: integer;
    begin
        reset (a);
        read (a, r);
        if (r.cod = 0) then begin
            seek (a, fileSize (a));
            write (a, registro);
        end
        else
        begin
            pos:= r.cod * -1;
            seek (a, pos);
            read (a, r);
            seek (a, filePos(a) -1);
            write (a, registro);
            seek (a, 0);
            write (a, r);
        end;
        close (a);
    end;

    procedure leerDino (var registro: recordDinos);
    begin
        writeln ('Ingrese el codigo del dinosaurio');
        readln (registro.cod);
        if (registro.cod <> -1) then begin
            writeln ('Ingrese el tipo del dinosaurio');
            readln (registro.tipo);
            writeln ('Ingrese la aultura del dinosaurio');
            readln (registro.altura);
            writeln ('Ingrese el peso promedio del dinosaurio');
            readln (registro.pesoProm);
            writeln ('Ingrese la descripcion del dinosaurio');
            readln (registro.descripcion);
            writeln ('Ingrese la zona del dinosaurio');
            readln (registro.zona);
        end;
    end;

    procedure crearArchivo (var a: tArchDinos);
    var
        registro: recordDinos;
    begin
        rewrite (a);
        registro.cod:= 0;
        registro.tipo:= ' ';
        registro.altura:= 0;
        registro.pesoProm:= 0;
        registro.descripcion:= ' ';
        registro.zona:= 0;
        write (a, registro);
        close(a);
        leerDino (registro);
        while (registro.cod <> -1) do begin
            agregarDinosaurios (a, registro);
            leerDino (registro);
        end;
    end;

    procedure listar (var a: tArchDinos; var txt: text);
    var
        r: recordDinos;
    begin
        reset (a);
        rewrite (txt);
        while (not eof (a)) do begin
            read (a, r);
            if (r.cod > 0) then 
                writeln (txt, r.cod, ' ', r.tipo, ' ', r.altura:0:2,' ', r.pesoProm:0:2,' ', r.descripcion,' ', r.zona);
        end;
        close (a);
        close (txt);
    end;

var 
	d: recordDinos;
    a: tArchDinos;
    txt, intermedio, fin: text;
    ok: boolean;
    cod: integer;
begin
    Assign (a, 'dinosaurios');
    crearArchivo (a);
    Assign (txt, 'listado');
    Assign (intermedio, 'intermedio');
    Assign (fin, 'fin');
    listar (a, txt);
    ok:= true;
    while (ok) do begin
        writeln ('Ingrese el codiog de dinosaurio que desea eliminar');
        readln (cod);
        eliminar (a, cod, ok);
    end;
    listar (a,intermedio);
    leerDino (d);
    agregarDinosaurios(a, d);
    listar (a,fin);
end.
