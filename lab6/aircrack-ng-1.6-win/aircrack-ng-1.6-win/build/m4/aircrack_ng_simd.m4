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

AC_DEFUN([AIRCRACK_NG_SIMD], [
AX_REQUIRE_DEFINED([AX_COMPILER_VENDOR])
AX_REQUIRE_DEFINED([AX_COMPILER_VERSION])
AX_REQUIRE_DEFINED([AX_CHECK_COMPILE_FLAG])
AX_REQUIRE_DEFINED([AX_APPEND_FLAG])

AX_COMPILER_VENDOR
AX_COMPILER_VERSION

OPENBSD=0
IS_X86=0
IS_ARM=0
IS_PPC=0
IS_CROSS=0

if test "$cross_compiling" != yes
then
    IS_CROSS=0
else
    IS_CROSS=1
fi

case "$host_cpu" in
    x86_64 | amd64 | i*86*)
        IS_X86=1
        ;;
    *arm* | *aarch64*)
        IS_ARM=1
        ;;
    *mips*)
        IS_MIPS=1
        ;;
    powerpc*)
        IS_PPC=1
        ;;
esac

case "$host_os" in
    *openbsd* | *OpenBSD*)
        OPENBSD=1
        ;;
esac

AS_IF([test $OPENBSD -eq 0], [
    AC_LANG_CASE([C++], [
        AX_CHECK_COMPILE_FLAG([-masm=intel], [
            AX_APPEND_FLAG(-masm=intel, [opt_cxxflags])
            AC_DEFINE([INTEL_ASM], [1], [Define if Intel assembly style is supported])
        ])
    ])
])

if test $IS_ARM -eq 1
then
    AX_CHECK_COMPILE_FLAG([-Werror -mfpu=neon], [
        AX_APPEND_FLAG(-mfpu=neon, [arm_neon_[]_AC_LANG_ABBREV[]flags])
        AC_SUBST(arm_neon_[]_AC_LANG_ABBREV[]flags)
    ])

    AS_VAR_PUSHDEF([CACHEVAR], [ax_cv_neon_[]_AC_LANG_ABBREV[]flags])
    AC_CACHE_CHECK([whether _AC_LANG compiler supports NEON instructions], CACHEVAR, [
        ax_check_save_flags=$[]_AC_LANG_PREFIX[]FLAGS
        _AC_LANG_PREFIX[]FLAGS="$arm_neon_[]_AC_LANG_ABBREV[]flags $[]_AC_LANG_PREFIX[]FLAGS"
        AC_COMPILE_IFELSE([AC_LANG_SOURCE([[
#if !defined(__ARM_NEON) && !defined(__ARM_NEON__) && !defined(__aarch64) && !defined(__aarch64__)
#error macro not defined
#endif
        ]])], [AS_VAR_SET(CACHEVAR,[yes])], [AS_VAR_SET(CACHEVAR,[no])])
        _AC_LANG_PREFIX[]FLAGS=$ax_check_save_flags
    ])
    AS_IF([test x"AS_VAR_GET(CACHEVAR)" = xyes],
        [NEON_FOUND=1], [NEON_FOUND=0])
    AS_VAR_POPDEF([CACHEVAR])
fi

