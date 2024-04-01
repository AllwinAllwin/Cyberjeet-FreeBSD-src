# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2012 Spectra Logic.  All rights reserved.
# Use is subject to license terms.
#


atf_test_case exec_001_pos cleanup
exec_001_pos_head()
{
	atf_set "descr" "Setting exec=on on a filesystem, processes can be executed fromthis file system."
	atf_set "require.progs" "ksh93 zfs"
}
exec_001_pos_body()
{
	export PATH=$(atf_get_srcdir):$PATH
	. $(atf_get_srcdir)/../../include/default.cfg

	verify_disk_count "$DISKS" 1
	ksh93 $(atf_get_srcdir)/setup.ksh || atf_fail "Setup failed"
	ksh93 $(atf_get_srcdir)/exec_001_pos.ksh || atf_fail "Testcase failed"
}
exec_001_pos_cleanup()
{
	. $(atf_get_srcdir)/../../include/default.cfg

	ksh93 $(atf_get_srcdir)/cleanup.ksh || atf_fail "Cleanup failed"
}


atf_test_case exec_002_neg cleanup
exec_002_neg_head()
{
	atf_set "descr" "Setting exec=off on a filesystem, processes can not be executedfrom this file system."
	atf_set "require.progs" "ksh93 zfs"
}
exec_002_neg_body()
{
	PATH=$(atf_get_srcdir):$PATH
	. $(atf_get_srcdir)/../../include/default.cfg

	verify_disk_count "$DISKS" 1
	ksh93 $(atf_get_srcdir)/setup.ksh || atf_fail "Setup failed"
	ksh93 $(atf_get_srcdir)/exec_002_neg.ksh || atf_fail "Testcase failed"
}
exec_002_neg_cleanup()
{
	. $(atf_get_srcdir)/../../include/default.cfg

	ksh93 $(atf_get_srcdir)/cleanup.ksh || atf_fail "Cleanup failed"
}


atf_init_test_cases()
{

	atf_add_test_case exec_001_pos
	atf_add_test_case exec_002_neg
}
