import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";

export default (router: Router, service: Service) => {

    router.get("/email/:_id", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.getEmail(req.params._id);
        return res.status(200).send(_data);
    }));

    router.post("/email/add", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.addUser(req.body)
        return res.status(200).send(_data);
    }));
}