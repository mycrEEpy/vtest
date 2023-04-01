module app

import net.http

pub struct App {
mut:
	status Status
}

enum Status {
	ready
	unavailable
}

fn (a App) handle(req http.Request) http.Response {
	println('got request for ${req.url}')

	return match req.url {
		'/' {
			match req.method {
				.get {
					http.new_response(status: .ok, body: 'this is the root')
				}
				else {
					http.new_response(status: .method_not_allowed)
				}
			}

		}
		'/_ready' {
			match req.method {
				.get {
					match a.status {
						.ready { http.new_response(status: .ok, body: 'ready') }
						.unavailable { http.new_response(status: .service_unavailable, body: 'unavailable') }
					}
				}
				else {
					http.new_response(status: .method_not_allowed)
				}
			}
		}
		'/_live' {
			match req.method {
				.get {
					http.new_response(status: .ok, body: 'alive')
				}
				else {
					http.new_response(status: .method_not_allowed)
				}
			}
		}
		else {
			http.new_response(status: .not_found, body: 'not found')
		}
	}
}
