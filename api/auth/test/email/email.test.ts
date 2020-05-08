import fetch from "node-fetch";

const API = "http://localhost:5000/api/v1";
const user = {
    email: "test@test.com",
    password: "testtest"
};

const new_user_post = {
    method: "POST",
    body: JSON.stringify(user),
    headers: { "Content-Type": "application/json" }
};

const update_user_put = (token: string, data: any) => ({
    method: "PUT",
    body: JSON.stringify({...user, ...data}),
    headers: { "Content-Type": "application/json", "authentication-token": token }
});

jest.setTimeout(3000);

describe('Testing Email endpoints', function () {
    it("Creating a new user", async () => {
        const res = await fetch(`${API}/email/add`, new_user_post);
        // TODO: 200
        return expect(res.status).toBe(400);
    });

    it("Authentication", async () => {
        const res = await fetch(`${API}/user/authenticate`, new_user_post);
        return expect(res.status).toBe(200);
    });

    it("Updating the user", async () => {
        let res = await fetch(`${API}/user/authenticate`, new_user_post);
        const {data} = await res.json();

        res = await fetch(`${API}/user/update`, update_user_put(data, { firstName: "test1" }));
        return expect(res.status).toBe(200);
    })
});