import Repository from "./Repository";
import {UserParams} from "./User";
import {Document, DocumentQuery} from "mongoose";

export default interface Service {
    repository: Repository;

    // Getting a user given his ID or Email Address.
    getOneUser(_id?: string, email?: string): Promise<Document | null>

    // Getting a user given his ID.
    getUserWithID(_id: string): Promise<Document | null>

    // Getting a user given his Email Address.
    getUserWithEmail(email: string): Promise<Document | null>

    // Adding a user.
    addUser(user: UserParams): Promise<Document>

    // Update a user
    updateUser(_id: string, user: UserParams): Promise<Document | null>

    // Delete an user.
    deleteUser(_id: string): Promise<Document>

    // Adding a password.
    addPassword(emailID: string, password: string): Promise<Document>

    // Update a password.
    updatePassword(emailID: string, password: string): Promise<Document>

    // Adding an email address.
    addEmail(email: string): Promise<Document>

    // Getting an email address.
    getEmail(_id: string): Promise<Document | null>
}