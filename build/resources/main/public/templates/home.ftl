<#include "base.ftl">
    <#macro page_head>
        <script>

            //dependiendo el navegador busco la referencia del objeto.
            var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB || window.moz_indexedDB

            //indicamos el nombre y la versión
            var dataBase = indexedDB.open("parcial2", 1);


            //se ejecuta la primera vez que se crea la estructura
            //o se cambia la versión de la base de datos.
            dataBase.onupgradeneeded = function (e) {
                console.log("Creando la estructura de la tabla");

                //obteniendo la conexión activa
                active = dataBase.result;

                //creando la colección:
                //En este caso, la colección, tendrá un ID autogenerado.
                var formularios = active.createObjectStore("formularios", { keyPath : 'id', autoIncrement : true });

                //creando los indices. (Dado por el nombre, campo y opciones)
                formularios.createIndex('por_id', 'id', {unique: true});

                var usuario = active.createObjectStore("usuario", { keyPath : 'user', autoIncrement : false });
                //creando los indices. (Dado por el nombre, campo y opciones)
                usuario.createIndex('por_user', 'user', {unique : true});
            };

            //El evento que se dispara una vez, lo
            dataBase.onsuccess = function (e) {
                console.log('Proceso ejecutado de forma correctamente');
            };

            dataBase.onerror = function (e) {
                console.error('Error en el proceso: '+e.target.errorCode);
            };

            $(document).ready(function () {
                agregarUsuario()
            });




            function agregarUsuario() {




                var dbActiva = dataBase.result; //Nos retorna una referencia al IDBDatabase.

                //Para realizar una operación de agreagr, actualización o borrar.
                // Es necesario abrir una transacción e indicar un modo: readonly, readwrite y versionchange
                var transaccion = dbActiva.transaction(["usuario"], "readwrite");

                //Manejando los errores.
                transaccion.onerror = function (e) {
                    alert(request.error.name + '\n\n' + request.error.message);
                };

                transaccion.oncomplete = function (e) {

                    alert('Objeto agregado correctamente');
                };

                //abriendo la colección de datos que estaremos usando.
                var usuario = transaccion.objectStore("usuario");

                //Para agregar se puede usar add o put, el add requiere que no exista
                // el objeto.
                if(buscarUsuario() === false && "${usuario.usuario}" !== ""){
                    var request = usuario.put({
                        user: "${usuario.usuario}",
                        name: "${usuario.nombre}",
                        password: "${usuario.password}",

                    });
                }

                


            }
            function buscarUsuario() {
                //recuperando la matricula.
                var user = "${usuario.usuario}";
                console.log("user digitada: "+user);

                //abriendo la transacción en modo readonly.
                var data = dataBase.result.transaction(["usuario"]);
                var usuario = data.objectStore("usuario");

                //buscando estudiante por la referencia al key.
                usuario.get(""+user).onsuccess = function(e) {

                    var resultado = e.target.result;
                    console.log("los datos: "+resultado);

                    if(resultado !== undefined){
                        return true;

                    }else{
                        return false;
                    }
                };

            }
        </script>
    </#macro>

<#macro page_body>
    <br><h1 class="text-center">${title}</h1><br>
</#macro>

<@display_page/>