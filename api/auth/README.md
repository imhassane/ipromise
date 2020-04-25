## User API
This microservice is designed to handle all the requests concerning user's operations.
<br />
I'm using some architecture to facilitate future modifications.<br />

##### Organisation
- <strong>errors</strong>: contains all the errors we are handling in the api.
- <strong>middlewares</strong>: contains the middlewares.
- <strong>services</strong>: contains all the logic of the api.
- <strong>schemas</strong>: contains all the schemas used for mongo.
- <strong>repos</strong>: represents the interactions with the databases.
- <strong>types</strong>: contains the interfaces of the api.

##### TODOs

 - [x] Adding a new user.
 - [x] Updating an user.
 - [ ] Updating user's password.
 - [ ] Updating user's email address.
 - [ ] Deleting some user's data.
 - [ ] Authentication with user's credentials.
 
##### How does the API work ?
An user is represented by the <strong>User</strong> model defined by this schema.
```javascript
    const UserSchema = new Mongoose.Schema({
        firstName: String,
        lastName: String,
        isActive: { type: Mongoose.SchemaTypes.Boolean, default: true }       
    }, { timestamps: true });
```
As you can see, the password and the email address are separated from the User's schema for security reasons and I find
less complicated for updates.<br />
When creating an account, we just create an email address. Before saving the
address we create an empty user account which we bind to the email address and the save it
to the database. <br />
The passwords are also stored separately and they have a reference to the user's document in the database. When updating the
password we just add a new password and set it active. All stored password for the user are set to inactive and not really
deleted from the database.

##### Tools I am using.

- Password encryption: Bcrypt-js.
- JSON for parsing documents and requests.
- Session instead of tokens for authentication.
