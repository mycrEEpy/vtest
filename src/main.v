module main

import flag
import os
import app
import log
import vweb

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('vtest')

	addr := fp.string('listen-addr', `a`, '', 'listen address')
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

	mut logger := log.Log{}
	logger.set_level(parsed_level)

	logger.info('listening on ${addr}:${port}')

	vweb.run_at(app.new(logger), vweb.RunParams{
		host: addr
		port: port
		family: .ip
		show_startup_message: false
	}) or {
		eprintln('webserver failed: ${err}')
		exit(1)
	}
}
