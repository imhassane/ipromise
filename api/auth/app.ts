import Express from "express";
import routes from "./startup/routes";
import MongoRepository from "./repos/MongoRepository";
import MongoService from "./services/MongoService";

const application = Express();

const repository = new MongoRepository();
repository.connect().then(() => {
    console.log("Succesfully connected to the database");
}).catch(_ => {
    console.log("Unable to connected to the database");
});

const service = new MongoService(repository);
routes(application, service);

export default application;