import os
import sublime
import sys

st2 = (sys.version_info[0] == 2)
dist_dir = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, dist_dir)

ANN = ''
VERSION = ''
MARGO_EXE = ''
fn = os.path.join(dist_dir, 'gosubl', 'about.py')
try:
	with open(fn) as f:
		code = compile(f.read(), fn, 'exec')
		exec(code)
except Exception:
	pass

def plugin_loaded():
	from gosubl import about
	from gosubl import sh
	from gosubl import ev
	from gosubl import gs
	from gosubl import mg9

	mods = [
		('gs', gs),
		('sh', sh),
		('mg9', mg9),
	]

	gs.set_attr('about.version', VERSION)
	gs.set_attr('about.ann', ANN)

	for mod_name, mod in mods:
		print('GoSublime %s: init mod(%s)' % (VERSION, mod_name))

		try:
			mod.gs_init({
				'version': VERSION,
				'ann': ANN,
				'margo_exe': MARGO_EXE,
			})
		except TypeError:
			# old versions didn't take an arg
			mod.gs_init()

	ev.init.post_add = lambda e, f: f()
	ev.init()

	def cb():
		aso = gs.aso()
		old_version = aso.get('version', '')
		old_ann = aso.get('ann', '')
		if about.VERSION > old_version or about.ANN > old_ann:
			aso.set('version', about.VERSION)
			aso.set('ann', about.ANN)
			gs.save_aso()
			gs.focus(gs.dist_path('CHANGELOG.md'))

	sublime.set_timeout(cb, 0)


if st2:
	sublime.set_timeout(plugin_loaded, 0)
