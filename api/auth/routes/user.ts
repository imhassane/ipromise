import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import ResourceNotFoundError from "../errors/ResourceNotFoundError";

export default (router: Router, service: Service) => {

    router.get('/user/:_id', asyncMiddleware(async (req: Request, res: Response) => {
        const user = await service.getUserWithID(req.params._id);
        return res.status(200).send(user);
    }));

    router.put("/user/:_id", asyncMiddleware(async (req: Request, res: Response) => {
        const user = await service.updateUser(req.params._id, req.body);
        return res.status(200).send(user);
    }));

    router.post("/user/authenticate", asyncMiddleware(async (req: Request, res: Response) => {
        // @ts-ignore
        let { user } = req.session;
        if(user) {
            return res.status(200).send(user);
        } else {
            const {email, password} = req.body;
            const _email = await service.getEmailWithAddress(email);
            if (!_email)
                throw new ResourceNotFoundError("The email address does not exist");
            user = await service.authenticate(_email, password);

            // @ts-ignore
            req.session.user = _email;
            return res.status(200).send(user);
        }
    }));

}