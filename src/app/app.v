module app

import net.http
import log
import os
import time

[heap]
struct App {
mut:
	logger log.Log
	status Status
	server http.Server
}

enum Status {
	ready
	unavailable
}

pub fn new(port int, level log.Level) App {
	mut a := App{}

	a.logger.set_level(level)

	a.server = http.Server{
		port: port
		handler: a
	}

	return a
}

fn (mut a App) handle(req http.Request) http.Response {
	a.logger.debug('got request for ${req.url}')

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

pub fn (mut a App) listen_and_serve() {
	a.server.listen_and_serve()
}

pub fn (mut a App) stop_on_signal(_ os.Signal) {
	a.status = .unavailable
	time.sleep(30 * time.second)
	a.server.stop()
}