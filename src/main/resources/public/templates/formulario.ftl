
<!DOCTYPE html>
<html lang="en" manifest="/templates/sinconexion.appcache">
<head>
    <meta charset="UTF-8">
    <title>Cliente HTML5</title>
    <script src="/templates/js/offline.min.js"></script>
    <link href="/templates/css/bootstrap.css" rel="stylesheet">
    <link rel="stylesheet" href="/templates/css/offline-theme-chrome.css" />
    <link rel="stylesheet" href="/templates/css/offline-language-spanish.css" />
    <link rel="stylesheet" href="/templates/css/offline-language-spanish-indicator.css" />

    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
    <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
    <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
    <script
            src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDmO0JHOHAXY2C3Ud49KbMSwFf3APep1Ow&callback=initMap&libraries=&v=weekly"
            defer
    ></script>
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


        function agregarFormulario() {
            var dbActiva = dataBase.result; //Nos retorna una referencia al IDBDatabase.

            //Para realizar una operación de agreagr, actualización o borrar.
            // Es necesario abrir una transacción e indicar un modo: readonly, readwrite y versionchange
            var transaccion = dbActiva.transaction(["formularios"], "readwrite");

            //Manejando los errores.
            transaccion.onerror = () => {
                alert(request.error.name + '\n\n' + request.error.message);
            };

            transaccion.oncomplete = () => {
                document.querySelector("#nombre").value = '';
                alert('Objeto agregado correctamente');
            };

            //abriendo la colección de datos que estaremos usando.
            var formularios = transaccion.objectStore("formularios");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            let temp = {
                nombre: document.querySelector("#nombre").value,
                sector: document.querySelector("#sector").value,
                nivelEscolar: document.querySelector("#nivelEscolar").value,
                latitud: document.querySelector("#latitud").value,
                longitud: document.querySelector("#longitud").value
            }

            var request = formularios.put(temp);

            request.onerror = function (e) {
                var mensaje = "Error: "+e.target.errorCode;
                console.error(mensaje);
                alert(mensaje)
            };

            request.onsuccess = () => {
                console.log("Datos Procesado con exito");
                document.querySelector("#nombre").value = "";
                document.querySelector("#sector").value = "";
                document.querySelector("#nivelEscolar").value = "";
                document.querySelector("#latitud").value = "";
                document.querySelector("#longitud").value = "";
                setearLocalizacion();
                listarDatos();
            };
        }

        function editarFormulario(idFormulario) {

            console.log("ID recibido: " + idFormulario);

            //abriendo la transacción en modo escritura.
            const transaccion = dataBase.result.transaction(["formularios"],"readwrite");
            const formularios = transaccion.objectStore("formularios");
            const requestEdicion = formularios.get(idFormulario);

            //buscando formulario por la referencia al key.
            requestEdicion.onsuccess = () => {

                let resultado = requestEdicion.result;
                console.log("los datos: "+JSON.stringify(resultado));

                if(resultado !== undefined){

                    document.querySelector("#nombre").value = resultado.nombre;
                    document.querySelector("#sector").value = resultado.sector;
                    document.querySelector("#nivelEscolar").value = resultado.nivelEscolar;
                    document.querySelector("#latitud").value = resultado.latitud;
                    document.querySelector("#longitud").value = resultado.longitud;
                    borrarFormulario(idFormulario);
                }else{
                    console.log("Formulario no encontrado...");
                }
            };
        }

        /**
         * Permite listar todos los datos digitados.
         */
        function listarDatos() {
            //por defecto si no lo indico el tipo de transacción será readonly
            var data = dataBase.result.transaction(["formularios"]);
            var formularios = data.objectStore("formularios");
            var contador = 0;
            var formularios_recuperados=[];

            //abriendo el cursor.
            formularios.openCursor().onsuccess=function(e) {
                //recuperando la posicion del cursor
                var cursor = e.target.result;
                if(cursor){
                    contador++;
                    //recuperando el objeto.
                    formularios_recuperados.push(cursor.value);
                    console.log(JSON.stringify(cursor.value));

                    //Función que permite seguir recorriendo el cursor.
                    cursor.continue();

                }else {
                    console.log("La cantidad de registros recuperados es: "+formularios_recuperados.length);
                }
            };

            //Una vez que se realiza la operación llamo la impresión.
            data.oncomplete = function () {
                imprimirTabla(formularios_recuperados);
            }
        }

        /**
         *
         * @param lista_formularios
         */
        function imprimirTabla(lista_formularios) {
            //creando la tabla...
            var tabla = document.createElement("table");
            tabla.setAttribute('class', 'table table-bordered')
            var filaTabla = tabla.insertRow();
            filaTabla.setAttribute("class","thead-dark")
            filaTabla.insertCell().textContent = "Nombre";
            filaTabla.insertCell().textContent = "Sector";
            filaTabla.insertCell().textContent = "Nivel Escolar";
            filaTabla.insertCell().textContent = "Latitud";
            filaTabla.insertCell().textContent = "Longitud";
            filaTabla.insertCell().textContent = "Acciones";

            for (var key in lista_formularios) {
                //
                filaTabla = tabla.insertRow();
                filaTabla.insertCell().textContent = ""+lista_formularios[key].nombre;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].sector;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].nivelEscolar;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].latitud;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].longitud;
                var btnEliminar = document.createElement('input');
                btnEliminar.setAttribute('class', 'btn btn-outline-danger')
                btnEliminar.setAttribute('type', 'button');
                btnEliminar.setAttribute('value', 'Eliminar');
                btnEliminar.setAttribute('onclick', 'borrarFormulario(' + lista_formularios[key].id + ')');
                var btnEditar = document.createElement('input');
                btnEditar.setAttribute('class', 'btn btn-outline-primary')
                btnEditar.setAttribute('type', 'button');
                btnEditar.setAttribute('value', 'Editar');
                btnEditar.setAttribute('onclick', 'editarFormulario(' + lista_formularios[key].id + ')');
                filaTabla.insertCell().append(btnEditar, btnEliminar);
            }

            document.getElementById("listaFormularios").innerHTML="";
            document.getElementById("listaFormularios").appendChild(tabla);
        }

        function borrarFormulario(idFormulario) {
            console.log("ID enviado: " + idFormulario);

            var data = dataBase.result.transaction(["formularios"], "readwrite");
            var formularios = data.objectStore("formularios");

            formularios.delete(idFormulario).onsuccess = function (e) {
                console.log("Formulario eliminado...");
                listarDatos();
            };
        }




        // Parte de WebSocket

        var webSocket;
        var tiempoReconectar = 5000;

        $(document).ready(function(){
            console.info("Iniciando Jquery -  Ejemplo WebServices");

            conectar();

            $("#boton").click(function(){

                if(!webSocket || webSocket.readyState == 3) {

                    alert("Debe conectarse a internet, antes de sincronizar")

                }else{
                    let data = dataBase.result.transaction(["formularios"]);
                    let formularios = data.objectStore("formularios");

                    formularios.openCursor().onsuccess = function (e) {
                        //recuperando la posicion del cursor
                        var cursor = e.target.result;
                        if (cursor) {
                            webSocket.send(JSON.stringify(cursor.value));
                            cursor.continue();
                        } else {
                            console.log("No hay mas datos.");
                        }
                    };
                    alert("Datos sincronizados");
                    dataBase.result.deleteObjectStore("formularios");
                }
            });
        });

        /**
         *
         * @param mensaje
         */
        function recibirInformacionServidor(mensaje){
            console.log("Recibiendo del servidor: "+mensaje.data)
            $("#mensajeServidor").append(mensaje.data);
        }

        function conectar() {
            webSocket = new WebSocket("wss://" + location.hostname + ":" + location.port + "/mensajeServidor");
            var req = new XMLHttpRequest();
            req.timeout = 5000;
            req.open('GET', "https://" + location.hostname + ":" + location.port + "/formulario", true);
            req.send();



            //indicando los eventos:
            webSocket.onmessage = function(data){recibirInformacionServidor(data);};
            webSocket.onopen  = function(e){
                var req = new XMLHttpRequest();
                req.timeout = 5000;
                req.open('GET', "https://" + location.hostname + ":" + location.port + "/formulario", true);
                req.send();
                console.log("Conectado - status "+this.readyState); };
            webSocket.onclose = function(e){

                console.log("Desconectado - status "+this.readyState);
                var req = new XMLHttpRequest();
                req.timeout = 5000;
                req.open('GET', "https://" + location.hostname + ":" + location.port + "/formulario", true);
                req.send();
            };
        }

        function verificarConexion(){
            if(!webSocket || webSocket.readyState == 3){
                conectar();
            }
        }

        setInterval(verificarConexion, tiempoReconectar); //para reconectar.
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
                <a class="nav-link active" href="/formulario">Formulario</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/formulario/mapa">Mapa</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/formulario/listado">Listado Del Formulario</a>
            </li>
            <li class="nav-item">
                <a class="nav-link active" href="/login">Salir</a>
            </li>
        </ul>
    </div>
