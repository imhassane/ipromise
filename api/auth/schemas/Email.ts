import {model, Schema, SchemaTypes} from "mongoose";

const EmailSchema = new Schema({
    email: {
        type: String,
        required: true,
        validate: {
            validator(value: string) {
                return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(value);
            }
        }
    },
    user: {
        type: SchemaTypes.ObjectId,
        ref: "User"
    },
    isActive: { type: Boolean, default: true },
}, { timestamps: true });

EmailSchema.pre('save', function() {
    // If it's the first time saving the email address.
    // We create a new user.
    // TODO: Créer un nouvel utilisateur si c'est la première qu'on ajoute l'email.
});

const Email = model("Email", EmailSchema);

export default Email;
