<!DOCTYPE html>
<html lang="en" manifest="/templates/sinconexion.appcache">
<head>
    <meta charset="UTF-8">
    <title>Cliente HTML5</title>
    <link href="/templates/css/bootstrap.css" rel="stylesheet">

    <script src="/templates/js/offline.min.js"></script>
    <link rel="stylesheet" href="/templates/css/offline-theme-chrome.css" />
    <link rel="stylesheet" href="/templates/css/offline-language-spanish.css" />
    <link rel="stylesheet" href="/templates/css/offline-language-spanish-indicator.css" />

    <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
    <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <script
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDmO0JHOHAXY2C3Ud49KbMSwFf3APep1Ow&callback=initMap&libraries=&v=weekly"
            defer
    ></script>
    <style>
        body{
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            height: 100%;
        }
        .blog-header {
            line-height: 1;
            border-bottom: 1px solid #e5e5e5;
        }


        .h-250 { height: 290px; }
        @media (min-width: 768px) {
            .h-md-250 { height: 290px; }
        }


        /*
         * Blog posts
         */
        .blog-post {
            margin-bottom: 4rem;
        }
        .blog-post-title {
            margin-bottom: .25rem;
            font-size: 2.5rem;
        }
        .blog-post-meta {
            margin-bottom: 1.25rem;
            color: #999;
        }



        .col-md-6 {
            width: 100%;
            max-width: 300px;
            max-height: 350px;
            padding: 0px;
            margin: auto;
            opacity: .85;
            box-shadow: 0px 0px 3px #848484;
        }


        .boton1[type="submit"] {
            position: relative;
            background:  rgba(0, 117, 217, 0.7);
            color: #FFF;
            width: 100%;
            margin: 5px 0 25px;
            border: none;
            padding: 5px 0;
            font-size: 16px;
            font-weight: normal;
            font-family: Roboto;
            border-radius: 5px;
            box-shadow: 0px 0px 3px #848484;
            letter-spacing: 1px;
            cursor: pointer;
            transition: all .5s ease;
            opacity: .85;
            border-color: antiquewhite;
            top: -75px; /* ajustar los valores para mover la imagen */

        }

        .boton1[type="submit"]:hover {
            background: #3b4652;

        }


        .mb-4{
            position: relative;
            top: 0px; /* ajustar los valores para mover la imagen */
            left: -30px;
            border-radius: 50%;
            margin: 30%;
            height: 150px;
            width: 150px;
            border:2px solid #fff;
            display: block;
            top: -75px;
        }



        .nombre_especialista1{
            position: relative;
            top: -95px; /* ajustar los valores para mover la imagen */
            margin: auto;

        }

        .tipo_especialidad1{
            color: gray;
            position: relative;
            top: -95px; /* ajustar los valores para mover la imagen */

        }





        /*
         * Footer
         */
        .blog-footer {
            padding: 2.5rem 0;
            color: #999;
            text-align: center;
            background-color: #f9f9f9;
            border-top: .05rem solid #e5e5e5;
        }
        .blog-footer p:last-child {
            margin-bottom: 0;
        }
    </style>
    <script>
        var entro = false;
        var run = function(){
            if(entro === false){
                agregarUsuario();
                entro = true
            }
            if (Offline.state === 'up'){
                document.getElementById("mapa").disabled = false;
                document.getElementById("listado").disabled = false;
            }else{
                document.getElementById("mapa").disabled = true;
                document.getElementById("listado").disabled = true;
                console.log("no hay")
            }
            var req = new XMLHttpRequest();
            req.timeout = 20000;
            req.open('GET', "https://" + location.hostname + ":" + location.port + "/home", true);
            req.send();

        }

        setInterval(run, 3000);
        var indexedDB;
        var dataBase;

        indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB

        //indicamos el nombre y la versión
        dataBase = indexedDB.open("parcial2", 1);
        window.applicationCache.swapCache()

        dataBase.onupgradeneeded = function (e) {
            console.log("Creando la estructura de la tabla");

            //obteniendo la conexión activa
            active = dataBase.result;

            //creando la colección:
            //En este caso, la colección, tendrá un ID autogenerado.
            var formularios = active.createObjectStore("formularios", {keyPath: 'id', autoIncrement: true});

            //creando los indices. (Dado por el nombre, campo y opciones)
            formularios.createIndex('por_id', 'id', {unique: true});

            var usuario = active.createObjectStore("usuario", {keyPath: 'user', autoIncrement: false});
            //creando los indices. (Dado por el nombre, campo y opciones)
            usuario.createIndex('por_user', 'user', {unique: true});
        };

        //El evento que se dispara una vez, lo
        dataBase.onsuccess = function (e) {
            console.log('Proceso ejecutado de forma correctamente');
        };

        dataBase.onerror = function (e) {
            console.error('Error en el proceso: ' + e.target.errorCode);
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
            if ("${usuario.usuario}" !== "") {
                console.log("Entro y compilo")
                var request = usuario.put({
                    user: "${usuario.usuario}",
                    name: "${usuario.nombre}",
                    password: "${usuario.password}"

                });
                request.onerror = function (e) {
                    var mensaje = "Error: " + e.target.errorCode;
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
            console.log("user digitada: " + user);

            //abriendo la transacción en modo readonly.
            var data = dataBase.result.transaction(["usuario"]);
            var usuario = data.objectStore("usuario");

            //buscando estudiante por la referencia al key.
            usuario.get("" + user).onsuccess = function (e) {

                var resultado = e.target.result;
                console.log("los datos: " + resultado);

                if (resultado !== undefined) {
                    return true;

                } else {
                    return false;
                }
            };

        }
    </script>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <a class="navbar-brand" href="/"><img src="/img/logo.png" width="60" height="40" alt="Logo"></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
            aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ml-auto">
            <li class="nav-item">
                <a class="nav-link active" href="/formulario">Formulario</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" id="mapa" href="/formulario/mapa">Mapa</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" id="listado" href="/formulario/listado">Listado Del Formulario</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/login">Salir</a>
            </li>
        </ul>
    </div>
</nav>

    <main role="main" class="container">
        <a><br><br><br></a>
        <div class="col-md-6">
            <div class="row no-gutters  flex-md-row  position-relative ">
                <div class="col p-4 d-flex flex-column position-static ">
                    <strong class="bienvenido">Bienvenido!</strong>
                    <img class="mb-4" src="/img/user.png" alt="" height="125">

                    <h4 style="position: relative;
    top: -95px; /* ajustar los valores para mover la imagen */
    margin: auto;">${usuario.nombre}</h4>

                    <a href="/formulario" class="boton1 text-center" type="submit">Empezar -></a>

                </div>
            </div>
        </div>
    </main>

<script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
<script type="text/javascript" src="/templates/js/popper.min.js"></script>
<script type="text/javascript" src="/templates/js/bootstrap.js"></script>
</body>
</html>