if test $IS_PPC -eq 1
then
    AX_CHECK_COMPILE_FLAG([-finline-functions], [
        AX_APPEND_FLAG(-finline-functions, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
        AC_SUBST(ppc_altivec_[]_AC_LANG_ABBREV[]flags)
    ])

    AX_CHECK_COMPILE_FLAG([-finline-limit=4000], [
        AX_APPEND_FLAG(-finline-limit=4000, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
        AC_SUBST(ppc_altivec_[]_AC_LANG_ABBREV[]flags)
    ])

    AX_CHECK_COMPILE_FLAG([-fno-strict-aliasing], [
        AX_APPEND_FLAG(-fno-strict-aliasing, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
        AC_SUBST(ppc_altivec_[]_AC_LANG_ABBREV[]flags)
    ])

    AX_CHECK_COMPILE_FLAG([-maltivec], [
        AX_APPEND_FLAG(-maltivec, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
        AC_SUBST(ppc_altivec_[]_AC_LANG_ABBREV[]flags)
    ])

    AX_CHECK_COMPILE_FLAG([-mabi=altivec], [
        AX_APPEND_FLAG(-mabi=altivec, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
        AC_SUBST(ppc_altivec_[]_AC_LANG_ABBREV[]flags)
    ])

    AS_VAR_PUSHDEF([CACHEVAR], [ax_cv_altivec_[]_AC_LANG_ABBREV[]flags])
    AC_CACHE_CHECK([whether _AC_LANG compiler supports VSX instructions], CACHEVAR, [
        ax_check_save_flags=$[]_AC_LANG_PREFIX[]FLAGS
        _AC_LANG_PREFIX[]FLAGS="$ppc_altivec_[]_AC_LANG_ABBREV[]flags -mvsx -mpower8-vector $[]_AC_LANG_PREFIX[]FLAGS"
        AC_COMPILE_IFELSE([AC_LANG_SOURCE([[
#if !defined(__VSX__) && !defined(__POWER8_VECTOR__)
#error macro not defined
#endif
        ]])], [AS_VAR_SET(CACHEVAR,[yes])], [AS_VAR_SET(CACHEVAR,[no])])
        _AC_LANG_PREFIX[]FLAGS=$ax_check_save_flags
    ])
    AS_IF([test x"AS_VAR_GET(CACHEVAR)" = xyes],
        [
            ALTIVEC_FOUND=1
            POWER8_FOUND=1
            AX_APPEND_FLAG(-mvsx, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
            AX_APPEND_FLAG(-mpower8-vector, [ppc_altivec_[]_AC_LANG_ABBREV[]flags])
            AC_SUBST(ppc_altivec_[]_AC_LANG_ABBREV[]flags)
        ], [
            ALTIVEC_FOUND=0
            POWER8_FOUND=0
        ])
    AS_VAR_POPDEF([CACHEVAR])
fi

if test $IS_X86 -eq 0
then
    AC_CHECK_HEADERS([sys/auxv.h], [
        AC_DEFINE([HAS_AUXV], [1], [Define if your system has sys/auxv.h header])
    ])
fi

AC_ARG_WITH(cacheline-size,
    [AS_HELP_STRING([--with-cacheline-size=[width]], [use specific CPU L1 cache-line size, in bytes. [default=64]])])

case $with_cacheline_size in
    no | "") CACHELINE_SIZE=64;;
    *)       CACHELINE_SIZE=$with_cacheline_size;;
esac
AC_SUBST([CACHELINE_SIZE])

AC_DEFINE_UNQUOTED([CACHELINE_SIZE], [$CACHELINE_SIZE], [Define to set the specific CPU L1 cache-line size, in bytes.])

AC_ARG_WITH(static-simd,
    [AS_HELP_STRING([--with-static-simd[[=x86-sse2|x86-avx|x86-avx2|x86-avx512|ppc-altivec|ppc-power8|arm-neon|arm-asimd]], [use specific SIMD implementation at static link, [default=none]]])])

case $with_static_simd in
    no | "")
        ;;
    x86-sse2|x86-avx|x86-avx2|x86-avx512|ppc-altivec|ppc-power8|arm-neon|arm-asimd)
        SIMD_SUFFIX=_$(echo $with_static_simd | tr '[a-z]' '[A-Z]' | tr '-' '_')
        AC_SUBST([SIMD_SUFFIX])

        case "$enable_static,$enable_shared" in
            "yes,yes" | "no,yes" | "no,no" )
                AC_MSG_ERROR([The --with-static-simd option is only valid with static builds.])
                ;;
        esac
        ;;
    *)
        AC_MSG_ERROR([Invalid SIMD given to --with-static-simd option.])
        ;;
esac

AC_ARG_WITH(avx512,
    [AS_HELP_STRING([--with-avx512[[=yes|no]]], [use AVX-512F instruction set, [default=no]])])

