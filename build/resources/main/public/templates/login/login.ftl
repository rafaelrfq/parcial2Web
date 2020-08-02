<#include "loginBase.ftl">

<#macro page_head>
    <title>No title in page_head</title>
</#macro>


<#macro page_body>
    <form class="form-signin" action="/login" method="post" id="login">
        <img class="mb-4" src="img/shopping-bag-2-512.gif" alt="" width="72" height="72">
        <h1 class="h3 mb-3 font-weight-normal">Iniciar Sesi&#243n</h1>
        <label for="user" class="sr-only">Usuario</label>
        <input type="text" id="user" name="user" class="form-control" placeholder="Usuario" required autofocus>
        <label for="password"  class="sr-only">Contrase&#241a</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="Contrase&#241a" required>
        <button class="btn btn-lg btn-primary btn-block" type="button" onclick="buscarUsuario()" form="login">Iniciar</button>
        <a class="btn btn-lg btn-primary btn-block" type="submit" href="/register">Registrar</a>
        <label>
            <input class="checkbox mb-3" type="checkbox" value="remember-me" name="statu"> Recordarme
        </label>
        <p class="mt-5 mb-3 text-muted">&copy; 2019-2020</p>
    </form>
</#macro>
<@display_page/>