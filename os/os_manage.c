#include "common.h"
#include "os_manage.h"

OS_RET  os_start()
{
    return OS_OK;
}

OS_RET os_thread_creat(thread_def *def, void *arg)
{
    return OS_OK;
}

OS_RET os_thread_delete_by_name(char *name)
{
    return OS_OK;
}

OS_RET os_delay(uint32 delay_ms)
{
    return OS_OK;
}

uint32 os_sys_tick(void)
{
    return OS_OK;
}

OS_RET os_sem_creat()
{
    return OS_OK;
}

OS_RET os_sem_wait()
{
    return OS_OK;
}

OS_RET os_sem_relese()
{
    return OS_OK;
}
