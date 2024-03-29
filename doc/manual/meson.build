version_xml = custom_target('generate version.xml',
                            output: 'version.xml',
                            capture: true,
                            command: [
                              'echo', '-n', meson.project_version()
                            ])

userdir_xml = custom_target('generate userdir.xml',
                            output: 'userdir.xml',
                            capture: true,
                            command: [
                              'echo', '-n', p11_user_config
                            ])

sysdir_xml = custom_target('generate sysdir.xml',
                           output: 'sysdir.xml',
                           capture: true,
                           command: [
                             'echo', '-n', p11_system_config
                           ])

xml_deps = [version_xml, userdir_xml, sysdir_xml]

if get_option('gtk_doc')
  ignore_headers = [
    'private.h',
    'pkcs11.h',
    'conf.h',
    'debug.h',
    'dict.h',
    'filter.h',
    'log.h',
    'mock.h',
    'modules.h',
    'pkcs11.h',
    'pkcs11i.h',
    'pkcs11x.h',
    'private.h',
    'client.h',
    'proxy.h',
    'rpc.h',
    'rpc-message.h',
    'util.h',
    'virtual.h',
    'virtual-fixed.h',
    'array.h',
    'compat.h'
  ]

  content_files = [
    'p11-kit-config.xml',
    'p11-kit-sharing.xml',
    'p11-kit-devel.xml',
    'p11-kit-proxy.xml',
    'p11-kit-trust.xml',
    'p11-kit-remoting.xml',
    'p11-kit.xml',
    'pkcs11.conf.xml',
    'trust.xml',
    'annotation-glossary.xml'
  ]

  glib_prefix = get_option('glib_prefix')
  if glib_prefix == ''
    glib_prefix = dependency('glib-2.0').get_variable(pkgconfig : 'prefix')
  endif
  fixxref_args = [
    '--html-dir=' + (prefix / gnome.gtkdoc_html_dir(meson.project_name())),
    '--extra-dir=' + (glib_prefix / gnome.gtkdoc_html_dir('glib')),
  ]

  gnome.gtkdoc('p11-kit',
              main_xml: 'p11-kit-docs.xml',
              namespace: 'p11_kit',
              src_dir: 'p11-kit',
              dependencies: libffi_deps + dlopen_deps,
              scan_args: [
                '--ignore-headers=' + ' '.join(ignore_headers),
                '--rebuild-types',
                '--deprecated-guards="P11_KIT_DISABLE_DEPRECATED"'
              ],
              scanobjs_args: [
                '--version'
              ],
              content_files: content_files,
              fixxref_args: fixxref_args,
              install: true)
endif

if get_option('man')
  xsltproc = find_program('xsltproc')
  xsltproc_xsl = 'http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl'
  if run_command([xsltproc, '--nonet', xsltproc_xsl]).returncode() != 0
    error('Docbook stylesheet for manpages is missing')
  endif

  xsltproc_flags = [
    '--nonet',
    '--stringparam', 'man.output.quietly', '1',
    '--stringparam', 'funcsynopsis.style', 'ansi',
    '--stringparam', 'man.th.extra1.suppress', '1',
    '--stringparam', 'man.authors.section.enabled', '0',
    '--stringparam', 'man.copyright.section.enabled', '0',
    '--path', meson.current_build_dir(),
  ]

  man_pages = {
    '1': ['trust'],
    '5': ['pkcs11.conf'],
    '8': ['p11-kit'],
  }

  foreach section, pages: man_pages
    foreach page: pages
      man_src = '@0@.xml'.format(page)
      man_dst = '@0@.@1@'.format(page, section)
      man_section = 'man@0@'.format(section)
      custom_target(man_dst,
                    command: [
                      xsltproc,
                      xsltproc_flags,
                      '-o', '@OUTPUT@',
                      xsltproc_xsl,
                      '@INPUT@',
                    ],
                    input: man_src,
                    output: man_dst,
                    depends: xml_deps,
                    install: true,
                    install_dir: join_paths(mandir, man_section),
                    build_by_default: true)
    endforeach
  endforeach
endif
