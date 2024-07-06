package com.fcj.awsomebooks;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;

@SpringBootApplication
@ConfigurationPropertiesScan
public class AwsomeBooksApplication {

	public static void main(String[] args) {
		SpringApplication.run(AwsomeBooksApplication.class, args);
	}

}
