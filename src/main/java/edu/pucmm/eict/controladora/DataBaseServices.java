package edu.pucmm.eict.controladora;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DataBaseServices {
    private static DataBaseServices instancia;
    private String URL = "jdbc:h2:tcp://localhost/~/Parcial2"; //Modo Server...


    private DataBaseServices() {

    }

    public static DataBaseServices getInstancia() {
        if (instancia == null) {
            instancia = new DataBaseServices();
        }
        return instancia;
    }

    /**
     * Metodo para el registro de driver de conexión.
     */


    public Connection getConexion() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(URL, "sa", "");
        } catch (SQLException ex) {
            System.out.println("aa" + ex);
            //Logger.getLogger(EstudianteServices.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }

    public void testConexion() {
        try {
            getConexion().close();
            System.out.println("Conexión realizado con exito...");
        } catch (SQLException ex) {
            System.out.println("bb" + ex);
            //Logger.getLogger(EstudianteServices.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

}
