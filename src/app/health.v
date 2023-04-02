module app

import vweb

enum Status {
	ready
	unavailable
}

struct HealthResponse {
	msg string
}

['/_live'; get]
fn (mut a App) serve_live() vweb.Result {
	return a.json(HealthResponse{msg: 'alive'})
}

['/_ready'; get]
fn (mut a App) serve_ready() vweb.Result {
	if a.status != .ready {
		a.set_status(503, '')
		return a.json(HealthResponse{msg: 'unavailable'})
	}

	return a.json(HealthResponse{msg: 'ready'})
}
