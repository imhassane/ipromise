import {NextFunction, Request, Response} from "express";

// @ts-ignore
function asyncMiddleware(fn){
    return (req: Request, res: Response, next: NextFunction) =>
        Promise
            .resolve(fn(req, res, next))
            .catch(next);
}

export default asyncMiddleware;
