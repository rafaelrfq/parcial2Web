<#include "base.ftl">

<#macro page_body>
    <div class="container">
        <br><h1 class="text-center">${title}</h1><br>
        <form method="post" action="/formulario">
            <div class="form-group">
                <label for="nombre">Nombre:</label>
                <input class="form-control" type="text" id="nombre" name="nombre" required>
            </div>
            <div class="form-group">
                <label for="sector">Sector:</label>
                <input class="form-control" type="text" id="sector" name="sector" required>
            </div>
            <div class="form-group">
                <label for="nivelEscolar">Nivel Escolar:</label>
                <select class="form-control" name="nivelEscolar" id="nivelEscolar">
                    <#list choices as choice>
                        <option value="${choice}">${choice}</option>
                    </#list>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Salvar</button>
        </form>
    </div>
</#macro>

<@display_page/>