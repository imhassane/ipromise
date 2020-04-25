import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import ResourceNotFoundError from "../errors/ResourceNotFoundError";

export default (router: Router, service: Service) => {

    router.get('/user/', asyncMiddleware(async (req: Request, res: Response) => {
        // @ts-ignore
        const { user } = req.session;
        if(!user)
            return res.status(401).send("You are not authenticated");

        return res.status(200).send(user);
    }));

    router.put("/user/update", asyncMiddleware(async (req: Request, res: Response) => {
        // @ts-ignore
        let { user } = req.session;
        if(!user)
            return res.status(401).send("You are not authenticated");

        user = await service.updateUser(user.user._id, req.body);
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