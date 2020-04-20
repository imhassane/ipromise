interface Password {
    _id: string,
    user: UserType,
    hash: string,
    isActive: string,
    createdAt: Date,
    updatedAt: Date
}

export interface EmailType {
    _id: string,
    address: string,
    createdAt: Date,
    updatedAt: Date
}

export interface UserParams {
    firstName?: string,
    lastName?: string,
    email?: string,
    password?: string
}

export interface UserType {
    _id: string,
    firstName: string,
    lastName: string,
    email: EmailType,
    hasPassword: boolean,
    isActive: boolean,
    createdAt: Date,
    updatedAt: Date
}