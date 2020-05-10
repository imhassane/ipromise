import { Request, Response, NextFunction } from "express";
import ExpressContext from "express-http-context";
import Email from "../schemas/Email";
import TokenService from "../services/TokenService";

export function authForbidden(req: Request, res: Response, next: NextFunction) {
    if(ExpressContext.get("user"))
    return res.status(401).send({message: "You are already authenticated"});

    return next();
}

export function authRequired(req: Request, res: Response, next: NextFunction) {
    const user = ExpressContext.get("user");
    if(!user) return res.status(401).send({message: "You are not authenticated"});

    return next();
}

async function authMiddleware(req: Request, res: Response, next: NextFunction) {
    try {
        const { headers } = req;

        const token = <string> headers["authentication-token"];
        if(!token || !token.length) {
            ExpressContext.set("user", null);
        } else {
            const decoded: { id?: string } = <object> await TokenService.decodeToken(token);

            if(decoded) {
                const user = await Email.findOne({ _id: decoded.id }).populate("users");
                ExpressContext.set("user", user);
            }
        }

        next();

    } catch(ex) {
        // TODO: log the errors
        console.log(ex.message)
        return res.status(400).send("You need to log in again");
    }
}

export default authMiddleware;
