<#include "base.ftl">

<#macro page_head>
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
            var formularios = active.createObjectStore("formularios", { keyPath : 'nombre', autoIncrement : false });

            //creando los indices. (Dado por el nombre, campo y opciones)
            formularios.createIndex('por_nombre', 'nombre', {unique: false});

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
            transaccion.onerror = function (e) {
                alert(request.error.name + '\n\n' + request.error.message);
            };

            transaccion.oncomplete = function (e) {
                document.querySelector("#nombre").value = '';
                alert('Objeto agregado correctamente');
            };

            //abriendo la colección de datos que estaremos usando.
            var formularios = transaccion.objectStore("formularios");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            var request = formularios.put({
                nombre: document.querySelector("#nombre").value,
                sector: document.querySelector("#sector").value,
                nivelEscolar: document.querySelector("#nivelEscolar").value,
                latitud: document.querySelector("#latitud").value,
                longitud: document.querySelector("#longitud").value
            });

            request.onerror = function (e) {
                var mensaje = "Error: "+e.target.errorCode;
                console.error(mensaje);
                alert(mensaje)
            };

            request.onsuccess = function (e) {
                console.log("Datos Procesado con exito");
                document.querySelector("#nombre").value = "";
                document.querySelector("#sector").value = "";
                document.querySelector("#nivelEscolar").value = "";
                document.querySelector("#latitud").value = "";
                document.querySelector("#longitud").value = "";
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

                    //Función que permite seguir recorriendo el cursor.
                    cursor.continue();

                }else {
                    console.log("La cantidad de registros recuperados es: "+contador);
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
            filaTabla.insertCell().textContent = "Nombre";
            filaTabla.insertCell().textContent = "Sector";
            filaTabla.insertCell().textContent = "Nivel Escolar";
            filaTabla.insertCell().textContent = "Latitud";
            filaTabla.insertCell().textContent = "Longitud";

            for (var key in lista_formularios) {
                //
                filaTabla = tabla.insertRow();
                filaTabla.insertCell().textContent = ""+lista_formularios[key].nombre;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].sector;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].nivelEscolar;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].latitud;
                filaTabla.insertCell().textContent = ""+lista_formularios[key].longitud;
            }

            document.getElementById("listaFormularios").innerHTML="";
            document.getElementById("listaFormularios").appendChild(tabla);
        }

        function borrarFormulario() {

            var nombre = prompt("Indique el nombre");
            console.log("Nombre digitado: "+nombre);

            var data = dataBase.result.transaction(["formularios"], "readwrite");
            var formularios = data.objectStore("formularios");

            formularios.delete(nombre).onsuccess = function (e) {
                console.log("Formulario eliminado...");
            };
        }
    </script>
</#macro>

<#macro page_body>
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
    <br><br>
    <div id="listaFormularios"></div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script>
        var id, cantidad = 0;
        //Indica las opciones para llamar al GPS.
        var opcionesGPS = {
            enableHighAccuracy: true,
            timeout: 5000,
            maximumAge: 0
        }

        $(document).ready(function(){

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
        });
    </script>
</#macro>

<@display_page/>