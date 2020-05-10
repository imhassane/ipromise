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
        useCreateIndex: true,
        useUnifiedTopology: true,
        useFindAndModify: false
    };

    async connect(): Promise<any> {
        let { DATABASE_URL = MongoRepository.LOCALHOST_DB } = process.env;
        if(process.env.NODE_ENV === "test") DATABASE_URL = `test-${DATABASE_URL}`;
        return conn(DATABASE_URL, MongoRepository.MONGO_OPTIONS);
    }

    async addEmail(email: string): Promise<Document> {
        let _email = new Email({email});
        return await _email.save();
    }

    async addPassword(email: Document, password: string): Promise<Document> {
        let _pass = new Password({ email, hash: password });
        _pass = await _pass.save();
        // @ts-ignore
        return _pass.email;
    }

    async addUser(user: UserParams): Promise<Document> {
        let _user = new User(user);
        return await _user.save();
    }

    deleteUser(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOneAndUpdate({ _id }, { $set: { isActive: false } }, { new: true });
    }

    forceDeleteUser(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOneAndRemove({ _id });
    }

    getOneUser(_id?: string, email?: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOne({ user: _id, email });
    }

    async getUserWithEmail(email: string): Promise<DocumentQuery<Document | null, Document, {}> & {} | null> {
        // @ts-ignore
        return Email.findOne({ email }).populate("user");
    }

    getUserWithID(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOne({ user: _id }).populate("user");
    }

    async updatePassword(email: Document, password: string): Promise<Document> {
        const _pass = new Password({ email, password });
        return await _pass.save();
    }

    updateUser(_id: string, user: UserParams): DocumentQuery<Document | null, Document, {}> & {} {
        return User.findOneAndUpdate({ _id }, { $set: user }, { new: true });
    }

    activateEmail(email: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOneAndUpdate({ email }, { $set: {isActive: true} }, { new: true });
    }

    getEmail(_id: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOne({ _id }).populate("user");
    }

    getEmailWithAddress(email: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOne({ email }).populate("user");
    }

    updateEmailAddress(_id: string, email: string): DocumentQuery<Document | null, Document, {}> & {} {
        return Email.findOneAndUpdate({ _id }, { $set:{ email }}, {new: true});
    }

    async verifyPassword(email: Document, password: string): Promise<boolean> {
        const _pass = await Password.findOne({ email, isActive: true });
        // @ts-ignore
        const result = _pass.verifyPassword(password);
        return result;
    }

}
