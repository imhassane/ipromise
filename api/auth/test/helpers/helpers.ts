import SuperTest from "supertest";
import Application from "../../app";

class Helper {
    public apiServer: any;

    constructor(model: any) {
        this.apiServer = SuperTest(Application);
    }
}

module.exports = Helper;