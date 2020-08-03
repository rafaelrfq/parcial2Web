<#ftl encoding="utf-8">
<#macro page_head>
    <title>No title in page_head</title>
</#macro>

<#macro page_body>
    <h1>No page_body</h1>
</#macro>

<#macro display_page>
    <!DOCTYPE html>
    <html lang="en" >
    <head>
        <meta charset="UTF-8">
        <title>Cliente HTML5</title>
        <link href="/templates/css/bootstrap.css" rel="stylesheet">
        <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
        <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
        <script src="https://polyfill.io/v3/polyfill.min.js?features=default"></script>
        <script
                src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDmO0JHOHAXY2C3Ud49KbMSwFf3APep1Ow&callback=initMap&libraries=&v=weekly"
                defer
        ></script>
        <@page_head/>
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
    <@page_body/>
    <script type="text/javascript" src="/templates/js/jquery-3.5.1.slim.min.js"></script>
    <script type="text/javascript" src="/templates/js/popper.min.js"></script>
    <script type="text/javascript" src="/templates/js/bootstrap.js"></script>
    </body>
    </html>
</#macro>