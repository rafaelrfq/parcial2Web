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
    public Usuario getUsuario(String username){
        return find(username);
    }
    public boolean verify_user(String username, String password){

        try {
            Usuario aux = find(username);
            if (aux.getUsuario().equals(username) && aux.getPassword().equals(password)){
                return true;
            }else {
                return false;
            }
        }catch (Exception e){
            return false;
        }
    }

}
