import Application from "./app";

const { DEV_PORT = 5000 } = process.env;
Application.listen(DEV_PORT, () => {
    console.log("Server running succesfully");
});
