package edu.pucmm.eict.controladora;

import edu.pucmm.eict.logico.Formulario;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import java.util.List;

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

    public List<Formulario> findByNombre(String nombre) {
        EntityManager em = getEntityManager();
        Query query = em.createQuery("SELECT f FROM Formulario f where f.nombre = :nombre");
        query.setParameter("nombre", nombre);
        List<Formulario> lista = query.getResultList();
        return lista;
    }
}