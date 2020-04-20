import {Application, Router} from "express";
import Service from "../types/Service";

import EmailRoutes from "../routes/email";
import PasswordRoutes from "../routes/password";
import UserRoutes from "../routes/user";

const router = Router();

export default (application: Application, service: Service) => {

    EmailRoutes(router, service);
    PasswordRoutes(router, service);
    UserRoutes(router, service);

    application.use("/api/v1/", router);
}