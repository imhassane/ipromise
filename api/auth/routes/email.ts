import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";

export default (router: Router, service: Service) => {
    router.get("/", asyncMiddleware((req: Request, res: Response) => {
        return res.send("hello");
    }));

    router.get("/:_id", asyncMiddleware(async (req: Request, res: Response) => {

    }));

    router.post("/add", asyncMiddleware(async (req: Request, res: Response) => {
        const _data = await service.addUser(req.body)
        return res.status(200).send(_data);
    }));

    router.put("/update/email/:_id", asyncMiddleware(async (req: Request, res: Response) => {

    }));

    router.delete("/delete/email/:_id", asyncMiddleware(async (req: Request, res: Response) => {

    }));
}