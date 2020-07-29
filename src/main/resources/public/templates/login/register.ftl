<#include "loginBase.ftl">

<#macro page_body>
    <form class="form-signin" action="/registrer" method="post" id="formula">
        <img class="mb-4" src="img/shopping-bag-2-512.gif" alt="" width="72" height="72">
        <h1 class="h3 mb-3 font-weight-normal">Registrar</h1>
        <label for="inputEmail" class="sr-only">Nombre</label>
        <input type="text" id="inputEmail" name="name" class="form-control" placeholder="Name" required autofocus>
        <label for="inputEmail" class="sr-only">User</label>
        <input type="text" id="inputEmail" name="user" class="form-control" placeholder="User" required autofocus>
        <label for="inputPassword"  class="sr-only">Password</label>
        <input type="password" id="inputPassword" name="password" class="form-control" placeholder="Password" required>
        <button class="btn btn-lg btn-primary btn-block" type="submit" form="formula">Registrar</button>
        <a class="btn btn-lg btn-danger btn-block " type="submit" href="/login">Volver Atras</a>
        <label>
            <input class="checkbox mb-3" type="checkbox" value="remember-me" name="statu"> Recordarme
        </label>
        <p class="mt-5 mb-3 text-muted">&copy; 2019-2020</p>
    </form>
</#macro>
<@display_page/>