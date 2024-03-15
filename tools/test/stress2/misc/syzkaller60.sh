#!/bin/sh

# Fatal trap 12: page fault while in kernel mode
# cpuid = 5; apic id = 05
# fault virtual address   = 0x3e07d728
# fault code              = supervisor write data, page not present
# instruction pointer     = 0x20:0xffffffff80c9ba1d
# stack pointer           = 0x28:0xfffffe014d9ceba0
# frame pointer           = 0x28:0xfffffe014d9cec00
# code segment            = base 0x0, limit 0xfffff, type 0x1b
#                         = DPL 0, pres 1, long 1, def32 0, gran 1
# processor eflags        = interrupt enabled, resume, IOPL = 0
# current process         = 3135 (syzkaller60)
# trap number             = 12
# panic: page fault
# cpuid = 5
# time = 1656134459
# KDB: stack backtrace:
# db_trace_self_wrapper() at db_trace_self_wrapper+0x2b/frame 0xfffffe014d9ce960
# vpanic() at vpanic+0x151/frame 0xfffffe014d9ce9b0
# panic() at panic+0x43/frame 0xfffffe014d9cea10
# trap_fatal() at trap_fatal+0x387/frame 0xfffffe014d9cea70
# trap_pfault() at trap_pfault+0xab/frame 0xfffffe014d9cead0
# calltrap() at calltrap+0x8/frame 0xfffffe014d9cead0
# --- trap 0xc, rip = 0xffffffff80c9ba1d, rsp = 0xfffffe014d9ceba0, rbp = 0xfffffe014d9cec00 ---
# soclose() at soclose+0x1ad/frame 0xfffffe014d9cec00
# _fdrop() at _fdrop+0x1b/frame 0xfffffe014d9cec20
# closef() at closef+0x1db/frame 0xfffffe014d9cecb0
# fdescfree() at fdescfree+0x433/frame 0xfffffe014d9ced80
# exit1() at exit1+0x4ef/frame 0xfffffe014d9cedf0
# sys_exit() at sys_exit+0xd/frame 0xfffffe014d9cee00
# amd64_syscall() md64_syscall+0x145/frame 0xfffffe014d9cef30
# fast_syscall_common() at fast_syscall_common+0xf8/frame 0xfffffe014d9cef30
# --- syscall (1, FreeBSD ELF64, sys_exit), rip = 0x82209fdca, rsp = 0x820fab718, rbp = 0x820fab730 ---
# KDB: enter: panic
# [ thread pid 3135 tid 100332 ]
# Stopped at      kdb_enter+0x32: movq    $0,0x129f1a3(%rip)
# db> x/s version
# version:        FreeBSD 14.0-CURRENT #0 main-n256319-c11e64ce51308: Sat Jun 25 07:12:49 CEST 2022\012
# pho@mercat1.netperf.freebsd.org:/usr/src/sys/amd64/compile/PHO
# db>

[ `uname -p` != "amd64" ] && exit 0

. ../default.cfg
cat > /tmp/syzkaller60.c <<EOF
// https://syzkaller.appspot.com/bug?id=c08c1aff3eaffde1197888c66684fabf474f3305
// autogenerated by syzkaller (https://github.com/google/syzkaller)
// Reported-by: syzbot+4b862074650b91e087b4@syzkaller.appspotmail.com

#define _GNU_SOURCE

#include <pwd.h>
#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/endian.h>
#include <sys/syscall.h>
#include <unistd.h>

uint64_t r[2] = {0xffffffffffffffff, 0xffffffffffffffff};

int main(void)
{
  syscall(SYS_mmap, 0x20000000ul, 0x1000000ul, 7ul, 0x1012ul, -1, 0ul);
  intptr_t res = 0;
  res = syscall(SYS_socket, 0x1cul, 1ul, 0x84);
  if (res != -1)
    r[0] = res;
  *(uint8_t*)0x20000000 = 0x1c;
  *(uint8_t*)0x20000001 = 0x1c;
  *(uint16_t*)0x20000002 = htobe16(0x4e22);
  *(uint32_t*)0x20000004 = 0;
  memset((void*)0x20000008, 0, 16);
  *(uint32_t*)0x20000018 = 0;
  syscall(SYS_bind, r[0], 0x20000000ul, 0x1cul);
  syscall(SYS_listen, r[0], 0x40000);
  res = syscall(SYS_socket, 0x1cul, 1ul, 0x84);
  if (res != -1)
    r[1] = res;
  *(uint8_t*)0x20000180 = 0x1c;
  *(uint8_t*)0x20000181 = 0x1c;
  *(uint16_t*)0x20000182 = htobe16(0x4e22);
  *(uint32_t*)0x20000184 = 0;
  *(uint64_t*)0x20000188 = htobe64(0);
  *(uint64_t*)0x20000190 = htobe64(1);
  *(uint32_t*)0x20000198 = 0;
  syscall(SYS_connect, r[1], 0x20000180ul, 0x1cul);
  return 0;
}
EOF
mycc -o /tmp/syzkaller60 -Wall -Wextra -O0 /tmp/syzkaller60.c || exit 1

kldstat | grep -q sctp || { kldload sctp.ko && loaded=1; }
(cd /tmp; timeout 3m ./syzkaller60)

rm -rf /tmp/syzkaller60 /tmp/syzkaller60.c /tmp/syzkaller60.core \
    /tmp/syzkaller.??????
[ $loaded ] && kldunload sctp.ko
exit 0