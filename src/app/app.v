module app

import log
import vweb

struct App {
	vweb.Context
mut:
	logger log.Logger
	status Status
}

enum Status {
	ready
	unavailable
}

pub fn new(logger log.Logger) App {
	return App{logger: logger}
}

['/'; get]
fn (mut a App) serve_root() vweb.Result {
	return a.text('this is the root')
}

['/_live'; get]
fn (mut a App) serve_live() vweb.Result {
	return a.text('alive')
}

['/_ready'; get]
fn (mut a App) serve_ready() vweb.Result {
	if a.status != .ready {
		a.set_status(503, '')
		return a.text('unavailable')
	}

	return a.text('ready')
}
