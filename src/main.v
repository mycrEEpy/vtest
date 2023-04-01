module main

import net.http
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

	mut a := app.new(parsed_level)

	mut s := http.Server{
		port: port
		handler: a
	}

	s.listen_and_serve()
}