if test $IS_X86 -eq 1
then
	case $with_avx512 in
		yes)
			case "$ax_cv_[]_AC_LANG_ABBREV[]_compiler_vendor" in
				intel)
					AX_APPEND_FLAG(-march=skylake-avx512, [x86_avx512_[]_AC_LANG_ABBREV[]flags])
					AC_SUBST(x86_avx512_[]_AC_LANG_ABBREV[]flags)
					AVX512F_FOUND=1
					AC_SUBST([AVX512F_FOUND], [1], [Define if your system supports AVX-512F])
					;;
				*)
					AX_CHECK_COMPILE_FLAG([-mavx512f], [
						AX_APPEND_FLAG(-mavx512f, [x86_avx512_[]_AC_LANG_ABBREV[]flags])
						AC_SUBST(x86_avx512_[]_AC_LANG_ABBREV[]flags)
						AVX512F_FOUND=1
						AC_SUBST([AVX512F_FOUND], [1], [Define if your system supports AVX-512F])
					])
					;;
			esac

			AC_DEFINE_UNQUOTED([AVX512F_FOUND], [$AVX512F_FOUND], [Define to enable AVX-512F buffers.])
			;;
	esac

    case "$ax_cv_[]_AC_LANG_ABBREV[]_compiler_vendor" in
        intel)
            AX_APPEND_FLAG(-march=core-avx2, [x86_avx2_[]_AC_LANG_ABBREV[]flags])
            AC_SUBST(x86_avx2_[]_AC_LANG_ABBREV[]flags)

            AX_APPEND_FLAG(-march=corei7-avx, [x86_avx_[]_AC_LANG_ABBREV[]flags])
            AC_SUBST(x86_avx_[]_AC_LANG_ABBREV[]flags)

            AX_APPEND_FLAG(-march=corei7, [x86_sse2_[]_AC_LANG_ABBREV[]flags])
            AC_SUBST(x86_sse2_[]_AC_LANG_ABBREV[]flags)

            AX_APPEND_FLAG(-march=pentiumii, [x86_mmx_[]_AC_LANG_ABBREV[]flags])
            AC_SUBST(x86_mmx_[]_AC_LANG_ABBREV[]flags)
            ;;
        *)
            AX_CHECK_COMPILE_FLAG([-mavx2], [
                AX_APPEND_FLAG(-mavx2, [x86_avx2_[]_AC_LANG_ABBREV[]flags])
                AC_SUBST(x86_avx2_[]_AC_LANG_ABBREV[]flags)
            ])

            AX_CHECK_COMPILE_FLAG([-mavx], [
                AX_APPEND_FLAG(-mavx, [x86_avx_[]_AC_LANG_ABBREV[]flags])
                AC_SUBST(x86_avx_[]_AC_LANG_ABBREV[]flags)
            ])

            AX_CHECK_COMPILE_FLAG([-msse2], [
                AX_APPEND_FLAG(-msse2, [x86_sse2_[]_AC_LANG_ABBREV[]flags])
                AC_SUBST(x86_sse2_[]_AC_LANG_ABBREV[]flags)
            ])

            AX_CHECK_COMPILE_FLAG([-mmmx], [
                AX_APPEND_FLAG(-mmmx, [x86_mmx_[]_AC_LANG_ABBREV[]flags])
                AC_SUBST(x86_mmx_[]_AC_LANG_ABBREV[]flags)
            ])
            ;;
    esac
fi

AM_CONDITIONAL([X86], [test "$IS_X86" = 1])
AM_CONDITIONAL([ARM], [test "$IS_ARM" = 1])
AM_CONDITIONAL([PPC], [test "$IS_PPC" = 1])
AM_CONDITIONAL([NEON], [test "$NEON_FOUND" = 1])
AM_CONDITIONAL([AVX512F], [test "$AVX512F_FOUND" = 1])
AM_CONDITIONAL([ALTIVEC], [test "$ALTIVEC_FOUND" = 1])
AM_CONDITIONAL([POWER8], [test "$POWER8_FOUND" = 1])
])

AC_DEFUN([AIRCRACK_NG_SIMD_C], [
AC_LANG_PUSH([C])
AIRCRACK_NG_SIMD
AC_LANG_POP([C])
])

AC_DEFUN([AIRCRACK_NG_SIMD_CXX], [
AC_LANG_PUSH([C++])
AIRCRACK_NG_SIMD
AC_LANG_POP([C++])
])
