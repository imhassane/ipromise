import Express from "express";
import BodyParser from "body-parser";
import ExpressSession from "express-session";
import ExpressContext from "express-http-context";

import routes from "./startup/routes";
import MongoRepository from "./repos/MongoRepository";
import MongoService from "./services/MongoService";
import authMiddleware from "./middlewares/authentication";

const sessionCookieConfig = {
    secret: process.env.SESSION_SECRET || 'secret',
    resave: false,
    saveUninitialized: true,
    cookie: {
        maxAge: 60 * 60 * 24 * 2
    }
};

const application = Express();

if(application.get('env') === 'production') {
    application.set('trust proxy', 1);
    // @ts-ignore
    sessionCookieConfig.cookie.secure = true;
}

application.use(ExpressSession(sessionCookieConfig));
application.use(BodyParser.json());
application.use(ExpressContext.middleware);
application.use(authMiddleware);

const repository = new MongoRepository();
repository.connect().then(() => {
    console.log("Succesfully connected to the database");
}).catch(_ => {
    console.log("Unable to connected to the database");
});

const service = new MongoService(repository);
routes(application, service);

export default application;