module main

import net.http
import flag
import os
import time
import app

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('vtest')

	port := fp.int('port', `p`, 8000, 'listen port')
	help := fp.bool('help', `h`, false, 'print help')

	fp.finalize() or {
		eprintln(err)
		exit(1)
	}

	if help {
		println(fp.usage())
		exit(0)
	}

	mut a := app.App{}

	mut s := http.Server{
		port: port
		handler: a
	}

	spawn fn (mut a app.App) {
		time.sleep(time.second * 5)
		a.set_status(.dead)
	}(mut &a)

	s.listen_and_serve()
}
