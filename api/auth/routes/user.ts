import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";

export default (router: Router, service: Service) => {

    router.get('/user/:_id', asyncMiddleware(async (req: Request, res: Response) => {
        const user = await service.getUserWithID(req.params._id);
        return res.status(200).send(user);
    }));

    router.put("/user/:_id", asyncMiddleware(async (req: Request, res: Response) => {
        const user = await service.updateUser(req.params._id, req.body);
        return res.status(200).send(user);
    }));

}