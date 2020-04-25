import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import NonAuthenticatedError from "../errors/NonAuthenticatedError";

export default (router: Router, service: Service) => {

    router.get("/email/:_id", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.getEmail(req.params._id);
        return res.status(200).send(_data);
    }));

    router.post("/email/add", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.addUser(req.body)
        return res.status(200).send(_data);
    }));

    router.put("/email/update", asyncMiddleware(async (req: Request, res: Response) => {
        // @ts-ignore
        let { user } = req.session;
        if(!user)
            throw new NonAuthenticatedError("You are not authenticated");

        const _email = await service.updateEmailAddress(user._id, req.body.email);

        // @ts-ignore
        req.session.user.email = _email.email;

        return res.status(200).send("The email address has been updated successfully");
    }));
}