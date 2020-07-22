package edu.pucmm.eict.logico;

import java.io.Serializable;

public class Formulario implements Serializable {
    private String nombre;
    private String sector;
    private String nivelEscolar;
    private String latitud;
    private String longitud;

    public Formulario() { }

    public Formulario(String nombre, String sector, String nivelEscolar, String latitud, String longitud) {
        this.nombre = nombre;
        this.sector = sector;
        this.nivelEscolar = nivelEscolar;
        this.latitud = latitud;
        this.longitud = longitud;
    }

    public String getNombre() { return nombre; }

    public void setNombre(String nombre) { this.nombre = nombre; }

    public String getSector() { return sector; }

    public void setSector(String sector) { this.sector = sector; }

    public String getNivelEscolar() { return nivelEscolar; }

    public void setNivelEscolar(String nivelEscolar) { this.nivelEscolar = nivelEscolar; }

    public String getLatitud() { return latitud; }

    public void setLatitud(String latitud) { this.latitud = latitud; }

    public String getLongitud() { return longitud; }

    public void setLongitud(String longitud) { this.longitud = longitud; }
}