</nav>
<main type="main">
    <div class="container">
        <br><h1 class="text-center">${title}</h1><br>
        <div class="form-group">
            <label for="nombre">Nombre:</label>
            <input class="form-control" type="text" id="nombre" name="nombre">
        </div>
        <div class="form-group">
            <label for="sector">Sector:</label>
            <input class="form-control" type="text" id="sector" name="sector">
        </div>
        <div class="form-group">
            <label for="nivelEscolar">Nivel Escolar:</label>
            <select class="form-control" name="nivelEscolar" id="nivelEscolar">
                <#list choices as choice>
                    <option value="${choice}">${choice}</option>
                </#list>
            </select>
        </div>
        <div class="form-group">
            <label for="latitud">Latitud:</label>
            <input class="form-control" type="text" id="latitud" name="latitud" readonly>
        </div>
        <div class="form-group">
            <label for="longitud">Longitud:</label>
            <input class="form-control" type="text" id="longitud" name="longitud" readonly>
        </div>
        <button class="btn btn-primary" onclick="agregarFormulario()">Salvar</button>
        <button class="btn btn-secondary" onclick="listarDatos()">Listar Datos</button>
    </div>
    <div class="container ">
        <br><button id="boton" class="btn btn-outline-success" type="button">Sincronizar Datos</button>
    </div>
    <br><br>
    <div class="container jumbotron-fluid" id="listaFormularios"></div>

    <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
    <script>
        var id, cantidad = 0;
        //Indica las opciones para llamar al GPS.
        var opcionesGPS = {
            enableHighAccuracy: true,
            timeout: 500,
            maximumAge: 0
        }

        $(document).ready(setearLocalizacion());

        function setearLocalizacion() {
            //Obteniendo la referencia directa.
            navigator.geolocation.getCurrentPosition(function(geodata){
                var coordenadas = geodata.coords;
                document.querySelector("#latitud").value = coordenadas.latitude;
                document.querySelector("#longitud").value = coordenadas.longitude;
            }, function(){
                document.querySelector("#latitud").value = "No permite el acceso del API GEO";
                document.querySelector("#longitud").value = "No permite el acceso del API GEO";
            }, opcionesGPS);

            //Obteniendo el cambio de referencia.
            id = navigator.geolocation.watchPosition(function(geodata){
                var coordenadas = geodata.coords;
                document.querySelector("#latitud").value = coordenadas.latitude;
                document.querySelector("#longitud").value = coordenadas.longitude;
                cantidad++;
                if(cantidad>=5){
                    navigator.geolocation.clearWatch(id);
                    console.log("Finalizando la trama")
                }
            },function(error){
                //recibe un objeto con dos propiedades: code y message.
                document.querySelector("#latitud").value = "No permite el acceso del API GEO. Codigo: "+error.code+", mensaje: "+error.message;
                document.querySelector("#longitud").value = "No permite el acceso del API GEO. Codigo: "+error.code+", mensaje: "+error.message;
            });
        }
    </script>
</main>
<script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
<script type="text/javascript" src="/templates/js/popper.min.js"></script>
<script type="text/javascript" src="/templates/js/bootstrap.js"></script>
</body>
</html>
