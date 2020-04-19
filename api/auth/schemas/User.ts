import {model, Schema, SchemaTypes} from "mongoose";

const UserSchema = new Schema({
    firstName: String,
    lastName: String,
    hasPassword: { type: Boolean, default: false },
    isActive: { type: Boolean, default: false }
}, { timestamps: true });

const User = model("User", UserSchema);

export default User;

