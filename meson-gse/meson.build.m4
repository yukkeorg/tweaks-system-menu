# -*- meson -*-
# AUTOGENERATED FILE - DO NOT EDIT
# This file has been generated from meson-gse/meson.build.m4 and meson-gse.build

m4_changequote(`{',`}')m4_dnl
m4_changecom({})m4_dnl
m4_define({gse_project},
{# meson-gse - Library for gnome-shell extensions
# Copyright (C) 2019, 2020 Philippe Troin (F-i-f on Github)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# Boilerplate
project('$1',
	version: '$3',
	meson_version: '>= 0.44.0',
	license: 'GPL3' )

gnome = import('gnome')
i18n  = import('i18n')

gse_lib_convenience = files('meson-gse/lib/convenience.js')
gse_lib_logger      = files('meson-gse/lib/logger.js')

gse_gettext_domain  = meson.project_name()
gse_sources	    = files('src/extension.js')
gse_libs	    = []
gse_data	    = []
gse_schemas	    = []
gse_dbus_interfaces = []

gse_run_command_obj = run_command('test', '-f', 'src/prefs.js')
if gse_run_command_obj.returncode() == 0
  gse_sources += files('src/prefs.js')
endif

gse_run_command_obj = run_command('test', '-f', 'src/stylesheet.css')
if gse_run_command_obj.returncode() == 0
  gse_data += files('src/stylesheet.css')
endif

gse_schema_main = 'schemas/org.gnome.shell.extensions.'+ meson.project_name() + '.gschema.xml'
gse_run_command_obj = run_command('test', '-f', gse_schema_main)
if gse_run_command_obj.returncode() == 0
  gse_schemas += files(gse_schema_main)
endif

gse_js60 = find_program('js60', required: false)

# Include extension-specific settings
$4m4_dnl
# End of extension-specific settings

# Boilerplate
gse_run_command_obj = run_command('sh', '-c', 'echo $HOME')
if gse_run_command_obj.returncode() != 0
  error('HOME not found, exit=@0@'.format(gse_run_command_obj.returncode()))
endif
home     = gse_run_command_obj.stdout().strip()

gse_uuid		 = meson.project_name() + '@$2'
gse_target_dir		 = home + '/.local/share/gnome-shell/extensions/' + gse_uuid
gse_target_dir_schemas   = join_paths(gse_target_dir, 'schemas')
gse_target_locale_dir    = join_paths(gse_target_dir, 'locale')
gse_target_dir_dbus_intf = join_paths(gse_target_dir, 'dbus-interfaces')

meson_extra_scripts      = 'meson-gse/meson-scripts'

gse_metadata_conf = configuration_data()
git_rev_cmd = run_command('git', 'describe', '--tags', '--long', '--always')
if git_rev_cmd.returncode() != 0
  warning('git rev-parse exit=@0@'.format(git_rev_cmd.returncode()))
  gse_metadata_conf.set('VCS_TAG', 'unknown')
else
  gse_metadata_conf.set('VCS_TAG', git_rev_cmd.stdout().strip())
endif
gse_metadata_conf.set('uuid', gse_uuid)
gse_metadata_conf.set('version', meson.project_version())
gse_metadata_conf.set('gettext_domain', gse_gettext_domain)

gse_data += configure_file(input:         'src/metadata.json.in',
				 output:        'metadata.json',
				 configuration: gse_metadata_conf)

# This should work but doesn't:
#gse_metadata = vcs_tag(command:  ['git', 'rev-parse', 'HEAD'],
#			     input:    files('metadata.json.in'),
#			     output:   'metadata.json',
#			     fallback: 'unknown')
#gse_data += gse_metadata

if gse_schemas != []
  custom_target('gse-gschemas.compiled',
		build_by_default: true,
		command:          ['sh', '-c', 'glib-compile-schemas --targetdir . $(dirname @INPUT0@)'],
		input:            gse_schemas,
		output:           'gschemas.compiled',
		install:          true,
		install_dir:      gse_target_dir_schemas)
  install_data(gse_schemas,
	       install_dir: gse_target_dir_schemas)
endif

if (gse_js60.found())
  foreach gse_source : gse_sources
    test('Checking syntax of ' + '@0@'.format(gse_source),
	 gse_js60,
	 args: ['-s', '-c', gse_source])
  endforeach
endif

install_data(gse_sources + gse_data + gse_libs,
	     install_dir: gse_target_dir)

install_data(gse_dbus_interfaces,
	     install_dir: gse_target_dir_dbus_intf)

custom_target('gse-extension.zip',
	      build_by_default: false,
	      install: false,
	      command: [files(join_paths(meson_extra_scripts, 'make-extension')), gse_target_dir, '@OUTDIR@', '@OUTPUT@'],
	      output:  'extension.zip')

gse_run_command_obj = run_command('test', '-d', 'po')
if gse_run_command_obj.returncode() == 0
  subdir('po')
endif})m4_dnl
