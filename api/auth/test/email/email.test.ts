// @ts-ignore
import Helper from '../helpers/helpers';

const API = "/api/v1/";

const helper = new Helper();

describe('Testing Email endpoints', function () {
    it("Some simple test", async () => {
        const response = await helper.apiServer.get(API);
        expect(response.status).toBe(200);
    })
});