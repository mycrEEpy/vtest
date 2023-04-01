module main

import flag
import os
import app
import log

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('vtest')

	port := fp.int('listen-port', `p`, 8000, 'listen port')
	help := fp.bool('help', `h`, false, 'print help')
	level := fp.string('log-level', `l`, 'INFO', 'log level')

	fp.finalize() or {
		eprintln(err)
		exit(1)
	}

	if help {
		println(fp.usage())
		exit(0)
	}

	parsed_level := log.level_from_tag(level) or {
		eprintln('invalid log level: ${level}')
		exit(1)
	}

	mut a := app.new(port, parsed_level)

	os.signal_opt(.int, a.stop_on_signal)!
	os.signal_opt(.term, a.stop_on_signal)!

	a.listen_and_serve()
}
