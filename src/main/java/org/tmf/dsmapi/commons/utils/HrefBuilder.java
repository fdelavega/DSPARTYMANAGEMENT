package org.tmf.dsmapi.commons.utils;

import org.tmf.dsmapi.commons.PropertiesSingleton;
import javax.ejb.EJB;
import javax.ejb.Stateless;
import javax.ws.rs.core.UriInfo;

/**
 * @author fdelavega
 */
@Stateless
public class HrefBuilder {

    @EJB
    private PropertiesSingleton properties;

    public String buildHref(UriInfo info, String id) {
        String server = properties.getServer();

        if (server == null) {
            // Use the URI info for generating the Href
            server = info.getAbsolutePath().toString();
        } else {
            String [] baseUriParts = info.getBaseUri().toString().split("/");
            server += baseUriParts[3] + "/" + baseUriParts[4] + "/" + info.getPath();
        }

        if (!server.endsWith("/")) {
            server += "/";
        }

        server += id;
        return server;
    }
}