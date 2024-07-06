package com.fcj.awsomebooks.domain;

public class BookAlreadyExistsException extends RuntimeException {

	public BookAlreadyExistsException(String isbn) {
		super("A book with ISBN " + isbn + " already exists.");
	}

}
