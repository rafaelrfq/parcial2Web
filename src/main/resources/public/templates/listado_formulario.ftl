<#include "base.ftl">

<#macro page_body>
    <div class="container">
        <br><h1 class="text-center">${title}</h1><br>
        <table class="table table-bordered">
            <thead class="thead-light text-center">
            <th>Nombre</th>
            <th>Sector</th>
            <th>Nivel Escolar</th>
            <th>Acciones</th>
            </thead>
            <tbody class="text-center">
            <#list formularios as formu>
                <tr>
                    <td>${formu.nombre}</td>
                    <td>${formu.sector}</td>
                    <td>${formu.nivelEscolar}</td>
                    <td>
                        <a class="btn btn-danger" href="/formulario/listado/eliminar/${formu.id}">Eliminar</a>
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>
</#macro>

<@display_page/>