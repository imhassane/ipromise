import {Request, Response, Router} from "express";
import Context from "express-http-context";

import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import { authRequired, authForbidden } from "../middlewares/authentication";

export default (router: Router, service: Service) => {

    router.get("/email/:_id", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.getEmail(req.params._id);
        return res.status(200).send({data: _data});
    }));

    router.post("/email/add", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.addUser(req.body)
        return res.status(200).send({data: _data});
    }));

    router.put("/email/update", authRequired, asyncMiddleware(async (req: Request, res: Response) => {
        const user = Context.get("user");
        const _email = await service.updateEmailAddress(user._id, req.body.email);
        // @ts-ignore
        req.session.user.email = _email.email;

        return res.status(200).send({data: "The email address has been updated successfully"});
    }));

    router.put("/email/active", authForbidden, asyncMiddleware(async (req: Request, res: Response) => {
        const email = req.body.email || "";
        await service.activateEmail(<string> email);
        return res.status(200).send({data: "Your account has been activated successfully"});
    }));
}