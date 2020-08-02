

<!DOCTYPE html>
<html lang="en" manifest="/templates/sinconexion.appcache">
<head>
    <meta charset="UTF-8">
    <title>Cliente HTML5</title>
    <link href="/templates/css/bootstrap.css" rel="stylesheet">
    <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <script
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDmO0JHOHAXY2C3Ud49KbMSwFf3APep1Ow&callback=initMap&libraries=&v=weekly"
            defer
    ></script>
    <script>
        var indexedDB;
        var dataBase;

        indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB

        //indicamos el nombre y la versión
        dataBase= indexedDB.open("parcial2", 1);

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


        window.onload = function() {
            agregarUsuario()
        };







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
            if("${usuario.usuario}" !== ""){
                console.log("Entro y compilo")
                var request = usuario.put({
                    user: "${usuario.usuario}",
                    name: "${usuario.nombre}",
                    password: "${usuario.password}"

                });
                request.onerror = function (e) {
                    var mensaje = "Error: "+e.target.errorCode;
                    console.error(mensaje);
                    alert(mensaje)
                };

                request.onsuccess = function (e) {
                    console.log("Datos Procesado con exito");
                };
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
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/"><img src="/img/logo.png" width="60" height="40" alt="Logo"></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link" href="#">Ejemplo</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/formulario">Formulario</a>
            </li>
        </ul>
    </div>
</nav>
<main type="main">
    <br><h1 class="text-center">${title}</h1><br>
</main>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</body>
</html>
