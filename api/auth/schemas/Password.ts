import {model, Schema, SchemaTypes} from "mongoose";

const PasswordSchema = new Schema({
    hash: String,
    email: {
        type: SchemaTypes.ObjectId,
        ref: "Email"
    },
    isActive: { type: Boolean, default: true }
}, { timestamps: true });

PasswordSchema.pre('save', function() {
    // Before saving we make sure to set all other password for the current user
    // as non active.
    // TODO: Rendre tous les mots de passe inactifs.
});

const Password = model("Password", PasswordSchema);

export default Password;
