package org.b104.alfredo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
public class AlfredoApplication {

    public static void main(String[] args) {
        SpringApplication.run(AlfredoApplication.class, args);
    }

}
