import fetch from "node-fetch";
import { authForbidden } from "../../middlewares/authentication";

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

const authenticate = async () => {
    const res = await fetch(`${API}/user/authenticate`, new_user_post);
    const {data} = await res.json();
    return {res, token: data};
}

jest.setTimeout(3000);

test("Creating a new user", async () => {
    const res = await fetch(`${API}/email/add`, new_user_post);
    
    // if the user already exists, it will return 400.
    const result = [400, 200].includes(res.status) ? res.status : 500;
    return expect(res.status).toBe(result);
});

test("Authentication", async () => {
    const res = await fetch(`${API}/user/authenticate`, new_user_post);
    return expect(res.status).toBe(200);
});

test("Updating the user", async () => {
    const {token} = await authenticate();
    expect(token).not.toBeNull();

    const res = await fetch(`${API}/user/update`, update_user_put(token, { firstName: "test1" }));
    return expect(res.status).toBe(200);
});

test("Deleting the user", async () => {
    const {token} = await authenticate();
    expect(token).not.toBeNull();

    const res = await fetch(`${API}/user/delete`,
                    {
                        method: "delete",
                        headers: {
                            "authentication-token": token
                        }
                    });
    const {data} = await res.json();
    return expect(data.isActive).toBe(false);
});

test("Reactivation of email", async () => {
    let {res} = await authenticate();
    expect(res.status).toBe(403);

    const params = {
        method: "PUT",
        body: JSON.stringify({email: "test@test.com"}),
        headers: { "Content-Type": "application/json"}
    };
    res = await fetch(`${API}/email/active`, params);
    return expect(res.status).toBe(200);
});

test("Forcing the deleting", async () => {
    const {token} = await authenticate();
    expect(token).not.toBeNull();

    const res = await fetch(`${API}/user/force-delete`, {
        method: "delete",
            headers: {"authentication-token": token}
        });
    return expect(res.status).toBe(200);
});

test("Forcing the deleting of non exitant user", async () => {
    const {res} = await authenticate();
    return expect(res.status).toBe(404);
});