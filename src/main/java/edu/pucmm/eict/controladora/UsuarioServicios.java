package edu.pucmm.eict.controladora;

import edu.pucmm.eict.logico.Usuario;

public class UsuarioServicios extends GestionadDB<Usuario>  {
    private static UsuarioServicios instance;

    public UsuarioServicios() {
        super(Usuario.class);
    }

    public static UsuarioServicios getInstance() {
        if(instance==null){
            instance = new UsuarioServicios();
        }
        return instance;
    }
}
