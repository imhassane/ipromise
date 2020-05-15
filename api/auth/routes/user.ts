import {NextFunction, Request, Response, Router} from "express";
import Context from "express-http-context";

import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import ResourceNotFoundError from "../errors/ResourceNotFoundError";
import NonAuthorizedError from "../errors/NonAuthorizedError";
import TokenService from "../services/TokenService";

import { authRequired, authForbidden } from "../middlewares/authentication";

export default (router: Router, service: Service) => {

    router.get('/user/', authRequired, asyncMiddleware(async (req: Request, res: Response) => {
        return res.status(200).send(Context.get("user"));
    }));

    router.put("/user/update", authRequired, asyncMiddleware(async (req: Request, res: Response) => {
        let user = Context.get("user");
        user = await service.updateUser(user.user._id, req.body);
        return res.status(200).send({data: user});
    }));

    router.post("/user/authenticate", authForbidden, asyncMiddleware(async (req: Request, res: Response) => {
        const {email, password} = req.body;
        const _email = await service.getEmailWithAddress(email);
        if (!_email)
            throw new ResourceNotFoundError("The email address does not exist");

        // @ts-ignore
        if(!_email.isActive)
            throw new NonAuthorizedError("This account has been deactivated, you cannot access it");

        await service.authenticate(_email, password);
        const token = await TokenService.createToken(_email._id, email);
        return res.status(200).send({data: token});
    }));

    router.delete("/user/delete", authRequired, asyncMiddleware(async (req: Request, res: Response) => {
        let user = Context.get("user");
        user = await service.deleteUser(user._id);
        return res.status(200).send({data: user});
    }));

    router.delete("/user/force-delete", authRequired, asyncMiddleware(async (req: Request, res: Response) => {
        const user = Context.get("user");
        await service.forceDeleteUser(user._id);
        return res.status(200).send({data: "Your account has been removed from our database"})
    }));

}