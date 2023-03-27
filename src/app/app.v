module app

import net.http

pub struct App {
pub mut:
	status Status
}

pub fn (mut a App) set_status(status Status) {
	a.status = status
}

pub enum Status {
	ready
	unavailable
}

pub fn (a App) handle(req http.Request) http.Response {
	println('got request for ${req.url}')

	return match req.url {
		'/' {
			http.new_response(status: .ok, body: 'this is the root')
		}
		'/_ready' {
			match a.status {
				.ready { http.new_response(status: .ok, body: 'ready') }
				.unavailable { http.new_response(status: .service_unavailable, body: 'unavailable') }
			}
		}
		'/_live' {
			http.new_response(status: .ok, body: 'alive')
		}
		else {
			http.new_response(status: .not_found, body: 'not found')
		}
	}
}
