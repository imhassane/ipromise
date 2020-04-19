import { connect as conn } from "mongoose";
import Repository from "../types/Repository";
import {User, UserParams} from "../types/User";

export default class MongoRepository implements Repository {

    static LOCALHOST_DB = "mongodb://localhost:27017/ipromise-auth";
    static MONGO_OPTIONS = {
        useNewUrlParser: true,
        useCreateIndex: true
    };

    protected user: User = {
        _id: "",
        firstName: "",
        lastName: "",
        hasPassword: true,
        isActive: true,
        email: { _id: "", address: "", createdAt: new Date(), updatedAt: new Date()},
        createdAt: new Date(),
        updatedAt: new Date()
    };

    async connect(): Promise<any> {
        const { DATABASE_URL = MongoRepository.LOCALHOST_DB } = process.env;
        return await conn(DATABASE_URL, MongoRepository.MONGO_OPTIONS);
    }

    addPassword(userID: string, password: string): User {
        return this.user;
    }

    addUser(user: UserParams): User {
        return this.user;
    }

    deleteUser(_id: string): User {
        return this.user;
    }

    getOneUser(_id?: string, email?: string): User {
        return this.user;
    }

    getUserWithEmail(email: string): User {
        return this.user;
    }

    getUserWithID(_id: string): User {
        return this.user;
    }

    updatePassword(userID: string, password: string): User {
        return this.user;
    }

    updateUser(_id: string, user: UserParams): User {
        return this.user;
    }

}