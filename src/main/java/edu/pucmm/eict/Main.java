package edu.pucmm.eict;

import edu.pucmm.eict.controladora.DataBaseServices;
import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.controladora.UsuarioServicios;
import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.Usuario;
import io.javalin.Javalin;
import io.javalin.core.util.RouteOverviewPlugin;

import java.sql.SQLException;
import java.util.*;

public class Main {
    public static void main(String[] args) throws SQLException {
        // Se inicia la base de datos
        DataBaseServices.getInstancia().startDB();

        // Se prueba la conexion con la DB
        DataBaseServices.getInstancia().testConn();
    //hi
        // Se agregan usuarios de prueba
        Usuario tmp = new Usuario("admin", "Administradora", "admin");
        UsuarioServicios.getInstance().crear(tmp);
        Formulario formulario = new Formulario("John Carlos", "Espaillar", "Grado", 19.439718, -70.543466);
        FormularioServicios.getInstance().crear(formulario);

        Javalin app = Javalin.create(javalinConfig -> {
            javalinConfig.addStaticFiles("/public"); //Agregamos carpeta public como source de archivos estaticos
            javalinConfig.registerPlugin(new RouteOverviewPlugin("rutas")); //Aplicamos el plugin de rutas
        }).start(7000);

        app.get("/", ctx -> {
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Homepage");
            ctx.render("/public/templates/home.ftl", contexto);
        });

        app.get("/formulario", ctx -> {
            List<String> choices = Arrays.asList("", "Basico", "Medio", "Grado Universitario", "Postgrado", "Doctorado");
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Formulario");
            contexto.put("choices", choices);
            ctx.render("/public/templates/formulario.ftl", contexto);
        });

        app.post("formulario", ctx -> {
            String nomb = ctx.formParam("nombre");
            String sector = ctx.formParam("sector");
            String nivelEscolar = ctx.formParam("nivelEscolar");
            System.out.println(nomb + " " + sector + " " + nivelEscolar);
            ctx.redirect("/formulario");
        });

        app.get("/formulario/listado", ctx -> {
            List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Listado Formularios");
            contexto.put("formularios", forms);
            ctx.render("/public/templates/listado_formulario.ftl", contexto);
        });

        app.get("/formulario/mapa", ctx -> {
            List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Listado Formularios Registrado Por el Usuario");
            contexto.put("formularios", forms);
            ctx.render("/public/templates/mapa.ftl", contexto);
        });

        // DataBaseServices.getInstancia().stopDB();
    }
}
