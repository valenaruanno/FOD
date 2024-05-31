program redLan;
const 
    dimF = 3;
    valorAlto = 9999;
type
    rango = 1..dimF;
    info = record
        cod_usuario: integer;
        fecha: string[10];
        tiempo: real;
    end;

    detalle = file of info;
    maestro = file of info;

    vectorD = array [rango] of detalle;
    vectorR = array [rango] of info;

    {Lee un registro de un archivo detalle que se encuentra en el vector de detalles. Si no llego al final del archivo, guarda la informacion en un vector de
     informacion, de lo contrario, guarda en el vector de informacion un registro con el valor alto.}
    procedure leer (var det: detalle; var regD: info);
    begin
        if (not eof (det)) then begin
            read (det, regD);
            writeln ('Lei con exito');
        end
        else
            regD.cod_usuario:= valorAlto;   
        writeln ('Lei un detalle');
    end;

    {Voy a buscar el minimo entre los datos guardados en el vector de registros. Para ello inicializo una variable minimo de tipo info con un valor alto en el 
     codigo. Si no se encuentra un minimo el procedimiento que ha llamado terminara su proceso, de lo contrario, se debe avanzar en el archivo al cual
     pertenecia el minimo.}
    procedure minimo (var vD: vectorD; var vR: vectorR; var min: info);
    var
        i, pos: integer;
    begin
        min.cod_usuario:= valorAlto;
        //min.fecha:= 'ZZZZ';
        for i:= 1 to dimF do begin
            if (vR[i].cod_usuario < min.cod_usuario) then begin
                min:= vR[i];
                pos:= i;
            end;
        end;
        if (min.cod_usuario <> valorAlto) then
            leer(vD[pos], vR[pos]);             
    end;

    procedure crearMaestro (var vD: vectorD; var mae: maestro);
    var
        min, dato: info;
        vR: vectorR;
        i: integer;
    begin
        Assign (mae, 'maestro');
        rewrite (mae);
		writeln ('Maestro creado');
		
        // Levanto los archivos detalle de cada posicion del vector y leo cada archivo guardando los datos leidos en un vector de registros.
        for i:= 1 to dimF do begin                                  
            reset(vD[i]);	
            writeln ('Levante un detalle');
            leer(vD[i], vR[i]);	
        end;

        //Busco el minimo en el vactor de registros y obtengo el registro con el minimo en la variable min.
        writeln ('Busco el minimo');
        minimo (vD, vR, min);

        {Si el codigo de usuario de minimo es valor alto, termino el proceso. De lo contrario, voy a armar un registro dato acumulando toda la info de un 
         mismo usuario (si es que hay mas de uno).}
        while (min.cod_usuario <> valorAlto) do begin
            dato.cod_usuario:= min.cod_usuario;
            while (min.cod_usuario = dato.cod_usuario) do begin
                dato.fecha:= min.fecha;
                dato.tiempo:= 0;
                while ((min.cod_usuario = dato.cod_usuario) and (min.fecha = dato.fecha)) do begin
                    dato.tiempo:= dato.tiempo + min.tiempo;
                    minimo (vD, vR, min);
                end;
                writeln ('Escribo el maestro');
                write (mae, dato);
            end;
        end;

        //Cierro el archivo maestro creado y los archivos detalle de cada posicion del vector.
        writeln ('El maestro se termino de cargar');
        close (mae);
        for i:= 1 to dimF do 
            close (vD[i]);
    end;

    {Recibo una posicion de un vector, leo el detalle que se encuentra en un archivo de texto y lo copio en un archivo binario el cual se almacenara en la 
     posicion del vector recibida.}
    procedure cargarDetalle (var det: detalle);
    var
        txt: text;
        i: info;
    begin
        Assign (det, 'detalle');
        Assign (txt, 'infoDetalle.txt');
        rewrite (det);
        reset (txt);
        while (not eof (txt)) do begin
            read (txt, i.cod_usuario, i.tiempo, i.fecha);
            write (det, i);
        end;
        writeln ('Detalle cargado');
        close (txt);
        close (det);
    end;

    // Lo que hago es cargar en cada posicion de un vector todos los detalles. En cada posicion llamo a cargar detalle y le envio la posicion del vector actual.
    procedure cargarVector (var vD: vectorD);
    var
        i: integer;
    begin
        for i:= 1 to dimF do 
            cargarDetalle (vD[i]);
        writeln ('Vector cargado');
    end;

    procedure informarMaestro (var mae: maestro);
    var
        i: info;
    begin
        reset (mae);
        while (not eof (mae)) do begin
            read (mae, i);
            writeln ('El usuario ',i.cod_usuario,' en la fecha ',i.fecha,' se mantuvo conectado ',i.tiempo:0:2,' minutos');
        end;
        close(mae);    
    end;

var
    vD: vectorD;
    mae: maestro;
begin
	writeln ('hola');
    Assign (mae, 'maestro');
    cargarVector (vD);
    crearMaestro (vD, mae);
    informarMaestro (mae);
end.
