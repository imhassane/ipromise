#### CURRENT API ARCHITECTURE

I'm trying to use microservices instead of a monolithic architecture. I don't fully
understand it but I've separated my services into two directories for now.<br />

##### Auth service
As it names suggests, this service will handle the authentication part of my application.
It's written in Typescript and running on node js. It basically authenticates the user and
then its role is to send user's information given his id.

##### Promises service
This one will be in charge for handling the promises, their frequencies and the targets for a 
specific user. It is based on <strong>Elixir / Cowboy / Plug</strong>.

### Future ideas
1. I want to split the promise service into three services. The `promise service`, `frequency service` and
`target service`. Each service will handle its operations and won't depend on the two others.

2. Using a message queue to connect the three services or another implementation
3. Moving from MongoDB to Postgres (Not so sure but Imma keep it here)