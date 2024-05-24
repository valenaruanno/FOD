pull para para traer las modificaciones de github a el repositorio local,
push para para traer las modificaciones del repositorio local a el github

//ubicarnos - posicionarnos en una carpeta
$ cd <url de la carpeta a la que se quiere acceder>


//iniciar un repositorio local
$ git init 


// conectarse a un repositorio remoto
$ git config user.name "valenaruanno"
$ git config user.email "valentinaruann2004@gmail.com"
$ git remote add origin "<url repositorio remoto>" 


//pasar un archivo de nuestro repositorio local al remoto
$ git status                                                                    //nos muestra los archivos que todavia no fueron agregados al repositorio remoto
$ git add <nombre archivo a agregar>                                            //el add lo agrega de forma provisoria 
$ git commit -m "<Ingresamos un mensaje referente a lo que hicimos>"
$ git push -u origin <nombre de la rama asociada>                               //pasa el archivo a nuestro repositorio remoto
                  

//para traer un repositorio remoto a uno local
//nos posicionamos en la carpeta donde lo queremos clonar
$ git clone <url delrepositorio remoto (en la barra de direcciones)>

//actualizarel repositorio con un cambio que hubo sobre una rama
$ git pull origin <rama que estamos utilizando> 

                        /* RAMAS */
//La rama es una linea de trabajo

//como saber en que rama estamos parados
$ git branch

//crear una rama
$ git branch <nombre>

//editar nombre rama 
$ git branch -m <nombre actual> <nombre nuevo>

//cambiar de rama
$ git checkout <nombre rama a la que quiero cambiar> 

//eliminar rama
$ gir branch -d <nombre rama a eliminar>                     //siempre pararse sobre el master para borrar una rama 

//crear archivos que no sean de la rama principal (siempre pararse en la rama a la cual le queremos agregar archivos)
$ touch "<nombre archivo>"
$ git add .
$ git commit -m <comiteo los archivos>

//conocer las diferencias entre dos ramas
$ git diff <primer rama a comparar> <segunda rama a comparar>  //si la primer rama tiene mas arch que la segunda aparece new file, de lo contrario aparece deleted file

//merge unifica dos ramas 
$ git merge <origen> <destino>                                //siempre pararse antes de realizar el merge en la rama que va arecibir los cambios
$ git add .
$ git commit -m cambiosMaster

            /* PASAR UN PROYECTO A GITHUB*/
//Desde la carpeta del proyecto

git init

git add .

git commit -m "first commit"

git remote add origin https://github.com/NOMBRE_USUARIO/NOMBRE_PROYECTO.git

git push -u origin master

