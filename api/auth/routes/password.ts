import {Request, Response, Router} from "express";
import Context from "express-http-context";

import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import { authRequired } from "../middlewares/authentication";

export default (router: Router, service: Service) => {
    router.put("/user/password/update", authRequired, asyncMiddleware(async (req: Request, res: Response) => {
        const user = Context.get("user");
        const { password } = req.body;
        await service.addPassword(user._id, password);
        return res.status(200).send("The password has been updated successfully");
    }));
}