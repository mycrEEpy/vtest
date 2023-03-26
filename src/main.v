module main

import net.http
import flag
import os
import time
import app

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application('vtest')

	port := fp.int('port', 0, 8000, 'listen port')
	help := fp.bool('help', 0, false, 'print help')

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
