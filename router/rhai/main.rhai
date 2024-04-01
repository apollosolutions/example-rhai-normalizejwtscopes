import "normalize_scopes" as normalize_scopes;

fn process_request(request) {
    normalize_scopes::process_request(request)
}

fn supergraph_service(service) {
  // Rhai convention for creating a function pointer
  const request_callback = Fn("process_request"); 
  
  service.map_request(request_callback);
}