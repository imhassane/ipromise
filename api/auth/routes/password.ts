import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";

export default (router: Router, service: Service) => {
    router.get("/password/test", asyncMiddleware( (req: Request, res: Response) => {
        return res.send("password");
    }));
}