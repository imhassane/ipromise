import jwt from "jsonwebtoken";

export default class TokenService {

    static SECRET = process.env.JWT_SECRET || "secret";

    static createToken(id: string, email: string) {
        return jwt.sign({ id, email }, TokenService.SECRET, { expiresIn: '2h' });
    }

    static async decodeToken(token: string) {
        return await jwt.verify(token, TokenService.SECRET);
    }
}