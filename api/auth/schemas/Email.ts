import {model, Schema, SchemaTypes} from "mongoose";
import User from "./User";

const EmailSchema = new Schema({
    email: {
        type: String,
        required: true,
        validate: {
            validator(value: string) {
                return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(value);
            }
        },
        unique: true
    },
    user: {
        type: SchemaTypes.ObjectId,
        ref: "User"
    },
    isActive: { type: Boolean, default: true },
}, { timestamps: true });

EmailSchema.pre('save', async function() {
    // If it's the first time saving the email address.
    // We create a new user.
    if(this.isNew) {
        let user = new User();
        user = await user.save();

        // @ts-ignore
        this.user = user;
    }
});

const Email = model("Email", EmailSchema);

export default Email;
