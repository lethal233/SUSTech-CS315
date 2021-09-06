dnl Aircrack-ng
dnl
dnl Copyright (C) 2017 Joseph Benden <joe@benden.us>
dnl
dnl Autotool support was written by: Joseph Benden <joe@benden.us>
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2 of the License, or
dnl (at your option) any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
dnl
dnl In addition, as a special exception, the copyright holders give
dnl permission to link the code of portions of this program with the
dnl OpenSSL library under certain conditions as described in each
dnl individual source file, and distribute linked combinations
dnl including the two.
dnl
dnl You must obey the GNU General Public License in all respects
dnl for all of the code used other than OpenSSL.
dnl
dnl If you modify file(s) with this exception, you may extend this
dnl exception to your dnl version of the file(s), but you are not obligated
dnl to do so.
dnl
dnl If you dnl do not wish to do so, delete this exception statement from your
dnl version.
dnl
dnl If you delete this exception statement from all source files in the
dnl program, then also delete it here.

AC_DEFUN([AIRCRACK_NG_WINDOWS],[
AX_REQUIRE_DEFINED([AC_CHECK_HEADER])[]dnl
AX_REQUIRE_DEFINED([AX_COMPILER_VENDOR])dnl

AC_ARG_ENABLE(win32-portable,
    AS_HELP_STRING([--enable-win32-portable],
        [Enable portable WIN32 edition]),
    [
        AC_DEFINE([WIN32_PORTABLE], [1], [Define if portable WIN32 is supported])
    ], [])

case "$host_os" in
    CYGWIN*|MSYS*|cygwin*|msys*)
        AC_CHECK_FILE(/usr/include/w32api/windows.h, [ CPPFLAGS="$CPPFLAGS -I/usr/include/w32api" ], [])
        AC_CHECK_LIB(w32api, WinMain, [ LIBS="$LIBS -lw32api" ])
        AC_CHECK_HEADER(windows.h, [], [AC_MSG_ERROR([windows.h was not found])])
        CPPFLAGS="$CPPFLAGS -DCYGWIN"
        CFLAGS="$CFLAGS -mconsole -mwindows"
        CXXFLAGS="$CXXFLAGS -mconsole -mwindows"
        LDFLAGS="$LDFLAGS -mconsole -mwindows"

        case "$host_os" in
            MSYS*|msys*)
                CPPFLAGS="$CPPFLAGS -DMSYS2"
                CFLAGS="$CFLAGS -DMSYS2"
                CXXFLAGS="$CXXFLAGS -DMSYS2"
                ;;
        esac

        case "$ax_cv_c_compiler_vendor" in
            clang)
                LIBS="$LIBS -liconv"
            ;;
        esac
        ;;
esac
])
