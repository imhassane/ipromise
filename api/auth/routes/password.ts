import {Request, Response, Router} from "express";
import Service from "../types/Service";

export default (router: Router, service: Service) => {
    router.get("/password/test", async (req: Request, res: Response) => {
        return res.send("password");
    })
}