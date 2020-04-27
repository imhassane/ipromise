## Promises AI

**TODO: API in charge of handling the promises**

#### Current user story
- [ ] An user can create a promise
- [ ] When an user logs in, all the targets are regenerated
- [ ] An user can update and delete a promise
- [ ] An user can update his targets
- [ ] An user can only updated the targets that are not ahead of the current time
- [ ] An user can get the list of all public promises
- [ ] An user can support a promise by giving it claps
- [ ] An user can comment a public promise to show support

##### current models
A `promise` is composed by a frequency which is itself composed of targets. A json representation of  someone's promise
to hit the gym three times a week would look like this one below:

```json
{
  "promise": {
    "_id": "ObjectId(eif3...)",
    "title": "Going to the gym",
    "user": "ObjectId(ab2c...)",
    "is_public": true,
    "claps": 200,
    "comments": [],
    "created_at": "",
    "updated_at": "",
    "frequency": {
      "_id": "ObjectId(2el...)",
      "type": "weekly",
      "repeat": 3,
      "created_at": "",
      "updated_at": "",
      "targets": [
        {"_id": "ObjectId(a3e...)", "day": 1, "done":  false},
        {"_id": "ObjectId(bce...)", "day": 3, "done":  true},
        {"_id": "ObjectId(1ae...)", "day": 5, "done":  false}
      ]
    }
  }
}
```
###### current thoughts
So when an user comes in, the application launches a service that will generate all his `targets` for
the current week and will set them all to false initially. <br />
The user will then be able to update the `targets` that he has achieved and those that are ahead of the current
time won't be mutable. <br/>

Before each request, we'll have to verify if the user is authenticated by sending a token to the authentication api.

###### Future options
I'd like to use GraphQL for performances but I'll keep it in my mind.