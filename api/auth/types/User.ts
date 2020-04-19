interface Password {
    _id: string,
    user: User,
    hash: string,
    isActive: string,
    createdAt: Date,
    updatedAt: Date
}

interface Email {
    _id: string,
    address: string,
    createdAt: Date,
    updatedAt: Date
}

export interface UserParams {
    firstName?: string,
    lastName?: string,
    email: string
}

export interface User {
    _id: string,
    firstName: string,
    lastName: string,
    email: Email,
    hasPassword: boolean,
    isActive: boolean,
    createdAt: Date,
    updatedAt: Date
}