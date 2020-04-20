import {NextFunction, Request, Response} from "express";
import MalformedDataError from "../errors/MalformedDataError";
import NonAuthorizedError from "../errors/NonAuthorizedError";
import ResourceNotFoundError from "../errors/ResourceNotFoundError";
import ResourceAlreadyExistsError from "../errors/ResourceAlreadyExistsError";

// @ts-ignore
function asyncMiddleware(fn){
    return (req: Request, res: Response, next: NextFunction) =>
        Promise
            .resolve(fn(req, res, next))
            .catch(ex => {
                let code;
                if(ex instanceof MalformedDataError)
                    code = 400;
                else if(ex instanceof NonAuthorizedError)
                    code = 401;
                else if(ex instanceof ResourceNotFoundError)
                    code = 404;
                else if(ex instanceof ResourceAlreadyExistsError)
                    code = 400;
                else
                    code = 500;
                return res.status(code).send(ex.message);
                next();
            });
}

export default asyncMiddleware;
