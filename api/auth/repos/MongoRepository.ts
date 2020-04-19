import {connect as conn, Document, DocumentQuery} from "mongoose";
import Repository from "../types/Repository";
import {UserParams} from "../types/User";
import Email from "../schemas/Email";
import Password from "../schemas/Password";
import User from "../schemas/User";

export default class MongoRepository implements Repository {

    static LOCALHOST_DB = "mongodb://localhost:27017/ipromise-auth";
    static MONGO_OPTIONS = {
        useNewUrlParser: true,
        useCreateIndex: true
    };

    async connect(): Promise<any> {
        const { DATABASE_URL = MongoRepository.LOCALHOST_DB } = process.env;
        return conn(DATABASE_URL, MongoRepository.MONGO_OPTIONS);
    }

    async addEmail(email: string): Promise<Document> {
        let _email = new Email({email});
        return await _email.save();
    }

    async addPassword(email: Document, password: string): Promise<Document> {
        let _pass = new Password({ email, password });
        return await _pass.save();
    }

    async addUser(user: UserParams): Promise<Document> {
        let _user = new User(user);
        return await _user.save();
    }

    deleteUser(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return User.findOneAndUpdate({ _id }, { $set: { isActive: false } }, { new: true });
    }

    getOneUser(_id?: string, email?: string): DocumentQuery<Document | null, Document, {}> & {} {
        return User.findOne({ _id, email });
    }

    async getUserWithEmail(email: string): Promise<DocumentQuery<Document | null, Document, {}> & {} | null> {
        const _email = await Email.findOne({ address: email });
        if(!_email) return null;

        // @ts-ignore
        return User.findOne({ _id: _email.user });
    }

    getUserWithID(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return User.findOne({_id});
    }

    async updatePassword(email: Document, password: string): Promise<Document> {
        const _pass = new Password({ email, password });
        return await _pass.save();
    }

    updateUser(_id: string, user: UserParams): DocumentQuery<Document | null, Document, {}> & {} {
        return User.findOneAndUpdate({ _id }, { $set: user }, { new: true });
    }

    getEmail(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOne({ _id });
    }

}
