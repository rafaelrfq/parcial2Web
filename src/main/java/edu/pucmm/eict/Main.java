package edu.pucmm.eict;

import com.fasterxml.jackson.databind.ObjectMapper;
import edu.pucmm.eict.controladora.DataBaseServices;
import edu.pucmm.eict.controladora.FormularioServicios;
import edu.pucmm.eict.controladora.UsuarioServicios;
import edu.pucmm.eict.logico.Formulario;
import edu.pucmm.eict.logico.FormularioJSON;
import edu.pucmm.eict.logico.Usuario;
import io.javalin.*;
import io.javalin.core.util.RouteOverviewPlugin;
import org.eclipse.jetty.websocket.api.Session;
import org.hibernate.boot.archive.internal.UrlInputStreamAccess;

import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

import static io.javalin.apibuilder.ApiBuilder.*;
import static j2html.TagCreator.p;

public class Main {
    public static List<Session> usuariosConectados = new ArrayList<>();
    public static List<FormularioJSON> formulariosRecibidos = new ArrayList<>();
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
        }).start(5000);

        app.before(ctx -> {

                for (FormularioJSON formu : formulariosRecibidos) {
                    if (formu.getNombre() != null && formu.getSector() != null && formu.getNivelEscolar() != null) {
                        Formulario formuTmp = new Formulario(formu.getNombre(), formu.getSector(), formu.getNivelEscolar(), formu.getLatitud(), formu.getLongitud());
                        if (FormularioServicios.getInstance().findByNombre(formuTmp.getNombre()).isEmpty()) {
                            FormularioServicios.getInstance().crear(formuTmp);
                        }
                    }
                }

        });

        app.before("/home",ctx ->{
            if(ctx.sessionAttribute("usuario") ==null) {
                ctx.redirect("/login");
            }
        });



        app.routes(() -> {

            path("/formulario", () ->{
                before(ctx ->{
                    if(ctx.sessionAttribute("usuario") ==null) {
                        ctx.redirect("/login");
                    }
                });

                path("/", () -> {
                    get(ctx -> {
                        List<String> choices = Arrays.asList("", "Basico", "Medio", "Grado Universitario", "Postgrado", "Doctorado");
                        Map<String, Object> contexto = new HashMap<>();
                        contexto.put("title", "Formulario");
                        contexto.put("choices", choices);
                        ctx.render("/public/templates/formulario.ftl", contexto);
                    });
                    post(ctx -> {
                        String nomb = ctx.formParam("nombre");
                        String sector = ctx.formParam("sector");
                        String nivelEscolar = ctx.formParam("nivelEscolar");
                        System.out.println(nomb + " " + sector + " " + nivelEscolar);
                        ctx.redirect("/formulario");
                    });

                });
                path("/listado", () -> {
                    get(ctx -> {
                        List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
                        Map<String, Object> contexto = new HashMap<>();
                        contexto.put("title", "Listado Formularios");
                        contexto.put("formularios", forms);
                        ctx.render("/public/templates/listado_formulario.ftl", contexto);
                    });

                });

                path("/listado/eliminar/:id", () -> {
                    get(ctx -> {
                        Formulario temporal = FormularioServicios.getInstance().find(ctx.pathParam("id", Integer.class).get());
                        FormularioServicios.getInstance().eliminar(temporal.getId());
                        ctx.redirect("/formulario/listado/");
                    });

                });

                path("/mapa", () -> {
                    get(ctx -> {
                        List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
                        Map<String, Object> contexto = new HashMap<>();
                        contexto.put("title", "Listado Formularios Registrado Por el Usuario");
                        contexto.put("formularios", forms);
                        ctx.render("/public/templates/mapa.ftl", contexto);
                    });

                });

            });
        });

        app.get("/", ctx -> {
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Homepage");
            ctx.redirect("/login");
        });
        app.get("/home", ctx -> {
            Usuario aux = ctx.sessionAttribute("usuario");
            System.out.println("Llego: "+aux.getNombre());
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Homepage");
            contexto.put("usuario", aux);
            ctx.render("/public/templates/home.ftl", contexto);
        });

        app.get("/login", ctx -> {
            /*List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Listado Formularios Registrado Por el Usuario");
            contexto.put("formularios", forms);*/
            ctx.req.getSession().invalidate();
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("error", "");
            ctx.render("/public/templates/login/login.ftl",contexto);


        });
        app.post("/login", ctx -> {
            if (UsuarioServicios.getInstance().verify_user(ctx.formParam("user"), ctx.formParam("password"))){

                ctx.sessionAttribute("usuario",UsuarioServicios.getInstance().getUsuario(ctx.formParam("user")));
                ctx.redirect("/home");
            }else{
                Map<String, Object> contexto = new HashMap<>();
                contexto.put("error", p("Usuario/contraseña inccorecto").withClass("rojo").render());
                ctx.render("/public/templates/login/login.ftl",contexto);
            }

        });
        app.get("/register", ctx -> {
            /*List<Formulario> forms = FormularioServicios.getInstance().ListadoCompleto();
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("title", "Listado Formularios Registrado Por el Usuario");
            contexto.put("formularios", forms);*/
            Map<String, Object> contexto = new HashMap<>();
            contexto.put("error","");
            ctx.render("/public/templates/login/register.ftl",contexto);
        });
        app.post("/register", ctx -> {
            if (UsuarioServicios.getInstance().getUsuario(ctx.formParam("user")) == null){
                Usuario aux = new Usuario(ctx.formParam("user"),ctx.formParam("name"),ctx.formParam("password"));
                UsuarioServicios.getInstance().crear(aux);
                ctx.redirect("/login");
            }else{
                Map<String, Object> contexto = new HashMap<>();
                contexto.put("error", p("Usuario existente").withClass("rojo").render());
                ctx.render("/public/templates/login/register.ftl",contexto);
            }


        });

        app.ws("/mensajeServidor", ws -> {

            ws.onConnect(ctx -> {
                System.out.println("Conexión Iniciada - "+ctx.getSessionId());
                usuariosConectados.add(ctx.session);
            });

            ws.onMessage(ctx -> {
                //Puedo leer los header, parametros entre otros.
                ctx.headerMap();
                ctx.pathParamMap();
                ctx.queryParamMap();
                boolean condicion = true;
                FormularioJSON tempFormu = jacksonToObject(ctx.message());
                for(FormularioJSON formu : formulariosRecibidos){
                    if(tempFormu.getId() == formu.getId()){
                        condicion = false;
                    }
                }
                if(condicion){
                    formulariosRecibidos.add(tempFormu);
                }

                //
                System.out.println("Mensaje Recibido de "+ctx.getSessionId()+" ====== ");
                System.out.println("Mensaje: "+ ctx.message());
                System.out.println("================================");
                //
            });

            ws.onBinaryMessage(ctx -> {
                System.out.println("Mensaje Recibido Binario "+ctx.getSessionId()+" ====== ");
                System.out.println("Mensaje: "+ctx.data().length);
                System.out.println("================================");
            });

            ws.onClose(ctx -> {
                System.out.println("Conexión Cerrada - "+ctx.getSessionId());
                usuariosConectados.remove(ctx.session);
            });

            ws.onError(ctx -> {
                System.out.println("Ocurrió un error en el WS");
            });
        });

        // DataBaseServices.getInstancia().stopDB();
    }

    public static FormularioJSON jacksonToObject(String jsonString)
            throws IOException{
        ObjectMapper mapper = new ObjectMapper();

//        String jsonStr = mapper.writeValueAsString(foo);
//        assertEquals(foo.getId(),result.getId());
        return mapper.readValue(jsonString, FormularioJSON.class);
    }
}
