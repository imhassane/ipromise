import Express from "express";

const application = Express();

const { PORT = 5000 } = process.env;

application.listen(PORT, () => {
    console.log("Server running succesfully");
});
