# JWT Authentication/Authorization with a Rhai script to normalize non-standard authorizations

This repository demonstrates how to use JWT authentication in the Router with the `@requiresScopes` directive when the JWT does not use the standard `scope` JWT claim. In this example, it is instead stored as an array of strings on the `authorizations` property of the JWT. The Rhai script in this repo converts it to the format expected by the Router.

## Running the Example

> Note: To run this example, you will need a GraphOS Enterprise plan and must create `/router/.env` based on `/router/.env.example` which exports `APOLLO_KEY` and `APOLLO_GRAPH_REF`.

1. Run the subgraph from the `/subgraph` directory with `npm run dev`
1. Run the auth-service from the `/auth-service` directory with `npm run dev`
1. In the `/router` directory, download the router by running `./download_router.sh`
1. In the `/router` directory, compose the schema by running `./create_local_schema.sh`
1. In the `/router` directory, run the router by running `./start_router.sh`

Before you can query the router from the browser (http://127.0.0.1:4000/), you will need to get a JWT. This can be done by opening http://localhost:3005/login in the browser and using the resulting `token` as a `Bearer` token in the `Authorization` header.

## Code Highlights

### Router Configuration

In `router/router-config.yaml`:

- `authorization` directives are enabled
- `require_authentication` is set to `true` which enforces every request must contain a valid JWT
- A `jwks` url is configured to validate incoming JWTs
- The `rhai` property is configured to point to the `rhai/main.rhai` file

In `subgraph/src/schema/Query.graphql`, the `@requiresScopes` is set on fields to require specific scopes. If you query for `hello` you will get a result whereas `hello2` will result n an error due to the JWT not containing that scope.

In `router/rhai/normalize_scopes.rhai`, the script takes the `authorizations` property as an array of strings (E.g. `["read:hello", "read:otherthing"]`) and converts it to a space-separated string `scope` property (E.g. `"read:hello read:otherthing"`).
