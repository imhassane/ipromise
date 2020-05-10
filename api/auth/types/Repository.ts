import {UserParams} from "./User";
import {Document, DocumentQuery} from "mongoose";

export default interface Repository {

    // Accessing to the database.
    connect(): any

    // Getting a user given his ID or Email Address.
    getOneUser(_id?: string, email?: string): DocumentQuery<Document | null, Document, {}> & {}

    // Getting a user given his ID.
    getUserWithID(_id: string): DocumentQuery<Document | null, Document, {}> & {}

    // Getting a user given his Email Address.
    getUserWithEmail(email: string): Promise<DocumentQuery<Document | null, Document, {}> & {} | null>

    // Adding a user.
    addUser(user: UserParams): Promise<Document>

    // Update a user
    updateUser(_id: string, user: UserParams): DocumentQuery<Document | null, Document, {}> & {}

    // Delete an user.
    deleteUser(_id: string): DocumentQuery<Document | null, Document, {}> & {}

    // Delete an user.
    forceDeleteUser(_id: string): DocumentQuery<Document | null, Document, {}> & {}

    // Reactivation of an user's account
    activateEmail(email: string): DocumentQuery<Document | null, Document, {}> & {}

    // Adding a password.
    addPassword(email: Document, password: string): Promise<Document>

    // Update a password.
    updatePassword(email: Document, password: string): Promise<Document>

    // Adding an email address.
    addEmail(email: string): Promise<Document>

    // Getting an email address.
    getEmail(_id: string): DocumentQuery<Document | null, Document, {}> & {}

    // Getting an email address with the email address.
    getEmailWithAddress(address: string): DocumentQuery<Document | null, Document, {}> & {}

    // Updating an email address.
    updateEmailAddress(_id: string, email: string): DocumentQuery<Document | null, Document, {}> & {}

    // Verifying user's password.
    verifyPassword(email: Document, password: string): Promise<boolean>
}