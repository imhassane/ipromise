import {Request, Response, Router} from "express";
import Service from "../types/Service";
import asyncMiddleware from "../middlewares/async";
import NonAuthenticatedError from "../errors/NonAuthenticatedError";

export default (router: Router, service: Service) => {
    router.put("/user/password/update", asyncMiddleware(async (req: Request, res: Response) => {
        // @ts-ignore
        let { user } = req.session;
        if(!user)
            throw new NonAuthenticatedError("You are not authenticated");
        const { password } = req.body;
        await service.addPassword(user._id, password);
        return res.status(200).send("The password has been updated successfully");
    }));
}