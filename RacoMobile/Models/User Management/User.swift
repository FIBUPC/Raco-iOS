//
//  User.swift
//  iRaco
//
//  Created by Alvaro Ariño Cabau on 06/02/2020.
//  Copyright © 2020 Alvaro Ariño Cabau. All rights reserved.
//

import Foundation

public class User {
    private var username: String
    private var assignatures: String
    private var avisos: String
    private var classes: String
    private var foto: String
    private var nom: String
    private var cognoms: String
    private var email: String
    private var additionalProperties: Dictionary<String, Any> = Dictionary<String, Any>()

    init() {
        self.username = ""
        self.assignatures = ""
        self.avisos = ""
        self.classes = ""
        self.foto = ""
        self.nom = ""
        self.cognoms = ""
        self.email = ""
        self.additionalProperties = Dictionary<String, Any>()
    }
    public func getUsername() -> String {
        return username
    }

    public func setUsername(username: String) {
        self.username = username
    }

    public func getAssignatures() -> String {
        return assignatures
    }

    public func setAssignatures(assignatures: String) {
        self.assignatures = assignatures
    }

    public func getAvisos() -> String {
        return avisos
    }

    public func setAvisos(avisos: String) {
        self.avisos = avisos
    }

    public func getClasses() -> String {
        return classes
    }

    public func setClasses(classes: String) {
        self.classes = classes
    }

    public func getFoto() -> String {
        return foto
    }

    public func setFoto(foto: String) {
        self.foto = foto
    }

    public func getNom() -> String {
        return nom
    }

    public func setNom(nom: String) {
        self.nom = nom
    }

    public func getCognoms() -> String {
        return cognoms
    }

    public func setCognoms(cognoms: String) {
        self.cognoms = cognoms
    }

    public func getEmail() -> String {
        return email
    }

    public func setEmail(email: String) {
        self.email = email
    }

    public func getAdditionalProperties() -> Dictionary<String, Any> {
        return self.additionalProperties
    }

    public func setAdditionalProperty(name: String, value: Any) {
        self.additionalProperties[name] = value
    }
}
