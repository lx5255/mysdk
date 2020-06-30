#include "common.h"
#include "stdio.h"
#include "log.h"

void log(const char *fmt, ...)
{
    printf(fmt, __va_arg_pack ());
}

