
package org.tmf.dsmapi.commons;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;
import java.util.ResourceBundle;
import javax.annotation.PostConstruct;
import javax.ejb.Singleton;

@Singleton
public class PropertiesSingleton {

    final private String propertiesFile = "/etc/default/tmf/settings.properties";
    private Properties props = null;

    private String server = null;

    @PostConstruct
    void init () {
        props = new Properties();

        try {
            props.load(new FileInputStream(propertiesFile));
        } catch (FileNotFoundException e) {
            props = null;
        } catch (IOException e) {
            props = null;
        }
    }

    public String getServer() {
        String envServer = System.getenv("BAE_SERVICE_HOST");
        if (envServer != null) {
            return envServer;
        }

        if (server == null && props != null) {
            server = (String) props.get("server");
            
            if (server != null && !server.endsWith("/")) {
                server += "/";
            }
        }
        return server;
    }
}