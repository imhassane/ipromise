import {model, Schema, SchemaTypes} from "mongoose";
import Bcrypt from "bcryptjs";
import User from "./User";

const PasswordSchema = new Schema({
    hash: String,
    email: {
        type: SchemaTypes.ObjectId,
        ref: "Email"
    },
    isActive: { type: Boolean, default: true }
}, { timestamps: true });

PasswordSchema.methods.verifyPassword = function(pass: string): boolean {
    return Bcrypt.compareSync(pass, this.hash);
}

PasswordSchema.pre('save', async function() {
    // Before saving we make sure to set all other password for the current user
    // as non active.
    const salt = await Bcrypt.genSalt(10);
    // @ts-ignore
    this.hash = await Bcrypt.hash(this.hash, salt);

    // Updating all the passwords for the current user.
    // @ts-ignore
    await Password.updateMany({ email: this.email }, { $set: { isActive: false }});
});

PasswordSchema.post('save', async function() {
    // Setting the user's hasPassword to true.
    // @ts-ignore
    await User.findOneAndUpdate({ _id: this.email.user._id }, { $set: { hasPassword: true }});
});

const Password = model("Password", PasswordSchema);

export default Password;
