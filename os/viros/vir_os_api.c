#include "os_manage.h"

OS_RET  vir_os_start()
{
    retun task_run();
}

OS_RET vir_os_thread_creat(thread_def *def, void *arg)
{
    task_list task;
    if (NULL == def) { 
        return OS_PARAME_ERR;
    }
    memset(&task, 0x0, sizeof(task_list));
    task.name = def->name;
    task.task_func = def->thread_func;
    task.task_init = def->thread_before;
    task.task_exit = def->thread_after; 

    return creat_task(&task, def->msg_size)
}

OS_RET vir_os_thread_delete_by_name(char *name)
{
    
}

OS_RET vir_os_delay(uint32 delay_ms)
{
    
}

uint32 vir_os_sys_tick(void)
{
    
}

static const os_io = {
    .os_start =    
};

