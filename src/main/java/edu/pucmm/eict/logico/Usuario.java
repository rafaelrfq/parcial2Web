package edu.pucmm.eict.logico;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
public class Usuario {
    @Id
    private String usuario;
    @Column()
    private String nombre;
    @Column()
    private String password;
    @OneToMany(fetch = FetchType.LAZY, cascade=CascadeType.ALL , orphanRemoval = true)
    private List<Formulario> formularios = new ArrayList<Formulario>();
    /*dsfsdf*/


    public Usuario(){

    }
    public Usuario(String usuario, String nombre, String password) {
        this.usuario = usuario;
        this.nombre = nombre;
        this.password = password;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getNombre() {
        return nombre;
    }

    public void setNombre(String nombre) {
        this.nombre = nombre;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
