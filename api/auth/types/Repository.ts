import {User, UserParams} from "./User";

export default interface Repository {

    // Accessing to the database.
    connect(): any

    // Getting a user given his ID or Email Address.
    getOneUser(_id?: string, email?: string): User

    // Getting a user given his ID.
    getUserWithID(_id: string): User

    // Getting a user given his Email Address.
    getUserWithEmail(email: string): User

    // Adding a user.
    addUser(user: UserParams): User

    // Update a user
    updateUser(_id: string, user: UserParams): User

    // Delete an user.
    deleteUser(_id: string): User

    // Adding a password.
    addPassword(userID: string, password: string): User

    // Update a password.
    updatePassword(userID: string, password: string): User
}