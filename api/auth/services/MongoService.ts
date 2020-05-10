import Service from "../types/Service";
import Repository from "../types/Repository";
import {UserParams} from "../types/User";
import MalformedDataError from "../errors/MalformedDataError";
import ResourceNotFoundError from "../errors/ResourceNotFoundError";
import {Document} from "mongoose";
import ResourceAlreadyExistsError from "../errors/ResourceAlreadyExistsError";

export default class MongoService implements Service {
    repository: Repository;

    constructor(repository: Repository) {
        this.repository = repository;
    }

    async addEmail(email: string): Promise<Document> {
        if(!email || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email))
            throw new MalformedDataError("The email address is not correct");
        return this.repository.addEmail(email);
    }

    async addPassword(emailID: string, password: string): Promise<Document> {
        password = password.trim();

        if(!password || password.length < 8)
            throw new MalformedDataError("The password should contain at least 8 characters");

        const _email = await this.repository.getEmail(emailID);
        if(!_email)
            throw new ResourceNotFoundError("The user specified does not exist");

        return this.repository.addPassword(_email, password);
    }

    async addUser(user: UserParams): Promise<Document> {
        if(!user.email || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(user.email))
            throw new MalformedDataError("The email address in not correct");

        if(!user.password || user.password.length < 8)
            throw new MalformedDataError("The password should be at least 8 characters");

        let _email = await this.repository.getEmailWithAddress(user.email);
        if(_email)
            throw new ResourceAlreadyExistsError("The given email address already exists");

        _email = await this.repository.addEmail(user.email);
        await this.repository.addPassword(_email, <string> user.password);
        return _email;
    }

    async deleteUser(_id: string): Promise<Document> {
        if(!_id)
            throw new MalformedDataError("The user's ID must be specified");

        const _user = await this.repository.deleteUser(_id);
        if(!_user)
            throw new ResourceNotFoundError("The user with the given ID does not exist");

        return _user;
    }

    async forceDeleteUser(_id: string): Promise<Document> {
        if(!_id)
            throw new MalformedDataError("The user's ID must be specified");

        const _user = await this.repository.forceDeleteUser(_id);
        if(!_user)
            throw new ResourceNotFoundError("The user with the given ID does not exist");

        return _user;
    }

    async getOneUser(_id?: string, email?: string): Promise<Document | null> {
        if(!_id && !email || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(<string>email))
            throw new MalformedDataError("The ID or the address email is required");

        const user = this.repository.getOneUser(_id, email);
        if(!user)
            throw new ResourceNotFoundError("The user with the given ID does not exist");
        return user;
    }

     async getUserWithEmail(email: string): Promise<Document | null> {
        if(!email || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(<string>email))
            throw new MalformedDataError("The email address is not valid");

        const _user = await this.repository.getUserWithEmail(email);
        if(!_user)
            throw new ResourceNotFoundError("The user with the given email address was not found");

        return _user;
    }

     async getUserWithID(_id: string): Promise<Document | null> {
        if(!_id)
            throw new MalformedDataError("The user's ID must be specified");

        const _user = await this.repository.getUserWithID(_id);
        if(!_user)
            throw new ResourceNotFoundError("The user with the given ID does not exist");

        return _user;
    }

    async updatePassword(emailID: string, password: string): Promise<Document> {
        if(!emailID)
            throw new MalformedDataError("The user's email ID must be specified");

        if(!password || password.length < 8)
            throw new MalformedDataError("The password must contain at least 8 characters");

        const _email = await this.repository.getEmail(emailID);
        if(!_email)
            throw new ResourceNotFoundError("No user has got this email address");

        return await this.repository.updatePassword(_email, password);
    }

    async updateUser(_id: string, user: UserParams): Promise<Document | null> {
        if(!_id)
            throw new MalformedDataError("The user's ID must be specified");

        let _user = await this.repository.getUserWithID(_id);
        if(!_user)
            throw new ResourceNotFoundError("The user with the given ID does not exist");

        _user = await this.repository.updateUser(_id, user);
        return _user;
    }

    async activateEmail(email: string | null): Promise<Document | null> {
        if(!email || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(<string>email))
            throw new MalformedDataError("The email address is not valid");

        const _email = await this.repository.activateEmail(email);
        return _email;
    }

    async getEmail(_id: string): Promise<Document | null> {
        if(!_id)
            throw new MalformedDataError("The email ID must be specified");
        const _email = await this.repository.getEmail(_id);
        if(!_email)
            throw new ResourceNotFoundError("The email address does not exist");
        return _email;
    }

    async getEmailWithAddress(address: string): Promise<Document | null> {
        if(!address)
            throw new MalformedDataError("The email address must be specified");

        const _email = await this.repository.getEmailWithAddress(address);
        if(!_email)
            throw new ResourceNotFoundError("The email address does not exist");
        return _email;
    }

    async authenticate(email: Document, password: string): Promise<Document | null> {
        const validPassword = await this.repository.verifyPassword(email, password);
        if(!validPassword)
            throw new MalformedDataError("The password is not correct");
        return email;
    }

    async logout(): Promise<Document | null> {
        return null;
    }

    async updateEmailAddress(_id: string, email: string): Promise<Document | null> {
        const _email = await this.repository.updateEmailAddress(_id, email);
        return _email;
    }

}