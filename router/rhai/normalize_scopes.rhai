/*
In this function, we get an array of scopes via the "authorizations" claim in the JWT. 

E.g.
{
    authorizations: ["read:hello", "read:otherthing"]
}

This function takes the authorizations and converts them to a space separated string and stores it in the "scope" claim within the Apollo Router context. 

E.g. "read:hello read:otherthing"
*/
fn process_request(request) {
    let claims = request.context[Router.APOLLO_AUTHENTICATION_JWT_CLAIMS];
    let authorizations = claims["authorizations"];
    let scope = "";

    if authorizations.len() > 0 {
        for i in 0..authorizations.len() {
            scope += ' ';
            scope += authorizations[i];
        }
    }

    claims["scope"] = scope;
    request.context["apollo_authentication::JWT::claims"] = claims;
}