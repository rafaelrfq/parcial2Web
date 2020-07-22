package edu.pucmm.eict;

import edu.pucmm.eict.controladora.DataBaseServices;
import edu.pucmm.eict.controladora.UsuarioServicios;
import edu.pucmm.eict.logico.Usuario;
import io.javalin.Javalin;
import io.javalin.core.util.RouteOverviewPlugin;

import java.sql.SQLException;

public class Main {
    public static void main(String[] args) throws SQLException {
        // Se inicia la base de datos
        DataBaseServices.getInstancia().startDB();

        // Se prueba la conexion con la DB
        DataBaseServices.getInstancia().testConn();

        // Se agregan usuarios de prueba
        Usuario tmp = new Usuario("admin", "Administradora", "admin");
        UsuarioServicios.getInstance().crear(tmp);

        Javalin app = Javalin.create(javalinConfig -> {
            javalinConfig.addStaticFiles("/public"); //Agregamos carpeta public como source de archivos estaticos
            javalinConfig.registerPlugin(new RouteOverviewPlugin("rutas")); //Aplicamos el plugin de rutas
        }).start(7000);

        DataBaseServices.getInstancia().stopDB();
    }
}
