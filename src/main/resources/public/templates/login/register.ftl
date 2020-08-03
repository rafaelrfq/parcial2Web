<#include "loginBase.ftl">

<#macro page_body>
    <form class="form-signin" action="/register" method="post" id="formula">
        <img class="mb-4" src="img/shopping-bag-2-512.gif" alt="" width="72" height="72">
        <h1 class="h3 mb-3 font-weight-normal">Registrar</h1>
        <label for="name" class="sr-only">Nombre</label>
        <input type="text" id="name" name="name" class="form-control" placeholder="Nombre" required autofocus>
        <label for="user" class="sr-only">Usuario</label>
        <input type="text" id="user" name="user" class="form-control" placeholder="Usuario" required autofocus>
        <label for="password"  class="sr-only">Contrase&#241a</label>
        <input type="password" id="password" name="password" class="form-control" placeholder="Contrase&#241a" required>
        ${error}
        <button class="btn btn-lg btn-primary btn-block" type="submit" form="formula">Registrar</button>
        <a class="btn btn-lg btn-danger btn-block " type="submit" href="/login">Volver Atras</a>
        <p class="mt-5 mb-3 text-muted">&copy; 2019-2020</p>
    </form>
</#macro>
<@display_page/>