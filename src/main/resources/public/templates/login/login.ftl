<!doctype html>
<html lang="en" manifest="/templates/sinconexion.appcache">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Jekyll v4.0.1">
    <title>Cliente HTML5</title>
    <link href="/templates/css/bootstrap.css" rel="stylesheet">
    <link href="/templates/login/signin.css" rel="stylesheet">
    <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
            integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
            integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
            crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
          integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk"
          crossorigin="anonymous">
    <link rel="canonical" href="https://getbootstrap.com/docs/4.5/examples/sign-in/">

    <!-- Bootstrap core CSS -->
    <!--<link href="../assets/dist/css/bootstrap.css" rel="stylesheet">-->

    <style>
        .rojo {
            color: red;
        }
        .bd-placeholder-img {
            font-size: 1.125rem;
            text-anchor: middle;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        @media (min-width: 768px) {
            .bd-placeholder-img-lg {
                font-size: 3.5rem;
            }
        }
    </style>
    <!-- Custom styles for this template -->
    <!--<link href="/public/templates/login/signin.css" rel="stylesheet">-->


    <script>

        //dependiendo el navegador busco la referencia del objeto.
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB

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

            var usuario = active.createObjectStore("usuario", {keyPath: 'user', autoIncrement: false});
            //creando los indices. (Dado por el nombre, campo y opciones)
            usuario.createIndex('por_user', 'user', {unique: true});
            var formularios = active.createObjectStore("formularios", { keyPath : 'id', autoIncrement : true });

            //creando los indices. (Dado por el nombre, campo y opciones)
            formularios.createIndex('por_id', 'id', {unique: true});

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
                document.querySelector("#user").value = '';

            };

            //abriendo la colección de datos que estaremos usando.
            var usuario = transaccion.objectStore("usuario");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            var request = usuario.put({
                user: document.querySelector("#user").value,
                name: document.querySelector("#name").value,
                password: document.querySelector("#password").value,

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

        function buscarUsuario() {
            //recuperando la matricula.
            var user = document.querySelector("#user").value;
            console.log("user digitada: " + user);

            //abriendo la transacción en modo readonly.
            var data = dataBase.result.transaction(["usuario"]);
            var usuario = data.objectStore("usuario");

            //buscando estudiante por la referencia al key.
            usuario.get("" + user).onsuccess = function (e) {

                var resultado = e.target.result;
                console.log("los datos: " + resultado);
                var form = document.getElementById("login")

                if (resultado !== undefined) {
                    var myHeaders = new Headers();

                    console.log(JSON.stringify(resultado));
                    myHeaders.append('usuario', "" + resultado.user);
                    if (resultado.user === document.querySelector("#user").value && resultado.password === document.querySelector("#password").value) {
                        if (navigator.onLine === false){
                            window.location.href = "/home";
                        }else{
                            form.submit();
                        }

                    } else {
                        form.submit();
                    }

                } else {
                    console.log("Usuario no encontrado...");

                    form.submit();
                }
            };

        }

    </script>

</head>
<body class="text-center body">

<form class="form-signin" action="/login" method="post" id="login">
    <img class="mb-4" src="/img/logo.png" alt="" width="72" height="72">
    <h1 class="h3 mb-3 font-weight-normal">Iniciar Sesi&#243n</h1>
    <label for="user" class="sr-only">Usuario</label>
    <input type="text" id="user" name="user" class="form-control" placeholder="Usuario" required autofocus>
    <label for="password" class="sr-only">Contrase&#241a</label>
    <input type="password" id="password" name="password" class="form-control" placeholder="Contrase&#241a" required>
    <button class="btn btn-lg btn-primary btn-block" type="button" onclick="buscarUsuario()" form="login">Iniciar
    </button>
    <a class="btn btn-lg btn-primary btn-block" type="submit" href="/register">Registrar</a>
    <label>
        <input class="checkbox mb-3" type="checkbox" value="remember-me" name="statu"> Recordarme
    </label>
    ${error}
    <p class="mt-5 mb-3 text-muted">&copy; 2019-2020</p>
</form>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"
        integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj"
        crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
        integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"
        integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI"
        crossorigin="anonymous"></script>
</body>
</html>



