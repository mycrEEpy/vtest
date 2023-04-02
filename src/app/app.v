module app

import log
import vweb

struct App {
	vweb.Context
mut:
	logger log.Logger
	status Status
}

pub fn new(logger log.Logger) App {
	return App{logger: logger}
}

['/'; get]
fn (mut a App) serve_root() vweb.Result {
	return a.text('this is the root')
}


