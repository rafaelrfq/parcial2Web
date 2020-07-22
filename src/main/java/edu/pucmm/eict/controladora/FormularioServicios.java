package edu.pucmm.eict.controladora;

import edu.pucmm.eict.logico.Formulario;

public class FormularioServicios extends GestionadDB<Formulario>{
    private static FormularioServicios instance;

    private FormularioServicios() {
        super(Formulario.class);
    }

    public static FormularioServicios getInstance(){
        if(instance==null){
            instance = new FormularioServicios();
        }
        return instance;
    }
}
