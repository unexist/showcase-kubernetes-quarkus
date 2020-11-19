/**
 * @package Quarkus-Kind-MP-Showcase
 *
 * @file Todo application
 * @copyright 2020 Christoph Kappel <christoph@unexist.dev>
 * @version $Id$
 *
 * This program can be distributed under the terms of the GNU GPLv2.
 * See the file COPYING for details.
 **/

package dev.unexist.showcase.todo.application;

import org.eclipse.microprofile.openapi.annotations.OpenAPIDefinition;
import org.eclipse.microprofile.openapi.annotations.info.Contact;
import org.eclipse.microprofile.openapi.annotations.info.Info;
import org.eclipse.microprofile.openapi.annotations.info.License;
import org.eclipse.microprofile.openapi.annotations.tags.Tag;

import javax.ws.rs.core.Application;

@OpenAPIDefinition(
    tags = {
        @Tag(name = "Todo", description = "Simple todo service"),
    },
    info = @Info(
        title = "Todo Service",
        version = "0.5",
        contact = @Contact(
            name = "Christoph Kappel",
            url = "https://unexist.dev",
            email = "christoph@unexist.dev"
        ),
        license = @License(
            name = "GPLv2",
            url = "https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html"
        )
    )
)
public class RestApplication extends Application {
}